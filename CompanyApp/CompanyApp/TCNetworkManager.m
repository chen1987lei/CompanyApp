//
//  TCNetworkManager.m
//  tanzhi
//
//  Created by HanKui on 11-5-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TCNetworkManager.h"
#import "NSData+Base64.h"
#import "CinMessageReader.h"
#import "CinClient.h"
#import "CinUser.h"
#import "define.h"
#import "TCDbOpreater.h"
#import "CinResponse.h"
#import "TCGroupSessionContact.h"
#import "UserConfig.h"
#import "TCCallBacks.h"
#import "tanzhiAppDelegate.h"
#import "TanZhiLog.h"
#import "StatusBarData.h"
//打招呼补偿逻辑才会用到，server提供好接口后该逻辑消失 
#import "CinExport.h"
#import "TCSingleSessionManager.h"
#import "TCImageReceivingManager.h"
#import "TCImageSendingManager.h"
#import "TCNoticeManager.h"
#import "TCAudioManager.h"
#import "TCGroupSessionManager.h"
#import "TCBuddyManager.h"
#import "TCMiscellaneousManager.h"
#import "TCSocialityServiceManager.h"

#import <Security/Security.h>
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "JSON.h"
#import "CinRunLoopActionManager.h"

@interface TCNetworkManager(private)

-(void)uploadContactAddressListInBizThread;
//main thread
-(void)onConnectedInMainThread;
-(void)onRegisteredInMainThread;
-(void)onTakeVisitingCardInMainThread;
-(void)onTakePortraitInMainThread:(NSString *)sessionID;
-(void)onRegisterFailedInMainThread;
-(void)onRegisterFailedNeedReregInMainThread;
-(void)onCheckCredentialFailedInMainThread;
-(void)onDisconnectedInMainThread;
-(void)onConnectFailedInMainThread;
-(void)getingHeadImageFinishedInMainThread;
-(void)onAddBuddyAgreeInMainThread:(TCContact *)contact;
-(void)onAddBuddyRefuseInMainThread:(TCContact *)contact;
-(void)onAddBuddyReceivedInMainThread:(NSDictionary *)param;
-(void)onSayHiNotifyReceivedInMainThread:(NSMutableDictionary*)dic;
-(void)sayHiInMainThread:(TCContact *)contact;
-(void)checkUpDateInMainThread:(NSDictionary *)userInfo;
-(void)onJoinGroupInMainThread:(TCGroupSession *)gs;
-(void)notifySayHiReceivedInMainThread:(NSDictionary *)sayHiNoticeDic;

//socket thread
- (void)timerFiredInBizThread:(NSTimer *)timer;
-(void)takeVisitingCardInBizThread:(NSString*)uid;
-(void)beginConnect2ServerInBizThread:(AccountInfo*) accountInfo;
//-(void)createGroupInBizThread:(TCGroupSession*) gs;
-(void)updateMyInformationInBizThread:(NSMutableDictionary*)pram;
-(void)disconnectInBizThread;
-(void)uploadPortraitInBizThread:(NSMutableDictionary*)param;
-(void)takePortraitInBizThread:(NSNumber *)uid;
-(void)setApplePushTypeInBizThread:(NSMutableDictionary *)param;
-(void)setReceiveFetionMessageInBizThread:(NSMutableDictionary *)param;


-(void) getInTouchInBizThread:(NSMutableDictionary *)param;
-(void) acceptTouchMeInBizThread:(NSMutableDictionary *)param;
-(void) refuseTouchMeInBizThread:(NSMutableDictionary *)param;
-(void) agreeAddFetionBuddyInBizThread:(NSMutableDictionary *)param;
-(void) refuseAddFetionBuddyInBizThread:(NSMutableDictionary *)param;
-(void) addFetionBuddyInBizThread:(NSMutableDictionary *)param;
-(void) sendMutipleMessageInBizThread:(NSMutableDictionary *)param;
-(void) sendMutipleMessageImageInBizThread:(NSMutableDictionary *)param;
-(void) sayHiInBizThread:(NSMutableDictionary *)param;
-(void) sendMutipleMessageVoiceInBizThread:(NSMutableDictionary *)param;
-(void) getMatchResultInBizThread:(TCGetMatchResultCallBack*)callback;

//- (void)addNewContactFinishedPrivate;
- (void)getingHeadImageFinished;
@end

@implementation TCNetworkManager


static TCNetworkManager * _sharedInstance = nil;

@synthesize delegate = _delegate;
//@synthesize cinClient = _cinClient;
@synthesize accountMobile;
@synthesize smschkDomain;
@synthesize networkStatus = _networkStatus;
@synthesize bizThread = _bizThread;

+ (TCNetworkManager *)sharedInstance
{
    @synchronized (self) 
	{
        if (_sharedInstance == nil) 
		{
            _sharedInstance = [[self alloc] init];
		}
    }
    return _sharedInstance;
}

-(id)init
{
	self = [super init];
    if(self != nil){
        _networkStatus = TCNotReachable;
        _bizThread = [ businessRunLoopActionManager() attachedThread ];
    }
    return self;
}
-(void)dealloc{
    [_domainName release];
    [smschkCredential release];
    [smschkDomain release];
    [super dealloc];
}

-(NSString*) getAccountMobile{
	return _currentAccount.strMoblie;
}

//＝＝＝＝＝＝ check update functions ＝＝＝＝＝＝＝＝＝
- (void) CheckForUpdate
{
	//navURL string
    NSString * navUrl = [NSString stringWithFormat:@"%@?cver=%@&no=%@", 
						 url_getnav, ios_version, [Utility getEncodedPhoneNumber:_currentAccount.strMoblie]];
	NSLog(@"开始检查有无新版本......url=%@", navUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:navUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(checkUpdateRequestDidFinished:)];
	[request setDidFailSelector:@selector(checkUpdateRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)checkUpdateRequestDidFinished:(ASIHTTPRequest *)request
{
    NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	
    //set response code
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
	//set the new client URL
	NSString *newClientAddress = [[rsp getBody] getString];
	if (newClientAddress != nil)
	{
		[userinfo setObject:newClientAddress forKey:@"DownloadUrl"];
	}
	
    [self performSelectorOnMainThread:@selector(checkUpDateInMainThread:) withObject:userinfo waitUntilDone:NO];
}

-(void)checkUpdateRequestDidFailed:(ASIHTTPRequest *)request
{
	NSLog(@"checkUpdateRequestDidFailed.检查更新失败,可能是网络问题!");
}


//＝＝＝＝＝＝ nav functions ＝＝＝＝＝＝＝＝＝
- (void) GetNav:(NSString*)version Url:(NSString*)url AccountInfo:(AccountInfo*)accountInfo
{
    if(accountInfo.strMoblie == nil) accountInfo.strMoblie = 0;
	//navURL string
    NSString * navUrl = [NSString stringWithFormat:@"%@?cver=%@&no=%@", 
						 url, version, [Utility getEncodedPhoneNumber:accountInfo.strMoblie]];
	NSLog(@"<TCNetworkManager> GetNav:开始获取导航...... navUrl=%@", navUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:navUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(navRequestDidFinished:)];
	[request setDidFailSelector:@selector(navRequestDidFailed:)];
	[request startAsynchronous];
	//save a copy of accountInfo for callback using
}

//nav ok callback
-(void)navRequestDidFinished:(ASIHTTPRequest *)request
{	
    [_getNavSuccessedTime release];
    _getNavSuccessedTime = [[NSDate date] retain];
	NSString * encodedString = [request responseString];
    NSLog(@"<TCNetworkManager> navRequestDidFinished connect_log :获取导航 ok encodedString=%@" ,encodedString);
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    
    CinResponse * message = (CinResponse *)[CinMessageReader load:decodedData];    
    
 	//处理升级逻辑
	NSString *newClientAddress = [[message getBody] getString];
	if (newClientAddress != nil && (!_currentAccount.isShowUpdateInfo))
	{
        _currentAccount.isShowUpdateInfo = YES;
        
        NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];	
        //set response code
        [userinfo setObject:[NSNumber numberWithInteger:[message getStatusCode]] forKey:@"responseCode"];
		[userinfo setObject:newClientAddress forKey:@"DownloadUrl"];
        
        [self performSelectorOnMainThread:@selector(checkUpDateInMainThread:) withObject:userinfo waitUntilDone:NO];   
	}	
    NSString * from = [[message From] getString];
    if(from == nil){
        tanZhiErrorLog(@"<TCNetworkManager> navRequestDidFinished from是nil");
        return;
    }
    NSRange range = [from rangeOfString:@":"];
    BOOL registSuccessFirstGetNav = (_currentAccount.ip==nil ? YES : NO);
    if(range.length == 0){
        _currentAccount.ip = [NSString stringWithString:from];
        _currentAccount.port = 8080;
    } 
	else {
        _currentAccount.ip = [NSString stringWithString:[from substringToIndex:range.location]];
        NSString * port = [from substringFromIndex:(range.location + 1)];
        _currentAccount.port = [port intValue];
    }
    
    //更新配置中的ip和port
	[[UserConfig shareConfig] updateAccountInfo:_currentAccount];
    [[UserConfig shareConfig] saveConfig];
    
	//注册成功，第一次获取导航也成功，链接server
    if (registSuccessFirstGetNav)
    {
        NSLog(@"<TCNetworkManager> navRequestDidFinished uid:%lld will connect to server ip=%@ port=%d",_cinUser.UserId, _currentAccount.ip, _currentAccount.port);
        [self beginConnect2Server:_currentAccount];
    }
}

- (BOOL) beginConnect2Server:(AccountInfo*) accountInfo{
    [_currentAccount release];
    _currentAccount = [accountInfo retain];
    tanZhiInfoLog(@"<TCNetworkManager>beginConnect2Server connect_log accountInfo.ip=%@ accountInfo.port=%d accountInfo=%@",accountInfo.ip, accountInfo.port, accountInfo);
    if(accountInfo.ip != nil && accountInfo.port != 0){
        [self performSelector:@selector(beginConnect2ServerInBizThread:) onThread:_bizThread withObject:accountInfo waitUntilDone:NO];
        return YES;
    }else{
        return NO;
    }
}

//nav fail callback
-(void)navRequestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"<TCNetworkManager> navRequestDidFailed:获取导航 失败");
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerNavFailed)])
	{
		[_delegate TCNetworkManagerNavFailed];
	}
}

//＝＝＝＝＝＝＝ Regist functions ＝＝＝＝＝＝＝＝
-(void) Regist:(NSString*)version Url:(NSString*)url Mobile:(NSString*) mobile
{
	//regURL string
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&no=%@&oem=%@", 
						 url, version, [Utility getEncodedPhoneNumber:mobile],readStr ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(registRequestDidFinished:)];
	[request setDidFailSelector:@selector(registRequestDidFailed:)];
	[request startAsynchronous];
}

//regist ok callback
-(void)registRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"registRequestDidFinished");
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	//set response code
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
	//set the new client URL
	NSString *newClientAddress = [[rsp getBody] getString];
	if (newClientAddress != nil)
	{
		[userinfo setObject:newClientAddress forKey:@"newClientDownloadUrl"];
	}
	
	//post notityRegistResult
	
    [[NSNotificationCenter defaultCenter] postNotificationName:notityRegistResult 
														object:nil 
													  userInfo:userinfo];
}

//regist fail callback
-(void)registRequestDidFailed:(ASIHTTPRequest *)request
{
	//[Utility showMessageBox:@"注册失败,可能是网络问题!"];
	NSLog(@"registRequestDidFailed.");
}

//-(CinClientCore*)getCinClientCore{
//    return _cinClient.mCore;
//}

#pragma mark -
#pragma mark MobilePwdRegister 飞信登录1
//add by laim  手机密码登-----------------------------------------------------------------
-(void)mobilePwdRegister:(NSString*)version Url:(NSString*)url Mobile:(NSString*) mobile
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&no=%@&oem=%@", 
						 url, version, [Utility getEncodedPhoneNumber:mobile],readStr];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(pwdRegRequestDidFinished:)];
	[request setDidFailSelector:@selector(pwdRegRequestDidFailed:)];
	[request startAsynchronous];
}

//regist ok callback
-(void)pwdRegRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"registRequestDidFinished");
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse *)[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	
    // [NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeKey] getValue]]
	//set response data
    if ([rsp getStatusCode]==0x80)
    {
        [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
        [userinfo setObject:[NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeFrom] getInt64]] forKey:@"userId"];
        [userinfo setObject:[[rsp getHeader:CinHeaderTypeKey] getValue] forKey:@"serverKey"];
        [userinfo setObject:[[rsp getHeader:CinHeaderTypeCredential] getString] forKey:@"domain"]; 
    }
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
	//发送验证注册短信成功通知 ==> ApplicationDelegate
	[[NSNotificationCenter defaultCenter] postNotificationName:notifymobilePwdRegisterResult 
														object:nil 
													  userInfo:userinfo];
}

//regist fail callback
-(void)pwdRegRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifymobilePwdRegisterResult// notityRegistResult 输入手机号码等待验证码
														object:nil 
													  userInfo:userinfo];
	NSLog(@"registRequestDidFailed.");
}

#pragma mark -
#pragma mark MobilePwdChk 飞信登录2


//add by laim  手机密码登-----------------------------------------------------------------
-(void)mobilePwdChk:(NSString*)version Url:(NSString*)url Mobile:(NSString*) mobile Regkey:(NSString*) regkey
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?&no=%@&k=%@&oem=%@&v=1", 
						 url, [Utility getEncodedPhoneNumber:mobile],regkey,readStr ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(pwdChkRequestDidFinished:)];
	[request setDidFailSelector:@selector(pwdChkRequestDidFailed:)];
	[request startAsynchronous];
}

//regist ok callback
-(void)pwdChkRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"PwdChkRequestDidFinished");
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse *)[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	
	//set response data
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    if ([rsp getStatusCode]==0x80)
    {
        [userinfo setObject:[NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeFrom] getInt64]] forKey:@"userId"];
        [userinfo setObject:[[rsp getHeader:CinHeaderTypeName] getString] forKey:@"feitionNikName"];
        [userinfo setObject:[[rsp getHeader:CinHeaderTypeToken] getValue] forKey:@"token"];
        [userinfo setObject:[[rsp getHeader:CinHeaderTypePassword] getValue] forKey:@"password"]; 
        
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
	
	//发送验证注册短信成功通知 ==> ApplicationDelegate
	[[NSNotificationCenter defaultCenter] postNotificationName:notifymobileChkRegisterResult 
														object:nil 
													  userInfo:userinfo];
}

//regist fail callback
-(void)pwdChkRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifymobileChkRegisterResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"PwdChkRequestDidFailed.");
}


#pragma mark -
#pragma mark new sms register 飞聊注册1
-(void) newRegistSMS:(NSString*)version Mobile:(NSString*) mobile
{
	//regURL string
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?no=%@&cver=%@&oem=%@", 
						 url_new_smsreg, [Utility getEncodedPhoneNumber:mobile],version, readStr ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(newRegistRequestDidFinished:)];
	[request setDidFailSelector:@selector(newRegistRequestDidFailed:)];
	[request startAsynchronous];
}

//regist ok callback
-(void)newRegistRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"registRequestDidFinished");
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	//set response code
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    [userinfo setObject:[NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeKey] getInt64]] forKey:@"key"];
    //set the msg
	NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
	
	//post notityRegistResult
	
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNewFeilioMobileRegResult// notityRegistResult 输入手机号码等待验证码
														object:nil 
													  userInfo:userinfo];
}

-(void)newRegistRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNewFeilioMobileRegResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"registRequestDidFailed.");
}


#pragma mark -
#pragma mark new sms CHK 飞聊注册2
-(void) newRegistSMSCheck:(NSString*)sms userInputMobile:(NSString*)mobile
{
	//registSMSCheck string
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regchkUrl = [NSString stringWithFormat:@"%@?c=%@&no=%@&oem=%@", 
							url_new_smschk ,sms,[Utility getEncodedPhoneNumber:mobile],readStr];
    [readStr release];
	NSLog(@"RegistSMSCheck url=%@", regchkUrl);
	//issue the http request for regist check
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regchkUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(newRegistSMSCheckRequestDidFinished:)];
	[request setDidFailSelector:@selector(newRegistSMSCheckRequestDidFailed:)];
	[request startAsynchronous];
}


//registSMSCheck ok callback
-(void)newRegistSMSCheckRequestDidFinished:(ASIHTTPRequest *)request
{
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse *)[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	
    [smschkDomain release];
    [smschkCredential release];
    
    //set response data
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
	[userinfo setObject:[NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeFrom] getInt64]] forKey:@"userId"];
	smschkCredential= [[rsp getHeader:CinHeaderTypeCredential] getValue];
	[userinfo setObject:[NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeCredential] getInt64]] forKey:@"password"];
    smschkDomain = [[rsp getHeader:CinHeaderTypeIndex] getString];
    // [userinfo setObject:[[rsp getHeader:CinHeaderTypeIndex] getString] forKey:@"domain"];  
    
    [smschkDomain retain];
    [smschkCredential retain];
    
	NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
	//发送验证注册短信成功通知 ==> ApplicationDelegate
	[[NSNotificationCenter defaultCenter] postNotificationName:notifyNewFeilioMobileChkResult  //notifyCheckSMSResult  输入验证码等待结果
														object:nil 
													  userInfo:userinfo];
}

-(void)newRegistSMSCheckRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNewFeilioMobileChkResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"registSMSCheckRequestDidFailed.");
}

#pragma mark -
#pragma mark new SMS setPwd 飞聊注册3
#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH
- (NSData *)getHashBytes:(NSData *)userdata {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[userdata bytes], [userdata length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    
    if (hashBytes) free(hashBytes);
    
    return hash;
}

-(void)newRegistSMSSetPwd:(NSString*) mobile  password:(NSString*)password Userid:(NSNumber*)userID
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    if(password == nil)
    {
        NSString * regUrl = [NSString stringWithFormat:@"%@?c=%@&no=%@&oem=%@&v=1",url_new_setpwd,[smschkCredential cinBase64Encoding],[Utility getEncodedPhoneNumber:mobile],readStr ];
        [readStr release];
        NSLog(@"Regist url=%@", regUrl);
        //issue the http request for nav
        ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setTimeOutSeconds:30];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(newSMSSetPwdDidFinished:)];
        [request setDidFailSelector:@selector(newSMSSetPwdDidFailed:)];
        [request startAsynchronous];
        return;
    }
    //P1:    MD5(sha1(userid[4 bytes]+sha1(domain:password)))
    //P2:    MD5(userid[String]+”@”+domain  +”:”+password)
    NSMutableString* pwd = [NSString stringWithString:password]; 
    NSMutableString* domain =  [NSMutableString stringWithFormat:@"%@:%@",smschkDomain,pwd];  //domain:password
    
    int i = [userID longLongValue];
    NSData* uid = [[[NSData alloc] initWithBytes: &i length: 4] autorelease];
    
    //sha1(domain:password)
    NSData* sha1_pwd = [self getHashBytes:[domain dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    NSMutableData *data = [[NSMutableData alloc] initWithData:uid];
    [data appendData:sha1_pwd];
    
    //P1:MD5(sha1(userid[4 bytes]+sha1(domain:password)))
    NSData* md5source = [self getHashBytes:data];
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5([md5source bytes], [md5source length], md5);
    [data release];
    
    //MD5(sha1(userid[4 bytes] +sha1(domain:password)
    NSMutableData* md5sha1sha1 = [NSMutableData dataWithBytes:md5 length:CC_MD5_DIGEST_LENGTH];
    
    //userid[String]+”@”+ domain +”:” +password
    NSMutableString* uidAtDomainPwdStr = [NSMutableString stringWithFormat:@"%@", [userID stringValue]]; 
    [uidAtDomainPwdStr appendFormat:@"@%@",domain];
    NSData* uidAtDomainPwdPtr = [uidAtDomainPwdStr dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char md5uidAtDomainPwd[CC_MD5_DIGEST_LENGTH];               
    CC_MD5([uidAtDomainPwdPtr bytes], [uidAtDomainPwdPtr length], md5uidAtDomainPwd); 
    NSMutableData * md5uidAtDomainPwd_result = [NSMutableData dataWithBytes:md5uidAtDomainPwd length:CC_MD5_DIGEST_LENGTH];
    
    //md5sha1sha1 + md5uidAtDomainPwd
    [md5sha1sha1 appendData:md5uidAtDomainPwd_result];
    NSString* encodedKey = [md5sha1sha1 cinBase64Encoding];
    //------------------------------------------------------------          
    NSString * regUrl = [NSString stringWithFormat:@"%@?c=%@&no=%@&p=%@&oem=%@&v=1",url_new_setpwd,[smschkCredential cinBase64Encoding],[Utility getEncodedPhoneNumber:mobile],encodedKey,readStr ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(newSMSSetPwdDidFinished:)];
	[request setDidFailSelector:@selector(newSMSSetPwdDidFailed:)];
	[request startAsynchronous];
}

//regist ok callback
-(void)newSMSSetPwdDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"PwdChkRequestDidFinished");
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse *)[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	
	//set response data
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
	
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([rsp getStatusCode]==0x80)
    {
        NSData *token = [[rsp getHeader:CinHeaderTypeToken] getValue];
        NSData *pwd = [[rsp getHeader:CinHeaderTypePassword] getValue];
        NSString *name = [[rsp getHeader:CinHeaderTypeName] getString];
        [userinfo setObject:token forKey:@"token"];
        [userinfo setObject:pwd forKey:@"password"];
        [userinfo setObject:name==nil?@"":name forKey:@"fetionNickName"];
        
        tanZhiDebugLog(@"<TCNetworkManager>newSMSSetPwdDidFinished token=%@ pwd=%@ name=%@",token,pwd,name);
    }
    else
    {
        
    }
    
    
    //NSNumber* num = [NSNumber numberWithInteger:[rsp getStatusCode]];
	//发送验证注册短信成功通知 ==> ApplicationDelegate
	[[NSNotificationCenter defaultCenter] postNotificationName:notifyNewFeilioMobilePwdResult
														object:nil 
													  userInfo:userinfo];
}

//regist fail callback
-(void)newSMSSetPwdDidFailed:(ASIHTTPRequest *)request
{    
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNewFeilioMobilePwdResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"newSMSSetPwdDidFailed.");
}

-(void)getMobileRegistSMSInfo
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&oem=%@&v=1", 
						 url_mosms,ios_version,readStr];
	[readStr release];
    
	//issue the http request
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getMobileRegistSMSInfoDidFinished:)];
	[request setDidFailSelector:@selector(getMobileRegistSMSInfoDidFailed:)];
	[request startAsynchronous];
}

-(void)getMobileRegistSMSInfoDidFinished:(ASIHTTPRequest *)request
{
    NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    
    CinMessage *msg = [CinMessageReader load:decodedData];
    NSString *infoString = [[msg getBody] getString];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    if (infoString)
    {
        [param setObject:infoString forKey:@"info"];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyGetMobileRegistInfo object:nil userInfo:param];
    
}

-(void)getMobileRegistSMSInfoDidFailed:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyGetMobileRegistInfo object:nil userInfo:nil];
}

#pragma mark - 
#pragma mark 手机号注册新接口  2012.5.2

-(NSString *)getSha1DomainPsd:(NSString *)psd
{
    NSMutableString* domain =  [NSMutableString stringWithFormat:@"%@:%@",_domainName,psd];
    NSString* sha1_pwd = [[self getHashBytes:[domain dataUsingEncoding:NSUTF8StringEncoding]] cinBase64Encoding]; 
    return sha1_pwd;
}

-(void) getMobileRegistDomain
{
    NSString * regUrl = [NSString stringWithFormat:@"%@?m=1", 
						 url_getDomain];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getMobileRegistDomainRequestDidFinished:)];
	[request setDidFailSelector:@selector(getMobileRegistDomainRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)getMobileRegistDomainRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"getMobileRegistDomainRequestDidFinished 1");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    [_domainName release];
    _domainName = [[[rsp getHeader:0x01] getString] retain];
    if (_domainName)
    {
        [userinfo setObject:_domainName forKey:@"domainName"];
    }
    
    NSString *resetPwdMoNo = [NSString stringWithFormat:@"%lld",[[rsp getHeader:0x02] getInt64]];
    [userinfo setObject:resetPwdMoNo forKey:@"resetPwdMoNo"];
    
    NSString *resetPwdLink = [[rsp getHeader:0x03] getString];
    if (resetPwdLink)
    {
        [userinfo setObject:resetPwdLink forKey:@"resetPwdLink"];
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyGetDomainInfo
														object:nil 
													  userInfo:userinfo];
}

-(void)getMobileRegistDomainRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyGetDomainInfo
														object:nil 
													  userInfo:userinfo];
	NSLog(@"getMobileRegistDomainRequestDidFailed.");
}

-(void) mobileRegistFirstStep:(NSString *) mobile
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&no=%@&oem=%@", 
						 url_getSMS,ios_version, [Utility getEncodedPhoneNumber:mobile],readStr ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mobileRegistFirstStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mobileRegistFirstStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mobileRegistFirstStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mobileRegistFirstStepRequestDidFinished 1");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    long long expire = [[rsp getHeader:CinHeaderTypeExpire] getInt64];
    [userinfo setObject:[NSNumber numberWithLongLong:expire] forKey:@"expire"];
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMobileRequestSMSResult object:nil userInfo:userinfo];
}

-(void)mobileRegistFirstStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMobileRequestSMSResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"mobileRegistFirstStepRequestDidFailed.");
}

-(void) mobileRegistSecondStep:(NSString *) mobile 
                  andDomainPsd:(NSString *)domainPsd
{
    NSString *tempPsd = [self getSha1DomainPsd:domainPsd];
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&p=%@&no=%@", 
						 url_checkSmS,ios_version, tempPsd,[Utility getEncodedPhoneNumber:mobile] ];
    NSLog(@"Regist url=%@", regUrl);
    
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mobileRegistSecondStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mobileRegistSecondStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mobileRegistSecondStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mobileRegistSecondStepRequestDidFinished 2");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    NSString *name = [[rsp getHeader:01] getString];
    if (name)
    {
        [userinfo setObject:name forKey:@"name"];
    }
    NSString *nickName = [[rsp getHeader:02] getString];
    if (nickName)
    {
        [userinfo setObject:nickName forKey:@"nickName"];
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMobileCheckSMSResult object:nil userInfo:userinfo];
}

-(void)mobileRegistSecondStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMobileCheckSMSResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"mobileRegistSecondStepRequestDidFailed.");
}

-(void) mobileRegistThirdStep:(NSString *)mobile 
                 andDomainPsd:(NSString *)domainPsd 
                      andName:(NSString *)name 
                  andNickName:(NSString *)nickName
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString *tempPsd = [self getSha1DomainPsd:domainPsd];
    NSData *cinName = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cinNickName = [nickName dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&p=%@&n=%@&no=%@&oem=%@&v=1&nn=%@", 
						 url_Regsms,ios_version,tempPsd,[cinName cinBase64Encoding],[Utility getEncodedPhoneNumber:mobile],readStr,[cinNickName cinBase64Encoding] ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mobileRegistThirdStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mobileRegistThirdStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mobileRegistThirdStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mobileRegistThirdStepRequestDidFinished ");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    NSNumber *userID = [NSNumber numberWithLongLong:[[rsp getHeader:0x01] getInt64]];
    if (userID)
    {
        [userinfo setObject:userID forKey:@"userID"];
    }
    NSData *token = [[rsp getHeader:0x07] getValue];
    if (token)
    {
        [userinfo setObject:token forKey:@"token"];
    }
    NSData *password = [[rsp getHeader:0x08] getValue];
    if (password)
    {
        [userinfo setObject:password forKey:@"psd"];
    }
    
    NSNumber *mobile = [NSNumber numberWithLongLong:[[rsp getHeader:0x11] getInt64]];
    if(mobile)
    {
        [userinfo setObject:mobile forKey:@"mobile"];
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult object:nil userInfo:userinfo];
}

-(void)mobileRegistThirdStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"mobileRegistSecondStepRequestDidFailed.");
}

#pragma mark - 
#pragma mark 飞信帐号登录
-(void)fetionUserReg1:(NSString *)mobile 
         andDomainPsd:(NSString *)domainPsd
{
    NSString *tempPsd = [self getSha1DomainPsd:domainPsd];
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&p=%@&no=%@", 
						 url_checkfetionpwd,ios_version, tempPsd,[Utility getEncodedPhoneNumber:mobile] ];
    NSLog(@"Regist url=%@", regUrl);
    
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(fetionUserReg1RequestDidFinished:)];
	[request setDidFailSelector:@selector(fetionUserReg1RequestDidFailed:)];
	[request startAsynchronous];
}

-(void)fetionUserReg1RequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"fetionUserReg1RequestDidFinished");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    NSString *name = [[rsp getHeader:01] getString];
    if (name)
    {
        [userinfo setObject:name forKey:@"name"];
    }
    NSString *nickName = [[rsp getHeader:02] getString];
    if (nickName)
    {
        [userinfo setObject:nickName forKey:@"nickName"];
    }
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginMobileNumberResult object:nil userInfo:userinfo];
}

-(void)fetionUserReg1RequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginMobileNumberResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"fetionUserReg1RequestDidFailed.");
}

-(void) fetionUserReg2:(NSString *)mobile
          andDomainPsd:(NSString *)domainPsd 
               andName:(NSString *)name 
           andNickName:(NSString *)nickName
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString *tempPsd = [self getSha1DomainPsd:domainPsd];
    NSData *cinName = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cinNickName = [nickName dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?cver=%@&p=%@&n=%@&no=%@&oem=%@&v=1&nn=%@", 
						 url_regfetionuser,ios_version,tempPsd,[cinName cinBase64Encoding],[Utility getEncodedPhoneNumber:mobile],readStr,[cinNickName cinBase64Encoding] ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(fetionUserReg2RequestDidFinished:)];
	[request setDidFailSelector:@selector(fetionUserReg2RequestDidFailed:)];
	[request startAsynchronous];
}

-(void)fetionUserReg2RequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"fetionUserReg2RequestDidFinished");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSNumber *userID = [NSNumber numberWithLongLong:[[rsp getHeader:0x01] getInt64]];
    if (userID)
    {
        [userinfo setObject:userID forKey:@"userID"];
    }
    NSData *token = [[rsp getHeader:0x07] getValue];
    if (token)
    {
        [userinfo setObject:token forKey:@"token"];
    }
    NSData*password = [[rsp getHeader:0x08] getValue];
    if (password)
    {
        [userinfo setObject:password forKey:@"psd"];
    }
    
    NSString *mobile = [NSString stringWithFormat:@"%lld",[[rsp getHeader:0x11] getInt64]];
    [userinfo setObject:mobile forKey:@"mobile"];
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult object:nil userInfo:userinfo];
}

-(void)fetionUserReg2RequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"fetionUserReg2RequestDidFailed.");
}

#pragma mark -
#pragma mark  邮箱注册1
-(void) mailRegistFirstStep :(NSString*) mail
{
	//regURL string
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?m=%@&cver=%@&oem=%@&v=1", 
						 url_getemailuid, mail,ios_version, readStr ];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mailRegistFirstStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mailRegistFirstStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mailRegistFirstStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mailRegistRequestDidFinishedStep 1");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSNumber *userID = [NSNumber numberWithLongLong:[[rsp getHeader:0x01] getInt64]];
    if ([[rsp getHeader:0x01] getInt64] != 0)
    {
        [userinfo setObject:userID forKey:@"UserID"];
    }
    if ([rsp getStatusCode] == CinResponseCodeNotExist) 
    {
        NSString *rule = [[rsp getHeader:0x02] getString];
        if (rule)
        {
            [userinfo setObject:rule forKey:@"rule"];
        }
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMailAccountResult object:nil userInfo:userinfo];
}

-(void)mailRegistFirstStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMailAccountResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"notifyMailRegistInfo Failed step1.");
}

#pragma mark -
#pragma mark  邮箱注册2
-(void) mailRegistSecondStep :(NSString*) mail 
                      andName:(NSString *)name 
                  andNickname:(NSString *)nickName
                       andPsd:(NSString *)psd
{
	//regURL string
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSData *cinName = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cinNickName = [nickName dataUsingEncoding:NSUTF8StringEncoding];
    NSData *psdData = [psd dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?m=%@&n=%@&nn=%@&cver=%@&oem=%@&v=1&p=%@", 
						 url_sendmail, mail, [cinName cinBase64Encoding], [cinNickName cinBase64Encoding],ios_version, readStr,[psdData cinBase64Encoding]];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mailRegistSecondStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mailRegistSecondStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mailRegistSecondStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mailRegistRequestDidFinishedStep");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
//    NSString *ErrorMessage = [[rsp getHeader:0x01] getString];
//    if (ErrorMessage)
//    {
//        [userinfo setObject:ErrorMessage forKey:@"body"];
//    }
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    NSString *mailAddress = [[rsp getHeader:0x02] getString];
    if (mailAddress)
    {
        [userinfo setObject:mailAddress forKey:@"mailAddress"];
    }
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult object:nil userInfo:userinfo];
}

-(void)mailRegistSecondStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"notifyMailRegistInfo Failed step2.");
}

#pragma mark - 
#pragma mark 邮箱登录1
-(void) mailLoginFirstStep :(NSString*) mail 
                     andPsd:(NSString *)psd
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString *tempPsd = [self getSha1DomainPsd:psd];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?m=%@&cver=%@&oem=%@&v=1&p=%@", 
						 url_checkmail, mail,ios_version, readStr,tempPsd];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mailLoginFirstStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mailLoginFirstStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mailLoginFirstStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mailLoginRequestDidFinishedStep 1");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSString *Name = [[rsp getHeader:0x01] getString];
    if (Name)
    {
        [userinfo setObject:Name forKey:@"name"];
    }
    else
    {
        tanZhiErrorLog(@"mailLoginSecondStepRequestDidFinished name = nil" );
    }
    
    NSString *Nickname = [[rsp getHeader:0x02] getString];
    if (Nickname)
    {
        [userinfo setObject:Nickname forKey:@"nickName"];
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginMailAccountResult object:nil userInfo:userinfo];
}

-(void)mailLoginFirstStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginMailAccountResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"notifyMailLoginInfo Failed step1.");
}

#pragma mark - 
#pragma mark 邮箱登录2
-(void) mailLoginSecondStep :(NSString*) mail 
                     andName:(NSString *)name 
                 andNickName:(NSString *)nickName
                      andPsd:(NSString *)psd
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString *tempPsd = [self getSha1DomainPsd:psd];
    NSData *cinName = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cinNickName = [nickName dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * regUrl = [NSString stringWithFormat:@"%@?m=%@&cver=%@&oem=%@&v=1&n=%@&nn=%@&p=%@", 
						 url_regmail, mail,ios_version, readStr,[cinName cinBase64Encoding],[cinNickName cinBase64Encoding],tempPsd];
	[readStr release];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(mailLoginSecondStepRequestDidFinished:)];
	[request setDidFailSelector:@selector(mailLoginSecondStepRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)mailLoginSecondStepRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"mailLoginRequestDidFinishedStep 2");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSNumber *userID = [NSNumber numberWithLongLong:[[rsp getHeader:0x01] getInt64]];
    if (userID)
    {
        [userinfo setObject:userID forKey:@"userID"];
    }
    
    NSData *token = [[rsp getHeader:0x02] getValue];
    if (token)
    {
        [userinfo setObject:token forKey:@"token"];
    }
    
    NSData *psd = [[rsp getHeader:0x03] getValue];
    if (psd)
    {
        [userinfo setObject:psd forKey:@"psd"];
    }
    
    NSString *mobile = [NSString stringWithFormat:@"%lld",[[rsp getHeader:0x04] getInt64]];
    if(mobile)
    {
        [userinfo setObject:mobile forKey:@"mobile"];
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
    if ([self needVerification:userinfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult object:nil userInfo:userinfo];
}

-(void)mailLoginSecondStepRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterSetUserNameResult
														object:nil 
													  userInfo:userinfo];
	NSLog(@"notifyMailLoginInfo Failed step2.");
}

#pragma mark -
#pragma mark 获取图形验证码

-(BOOL)needVerification: (NSDictionary *)userInfo
{
    NSNumber* responseCode = [userInfo objectForKey:@"responseCode"];
    if ([responseCode intValue] == CinResponseCodeRequireCertification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginAndRegisterNeedVerification object:nil userInfo:userInfo];
        return YES;
    }
    else {
        return NO;
    }    
}

-(void) picVerify
{
    NSString * regUrl = [NSString stringWithFormat:@"%@", 
						 url_getpiccode];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(picVerifyRequestDidFinished:)];
	[request setDidFailSelector:@selector(picVerifyRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)picVerifyRequestDidFinished:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    NSString *picCodeID = [[rsp getHeader:0x05] getString];
    if (picCodeID)
    {
        [userinfo setObject:picCodeID forKey:@"picCodeID"];
    }
    NSData *bodyData = [[rsp getBody] getValue];
    
    if (bodyData)
    {
        NSData *bodyData = [[rsp getBody] getValue];
        UIImage *body = [UIImage imageWithData:bodyData];
        [userinfo setObject:body forKey:@"picImage"];
    }
    //[self verifyPicCode:picCodeID andPicCodeContent:<#(id)#>]
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyPicVerifyInfo
														object:nil 
													  userInfo:userinfo];
    NSLog(@"picVerifyRequestDidFinished");
}

-(void)picVerifyRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyPicVerifyInfo
														object:nil 
													  userInfo:userinfo];
	NSLog(@"picVerifyRequestDidFailed");
}

-(void) verifyPicCode:(NSString *)picCodeID 
    andPicCodeContent:(id)codeContent
{
    NSString * regUrl = [NSString stringWithFormat:@"%@?p=%@&n=%@", 
						 url_checkpiccode,picCodeID,codeContent];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(picVerifyCodeRequestDidFinished:)];
	[request setDidFailSelector:@selector(picVerifyCodeRequestDidFailed:)];
	[request startAsynchronous];
}

-(void)picVerifyCodeRequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"picVerifyCodeRequestDidFinished");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyPicVerifyCodeInfo
														object:nil 
													  userInfo:userinfo];
}

-(void)picVerifyCodeRequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyPicVerifyCodeInfo
														object:nil 
													  userInfo:userinfo];
	NSLog(@"picVerifyRequestDidFailed");
}

#pragma mark -
#pragma mark -绑定手机号
-(void)bindMobileNo1:(NSNumber *)userid 
           andMobile:(NSString *)mobile
{
    long long value = [userid longLongValue];
    char leadingZeroBytes = 8;
    for(char i = 8; i >1 ; i--)
    {
        if(((value >> 8 * (i - 1)) & 0xFF) != 0)
        {
            leadingZeroBytes = 8-i;
            break;
        }
    }
    if(leadingZeroBytes == 8)leadingZeroBytes = 7;
    unsigned short len = 8 - leadingZeroBytes;
    NSData *valueData = [NSMutableData  dataWithBytes:&value length:len];
    NSString * regUrl = [NSString stringWithFormat:@"%@?u=%@&no=%@&k=%@", 
						 url_bindmnoreq,[valueData cinBase64Encoding],[Utility getEncodedPhoneNumber:mobile],[[self getCredential] cinBase64Encoding]];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(bindMobileNo1RequestDidFinished:)];
	[request setDidFailSelector:@selector(bindMobileNo1RequestDidFailed:)];
	[request startAsynchronous];
}

-(void)bindMobileNo1RequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"bindMobileNo1RequestDidFinished");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyBindMobileRequestInfo
														object:nil 
													  userInfo:userinfo];
}

-(void)bindMobileNo1RequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyBindMobileRequestInfo
														object:nil 
													  userInfo:userinfo];
	NSLog(@"bindMobileNo1RequestDidFailed");
}

-(void)bindMobileNo2:(NSNumber *)userid 
           andMobile:(NSString *)mobile 
       andVerifyCode:(NSString *)code
{
    NSString * regUrl = [NSString stringWithFormat:@"%@?u=%@&no=%@&c=%@&k=%@", 
						 url_bindmno,[Utility getEncodedPhoneNumber:[userid stringValue]],[Utility getEncodedPhoneNumber:mobile],code,[[self getCredential] cinBase64Encoding]];
    NSLog(@"Regist url=%@", regUrl);
	//issue the http request for nav
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(bindMobileNo2RequestDidFinished:)];
	[request setDidFailSelector:@selector(bindMobileNo2RequestDidFailed:)];
	[request startAsynchronous];
}

-(void)bindMobileNo2RequestDidFinished:(ASIHTTPRequest *)request
{
    NSLog(@"bindMobileNo2RequestDidFinished");
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse * )[CinMessageReader load:decodedData];
    [userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
    
    NSNumber *type = [NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeType] getInt64]];
    if (type)
    {
        [userinfo setObject:type forKey:@"type"];
    }
    
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    tanZhiInfoLog(@"%@",[userinfo description]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyBindMobileInfo
														object:nil 
													  userInfo:userinfo];
}

-(void)bindMobileNo2RequestDidFailed:(ASIHTTPRequest *)request
{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userinfo setObject:[NSNumber numberWithInt:0xFE] forKey:@"responseCode"];
    [userinfo setObject:@"网络连接错误，请稍后重试" forKey:@"body"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyBindMobileInfo
														object:nil 
													  userInfo:userinfo];
	NSLog(@"bindMobileNo2RequestDidFailed");
}

#pragma mark -
#pragma mark other

//-----------psdregiestfunction

//＝＝＝＝＝＝＝＝ Regist check functions ＝＝＝＝＝＝＝＝
-(void) RegistSMSCheck:(NSString*)sms Url:(NSString*)url userInputMobile:(NSString*)mobile
{
	//registSMSCheck string
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSString * regchkUrl = [NSString stringWithFormat:@"%@?c=%@&no=%@&oem=%@", 
							url,sms,[Utility getEncodedPhoneNumber:mobile],readStr];
    [readStr release];
	NSLog(@"RegistSMSCheck url=%@", regchkUrl);
	//issue the http request for regist check
	ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:regchkUrl]];
	[request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:30];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(registSMSCheckRequestDidFinished:)];
	[request setDidFailSelector:@selector(registSMSCheckRequestDidFailed:)];
	[request startAsynchronous];
}

//registSMSCheck ok callback
-(void)registSMSCheckRequestDidFinished:(ASIHTTPRequest *)request
{
	NSString * encodedString = [request responseString];
    NSData * decodedData = [NSData dataWithBase64EncodedString:encodedString];
    CinResponse * rsp = (CinResponse *)[CinMessageReader load:decodedData];
	
	NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
	
	//set response data
	[userinfo setObject:[NSNumber numberWithInteger:[rsp getStatusCode]] forKey:@"responseCode"];
	[userinfo setObject:[NSNumber numberWithLongLong:[[rsp getHeader:CinHeaderTypeFrom] getInt64]] forKey:@"userId"];
	
    NSString *body = [[rsp getBody] getString];
	if (body != nil)
	{
		[userinfo setObject:body forKey:@"body"];
	}
    
	if ([rsp getHeader:CinHeaderTypePassword].Value != nil) 
	{
        NSData *pwd = [NSData dataWithData:[rsp getHeader:CinHeaderTypePassword].Value];
		[userinfo setObject:pwd forKey:@"password"];
	}
	if ([rsp getHeader:CinHeaderTypeToken].Value != nil) 
	{
        NSData *tokten = [NSData dataWithData:[rsp getHeader:CinHeaderTypeToken].Value];
		[userinfo setObject:tokten forKey:@"tokten"];
	}
    if ([rsp getHeader:CinHeaderTypeName].Value != nil) 
	{
        NSString * nickString = [[rsp getHeader:CinHeaderTypeName] getString] ;
        NSLog(@"<TCNetworkManager registSMSCheckRequestDidFinished feitionNikName = %@>",nickString);
		[userinfo setObject:nickString forKey:@"feitionNikName"];
	}
    
    
	
	//发送验证注册短信成功通知 ==> ApplicationDelegate
	[[NSNotificationCenter defaultCenter] postNotificationName:notifyCheckSMSResult 
														object:nil 
													  userInfo:userinfo];
}

//registSMSCheck fail callback
-(void)registSMSCheckRequestDidFailed:(ASIHTTPRequest *)request
{
	//[Utility showMessageBox:@"短信验证失败,可能是网络问题!"];
	NSLog(@"registSMSCheckRequestDidFailed.");
}

- (void)getingHeadImageFinishedPrivate{
    
    //广播通知：名片信息发生了变更
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNameCardUpdated
                                                        object:nil
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyAddressBookUpdaeData
                                                        object:nil
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyHeadImageChanged
                                                        object:nil
                                                      userInfo:nil];
    
}

- (void)getingHeadImageFinished
{
    [NSObject cancelAMEPreviousPerformRequestsWithTarget:self selector:@selector(getingHeadImageFinishedPrivate) object:nil];
    [self performAMESelector:@selector(getingHeadImageFinishedPrivate) withObject:nil afterDelay:1];
}

-(void)takeVisitingCard1:(NSString *)uid{
    [self performSelector:@selector(takeVisitingCardInBizThread:) onThread:_bizThread withObject:uid waitUntilDone:NO];
}
-(void)updateMyInformation:(NSString*) name andMood:(NSString*) mood andGender:(NSString*) gender andProvince:(NSString*) province andCity: (NSString*) city andCallback:(NSObject<CinCallback> *)callback{
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithCapacity:0];
    if(name != nil){
        [pram setObject:name forKey:@"name"];
    }
    if(mood != nil){
        [pram setObject:mood forKey:@"mood"];
    }
    if (gender != nil) {
        [pram setObject:gender forKey:@"gender"];
    }
    if(province != nil){
        [pram setObject:province forKey:@"province"];
    }
    if(city != nil){
        [pram setObject:city forKey:@"city"];
    }
    if(callback != nil){
        TCUpdateMyInformationCallback *cb = [[TCUpdateMyInformationCallback alloc]init];
        cb.callback = callback;
        [pram setObject:cb forKey:@"callback"];
        [cb release];
    }
    [self performSelector:@selector(updateMyInformationInBizThread:) onThread:_bizThread withObject:pram waitUntilDone:NO];
}

-(void)updateAppToken:(NSData*) token andCallback:(NSObject<CinCallback> *)callback
{
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithCapacity:0];
    if(token != nil){
        [pram setObject:token forKey:@"token"];
    }
    if(callback != nil){
        TCUpdateMyInformationCallback *cb = [[TCUpdateMyInformationCallback alloc]init];
        cb.callback = callback;
        [pram setObject:cb forKey:@"callback"];
        [cb release];
    }
    [self performSelector:@selector(updateMyInformationInBizThread:) onThread:_bizThread withObject:pram waitUntilDone:NO];
}

-(void) newContactBook:(NSArray *)mobile version:(NSInteger) ver{
    long long mobileNos[[mobile count]];
    int i = 0;
    for (NSNumber* number in mobile)
    {
        mobileNos[i++] = [number longLongValue];
    }
    [_cinClient newContactBook:mobileNos andDataLength:[mobile count] version:ver];
    tanZhiInfoLog(@"<TCNetworkManager> newContactBookInBizThread resetUserLog tanzhiContact_log contact.count=%d ver=%d",[mobile count], ver);
}
-(void)takePortrait:(NSString *)param{
    NSNumber *uid = [NSNumber numberWithLongLong:[param longLongValue]];
    [self performSelector:@selector(takePortraitInBizThread:) onThread:_bizThread withObject:uid waitUntilDone:NO];
}

-(void)disconnect{
    [self performSelector:@selector(disconnectInBizThread) onThread:_bizThread withObject:nil waitUntilDone:NO];
}

-(void)uploadPortrait:(NSData *)portrait andCallback:(NSObject<CinCallback>*) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setObject:portrait forKey:@"portrait"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(uploadPortraitInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) setApplePushType:(long long) value andCallback:(NSObject<CinCallback> *)callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *pushType = [NSNumber numberWithLongLong:value];
    [param setObject:pushType forKey:@"pushType"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(setApplePushTypeInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) setReceiveFetionMessage:(BOOL) flag andCallback:(NSObject<CinCallback> *)callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *flagNumber = [NSNumber numberWithBool:flag];
    [param setObject:flagNumber forKey:@"flag"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(setReceiveFetionMessageInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) setFetionLogon:(BOOL) flag andCallback:(NSObject<CinCallback> *)callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *flagNumber = [NSNumber numberWithBool:flag];
    [param setObject:flagNumber forKey:@"flag"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(setFetionLogonInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}



-(CinClientCore *) getCinClientCore{
    //不用后台处理，这个函数没有发送数据
    return _cinClient.mCore;
}


-(void) getInTouch:(long long) userId andCallback:(NSObject<CinCallback>*) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *userIDNumber = [NSNumber numberWithLongLong:userId];
    [param setObject:userIDNumber forKey:@"userId"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(getInTouchInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) acceptTouchMe:(long long) userId andCallback:(NSObject<CinCallback> *) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *userIDNumber = [NSNumber numberWithLongLong:userId];
    [param setObject:userIDNumber forKey:@"userId"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(acceptTouchMeInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) refuseTouchMe:(long long) userId andCallback:(NSObject<CinCallback> *) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *userIDNumber = [NSNumber numberWithLongLong:userId];
    [param setObject:userIDNumber forKey:@"userId"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(refuseTouchMeInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) agreeAddFetionBuddy:(long long) targetid andCallback:(NSObject<CinBuddyCallback>*) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *targetIDNumber = [NSNumber numberWithLongLong:targetid];
    [param setObject:targetIDNumber forKey:@"targetid"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(agreeAddFetionBuddyInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}

-(void)refuseAddFetionBuddy:(long long) targetid andCallback:(NSObject<CinBuddyCallback>*) callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *targetIDNumber = [NSNumber numberWithLongLong:targetid];
    [param setObject:targetIDNumber forKey:@"targetid"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(refuseAddFetionBuddyInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}

-(void) addFetionBuddy:(long long) mobileNo andCallback:(NSObject<CinBuddyCallback>*) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    NSNumber *mobileNumber = [NSNumber numberWithLongLong:mobileNo];
    [param setObject:mobileNumber forKey:@"mobileNo"];
    [param setObject:callback forKey:@"callback"];
    [self performSelector:@selector(addFetionBuddyInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) addContactBook:(NSArray *) contacts version:(long long) ver{
    NSInteger count = [contacts count];
    long long mobileNos[count];
    int i = 0;
    for (NSNumber* number in contacts)
    {
        mobileNos[i++] = [number longLongValue];
    }
    [_cinClient addContactBook:mobileNos andDataLength:count version:ver];
}

-(void) removeContactBook:(NSArray *) contacts version:(long long) ver{
    NSInteger count = [contacts count];
    long long mobileNos[count];
    int i = 0;
    for (NSNumber* number in contacts)
    {
        mobileNos[i++] = [number longLongValue];
    }
    [_cinClient removeContactBook:mobileNos andDataLength:count version:ver];
}

-(long long)getCounterSendBytes{
    return  _cinClient.Counter_SendBytes;
}

-(long long)getCounterRecvBytes{
    return  _cinClient.Counter_RecvBytes;    
}
-(void) clearRecvBytes{
    [_cinClient clearRecvBytes];
}
-(void) clearSendBytes{
    [_cinClient clearSendBytes];
}
-(BOOL)getIsRegisted{
    return _cinClient.IsRegisted;
}
-(BOOL)getIsConnected{
    if(_cinClient == nil){
        return NO;
    }else{
        return _cinClient.IsConnected;
    }
}

//检查网络状态,让socket重连,防止有wifi的情况下还在用gprs
-(void)setNetworkStatus:(TCNetworkStatus)networkStatus
{
    if (_networkStatus == TCReachableViaWWAN) 
    {
        tanZhiInfoLog(@"<TCNetworkManager> setNetworkStatus wifi relogin. disconnect_log");
        
        [self disconnect];
        [self beginConnect2Server:_currentAccount];
    }
    _networkStatus = networkStatus;
}

-(NSData*)getCredential{
    return _cinClient.User.Credential;
}
-(long long)getContactBookVersion{
    return _cinClient.User.ContactBookVersion;
}

//-(void) removeDialog: (CinDialog *) dialog {
//    [_cinClient removeDialog:dialog];
//}
-(CinVoice *) createAttachVoice:(long long)rate andType:(long long)type{
    //内存操作，没有发送任何数据
    return [_cinClient createAttachVoice:rate andType:type];
}
-(CinImage *) createAttachImage:(NSData*)thumbData andFileName:(NSString*)fileName andImageData:(NSData*)imageData{
    //内存操作，没有发送任何数据
    return [_cinClient createAttachImage:thumbData andFileName:fileName andImageData:imageData];
}
-(void) sendMutipleMessage:(NSArray*)peerIds andMessage:(NSString*) message andCallback:(NSObject<CinMutipleCallback> *) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setObject:peerIds forKey:@"peerIds"];
    [param setObject:message forKey:@"message"];
    [param setObject:callback forKey:@"callback"];
    
    [self performSelector:@selector(sendMutipleMessageInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) sendMutipleMessage:(NSArray*)peerIds andMessage:(NSString*) message andImage:(CinImage*) image andCallback:(NSObject<CinMutipleCallback> *) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setObject:peerIds forKey:@"peerIds"];
    [param setObject:message forKey:@"message"];
    [param setObject:image forKey:@"image"];
    [param setObject:callback forKey:@"callback"];
    
    [self performSelector:@selector(sendMutipleMessageImageInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}
-(void) sendMutipleMessage:(NSArray*)peerIds andMessage:(NSString*) message andVoice:(CinVoice*) voice andCallback:(NSObject<CinMutipleCallback> *) callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setObject:peerIds forKey:@"peerIds"];
    [param setObject:message forKey:@"message"];
    [param setObject:voice forKey:@"voice"];
    [param setObject:callback forKey:@"callback"];
    
    [self performSelector:@selector(sendMutipleMessageVoiceInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}

-(void)shareLocation:(double)longitude andLatitude:(double)latitude andCallback:(NSObject<CinCallback>*) callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    [param setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [param setObject:callback forKey:@"callback"];
    
    [self performSelector:@selector(shareLocationInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}

-(void)cancellocation:(NSObject<CinCallback>*) callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setObject:callback forKey:@"callback"];
    
    [self performSelector:@selector(cancelLocationInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}

//打招呼请求接口
-(void)sayHi:(TCContact *)contact andCallback:(NSObject<CinCallback> *)callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setObject:callback forKey:@"callback"];
    [param setObject:contact forKey:@"contact"];
    [self performSelector:@selector(sayHiInBizThread:) onThread:_bizThread withObject:param waitUntilDone:NO];
}

//获得附近联系人列表
-(void)getMatchResult:(NSObject<CinLocationCallback>*)callback
{
    [self performSelector:@selector(getMatchResultInBizThread:) onThread:_bizThread withObject:callback waitUntilDone:NO];
}

-(void)turnOffShouldSwitchToChatlistView
{
	[TCCore sharedCore].shouldSwitchToChatlistView = NO;
}

//- (void)addNewContactFinished
//{
//    [[TCCore sharedCore] refreshFriendAndStrangerCollection];
//    [[TCCore sharedCore] saveContacts];
//}

//
-(void) initGroup{
    tanZhiDebugLog(@"<TCNetwokManager>initGroup");
    if([TCCore sharedCore].groupSessionList && _cinClient.IsRegisted){
        tanZhiDebugLog(@"<TCNetwokManager>initGroup 2");
        //        NSArray * allGroupSession = [[TCCore sharedCore].groupSessionList allValues];
        //        for (TCGroupSession * s in allGroupSession) {
        //            [s continueDownloadAudio];
        //        }
        //把TCGroupSession和CinGroup挂接到一起. 有2个挂接点：登录成功；数据库读取完成
        for(TCGroupSession *g in [[TCCore sharedCore].groupSessionList allValues]){
            if([TCCore uidIsGroupID:[g.groupSessionIDofServer longLongValue]]){
                tanZhiInfoLog(@"<TCNetworkManager>initGroup dbid=%d topic=%@ messageKey=%qi",g.DBID, g.topic, g.maxMessageKey);
                g.cinGroup = [_cinClient initializeGroup:[g.groupSessionIDofServer longLongValue] andGroupEvent:g andMessageKey:g.maxMessageKey];
                tanZhiDebugLog(@"<TCNetworkManager>initGroup eventnil topic=%@ g=%@ cingroup=%@",g.topic, g, g.cinGroup);
            }
            else{
                g.groupNotExitInServer = YES;
            }
        }
    }
}

-(void)reSetCinUser{
    tanZhiInfoLog(@"logoff reSetCinUser");
    [self disconnect];
    _cinClient.User.UserId = 0;
    _cinUser.UserId = 0;
    _cinClient.User.ContactBookVersion = 0;
    [_currentAccount reset];    
}
-(void)uploadContactAddressList{
    [self performSelector:@selector(uploadContactAddressListInBizThread) onThread:_bizThread withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark group 
-(void)createGroup:(TCGroupSession*) gs{
    if (gs.imageIndex == 0) {
        gs.imageIndex = 255;
    }
    
    if(_cinClient.IsRegisted){
        //        [self performSelector:@selector(createGroupInBizThread:) onThread:_bizThread withObject:gs waitUntilDone:NO];
        [_cinClient createGroupWith:gs.topic andGroupTitleImageId:gs.imageIndex andGroupEvent:gs];
    }
    else{
        [gs creatFail];
    }
}


- (void) reInitializeGroupInBizThread:(TCGroupSession*) gs{
    if (_cinClient.IsRegisted) {
        //        g.cinGroup = [_cinClient initializeGroup:[g.groupSessionIDofServer longLongValue] andGroupEvent:g andMessageKey:g.maxMessageKey];
        gs.cinGroup = [_cinClient initializeGroup:[gs.groupSessionIDofServer longLongValue] andGroupEvent:gs andMessageKey:gs.maxMessageKey];
    }
}

#pragma mark -
#pragma mark CinClientEvent 

//连接成功
-(void) onConnected
{
	tanZhiInfoLog(@"<TCNetworkManager>onConnected. connect_log reRegistLog:reRegistLog:userid=%qi mobile=%qi password=%@ token=%@ credential=%@",_cinClient.User.UserId, _cinClient.User.MobileNo, _cinClient.User.Password, _cinClient.User.Token, _cinClient.User.Credential);
	
    [self performSelectorOnMainThread:@selector(onConnectedInMainThread) withObject:nil waitUntilDone:NO];
	
	//登录
	[_cinClient logon];
}

//登录成功
-(void) onRegistered
{
    tanZhiInfoLog(@"<TCNetworkManager>onRegistered. resetUserLog connect_log");
    
    //    NSString  *clientUpdating = [[TCDbOpreater shareDb] getKeyValueString:keyValueClientUpdating];
    //    isClientUpdating = NO;
    //    if (clientUpdating != nil) {
    //        isClientUpdating = [clientUpdating isEqualToString:@"1"];
    //    }
    //设置该用户创建群时所允许的最大人数
    [TCCore sharedCore].maxSizeOfGroup = _cinClient.GroupSize;
    
    [self performSelectorOnMainThread:@selector(onRegisteredInMainThread) withObject:nil waitUntilDone:NO];
    
	//============= 上传通讯录 ================
    if ([TCCore sharedCore].contactManager.contactsReady) 
    {
        [self uploadContactAddressListInBizThread];
        //设置名字
        NSString *registerName = [[NSUserDefaults standardUserDefaults] stringForKey:@"RegisterName"];
        if ([registerName length] != 0)
        {
            NSLog(@"<TCNetworkManager> onRegistered set Name card name=%@",registerName);
            TCLogonNameCardCallBackWrap *logonNameCardCallBackWrap = [[TCLogonNameCardCallBackWrap alloc] init];
            [_cinClient updateMyInformation:registerName andMood:nil andGender:nil andProvince:nil andCity:nil andAppDeviceToken:nil andCallback:logonNameCardCallBackWrap];
            [logonNameCardCallBackWrap release];
        }
    }
    
	//客户端获得离线消息
    [_cinClient getOfflineMessage];
    
//    NSArray * allSingSession = [[[TCCore sharedCore] singleSessionList] allValues];
    //    for (TCSingleSession * s in allSingSession) 
    //    {
    //        [s continueDownloadAudio];
    //    }
    bool firstRegistStat = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstRegistStat"];
    if(firstRegistStat){
        TCGetGroupListCallback *cb = [[TCGetGroupListCallback alloc] init];
        [_cinClient getGroupListWithCallback:cb];
        [cb release];
    }
    
    [self initGroup];
    
    [[TCBuddyManager sharedManager] takeMyVisitingCardOnRegistedInBizThread];
}

//登录失败
-(void) onRegisterFailed
{ 
    tanZhiInfoLog(@"<TCNetworkManager>onRegisterFailed. connect_log");
    [self disconnectInBizThread];
	[self performSelectorOnMainThread:@selector(onRegisterFailedInMainThread) withObject:nil waitUntilDone:NO];	
    
}

//登录失败需要重新注册
-(void) onRegisterFailedNeedRereg
{ 
	tanZhiInfoLog(@"<TCNetworkManager>onRegisterFailedNeedRereg. connect_log");
    [self performSelectorOnMainThread:@selector(onRegisterFailedNeedReregInMainThread) withObject:nil waitUntilDone:NO];	
    
}

-(void) onCheckCredentialFailed
{
	tanZhiInfoLog(@"<TCNetworkManager>onCheckCredentialFailed. connect_log");
	
    [self performSelectorOnMainThread:@selector(onCheckCredentialFailedInMainThread) withObject:nil waitUntilDone:NO];
	
}

-(void) onDisconnected
{
	tanZhiInfoLog(@"<TCNetworkManager>onDisconnected. connect_log");
	
    [self performSelectorOnMainThread:@selector(onDisconnectedInMainThread) withObject:nil waitUntilDone:NO];
    
}

-(void) onConnectFailed
{
    tanZhiInfoLog(@"<TCNetworkManager>onConnectFailed. connect_log");
	
    [self performSelectorOnMainThread:@selector(onConnectFailedInMainThread) withObject:nil waitUntilDone:NO];
	
}

-(void) onContactBookCallback: (BOOL) result{
    _cinClient.User.ContactBookVersion = [[TCCore sharedCore].contactManager onContactBookCallback:result];
    tanZhiInfoLog(@"同步通讯录完成！tanzhiContact_log result=%d,%qi",result, _cinClient.User.ContactBookVersion);
}


//通知弹指好友（服务器会推给我对方有我手机号的人）
-(void) onUserInfoNotifyReceived: (NSArray *) notifies
{
    tanzhiAssert(0);
    return;
    //    //0.3-0.4
    //    tanZhiInfoLog(@"2开始============ onUserInfoNotifyReceived tanzhiContact_log ============= notifies.count=%d",[notifies count]);
    //    
    //    for (CinUserInfo *info in notifies) {
    //        tanZhiInfoLog(@" userid:%lld mobile:%lld head:%lld name:%@ mode:%@ IsFetionChatUser:%d IsFetionBuddy:%d FetionName:%@ FetionNickName:%@ UserName:%@" ,
    //                      info.UserId,info.MobileNo,info.HeadId,info.UserName,info.UserMood, info.IsFetionChatUser, info.IsFetionBuddy,info.FetionName, info.FetionNickName, info.UserName);
    //    }
    //    tanZhiDebugLog(@"2end============ onUserInfoNotifyReceived ============= notifies.count=%d",[notifies count]);
    //    for (CinUserInfo *info in notifies) {
    //        [self dealOneCinClinetNotifyUserInfo:info];
    //        //        [NSThread sleepForTimeInterval:0.001];
    //    }
    //
    //    [[TCCore sharedCore]logContactInfo];
    //    return;
}




-(void) onTakeVisitingCard: (CinVisitingCard*) card
{
    NSString *uid = [NSString stringWithFormat:@"%lld",card.UserId];
    TCContact *c  = [[TCCore sharedCore]findContactByUID:card.UserId];
    
    //更新本地用户信息
    if (c != nil)
    {
        NSLog(@"<TCNetwokManager> onTakeVisitingCard c.userSetName=%@ card.Name=%@ Portrait=%qi uid=%qi", c.userSetName, card.Name, card.Portrait, card.UserId);
        
        if(card.Name != nil){
            c.userSetName = [[Utility sharedUtility] decodeAppleEmotionString:card.Name];     
        }
        
        c.location = (card.Province!=nil && card.City!=nil)?[NSString stringWithFormat:@"%@-%@",card.Province,card.City]:c.location;
        if (card.Mood != nil) {
            c.impresa = [[Utility sharedUtility] decodeAppleEmotionString:card.Mood];
        }
        if (card.Gender != nil) {
            c.gender = card.Gender;
        }
        if (card.UpdateTime > 0)
        {
            c.impresaUpdateTime = [NSDate dateWithTimeIntervalSince1970:card.UpdateTime];
            NSLog(@"c.impresaUpdateTime = %@",c.impresaUpdateTime);
        }            
        
        NSLog(@"从服务器获取到联系人%@名片:%@ - %@ - %@ - %@ - %@ -%lld -%f",uid,card.Name,card.Gender,card.Mood,card.Province,card.City,card.Portrait,card.UpdateTime);
        
        //头像版本不一致，更新头像
        if (c.userHeadImageVersion != card.Portrait)
        {
            [self takePortrait:c.userId];
            //去服务器请求新头像
            //            [_cinClient takePortrait:card.UserId];
        }
        
        c.userHeadImageServerVersion = card.Portrait;
        //        [[TCCore sharedCore] saveContacts];
        [[TCDbOpreater shareDb]updateContact:c];
        
        [self performSelectorOnMainThread:@selector(onTakeVisitingCardInMainThread) withObject:nil waitUntilDone:NO];
        return;
    }
}

-(void) onWhoWantTouchMe:(long long) userId andMobileNo:(long long) mobileNo andName:(NSString*) name andHeaderId:(long long) headId{
    
    tanZhiInfoLog(@"有人想认识我：uid=%lld mobileNo=%lld  name=%@  headId=%lld",userId,mobileNo,name,headId);
    
    TCContact *c = [[TCCore sharedCore] findContactByUID:userId];
    [c updateContactImage];
    //你的通讯录中有他，但是他的通讯录中没有你
    if(c != nil)
    {
        if (c.isBlock) {
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:c.userId forKey:@"userId"];
        [dic setObject:@"onWhoWantTouchMe" forKey:@"type"];
        
        [dic setObject:name==nil?[NSString stringWithFormat:@"%qi",mobileNo]:name forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"%qi",mobileNo] forKey:@"mobile"];
        //        [dic setObject:[NSString stringWithFormat:@"%lld",headId] forKey:@"headId"];
        //        [dic setObject:[NSString stringWithFormat:@"%lld",userId] forKey:@"userId"];
        NSString *touchMeContent = [NSString stringWithString:@"想认识你一下"];
        [dic setObject:touchMeContent forKey:@"content"];
        NSString *dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        [dic setObject:dateStr forKey:@"date"];
        [[TCCore sharedCore].noticeManager notifyTouchMeInBizThread:dic];
    }
}

-(void) onTouchRefused:(long long) userId
{
    tanZhiInfoLog(@"%lld拒绝了我的认识请求",userId);
    TCContact *c = [[TCCore sharedCore] findContactByUID:userId];
    if(c != nil){
        if (c.isBlock) {
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:c.userId forKey:@"userId"];
        [dic setObject:@"onTouchRefused" forKey:@"type"];
        //[[TCCore sharedCore].noticeManager notifyTouchMeInBizThread:dic];
    }
}

-(void) onTouchAccept:(long long) userId andMobileNo:(long long) mobileNo andName:(NSString*) name andHeaderId:(long long) headId
{
    tanZhiInfoLog(@"%@接受了我的认识请求：uid=%lld mobileNo=%lld headId=%lld",name,userId,mobileNo,headId);
    TCContact *c = [[TCCore sharedCore] findContactByUID:userId];
    if (c.isBlock) {
        return;
    }
    c.number = [NSString stringWithFormat:@"%qi",mobileNo];//提前保存手机号，防止用户在保存通讯录时，取消保存。
    if (c.isSocialityContact){
        //认识成功后将c存放到_tanzhiUserList中，将_sayHiContactList中的c移除
        [[TCCore sharedCore] addContactToTanzhiUserListFromSayHiList:c];
    }
    //    tanzhiAssert(c!=0);
    if(c != nil){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:c.userId forKey:@"userId"];
        [dic setObject:@"onTouchAccept" forKey:@"type"];
        
        [dic setObject:name==nil?[NSString stringWithFormat:@"%lld",mobileNo]:name forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"%lld",mobileNo] forKey:@"mobile"];
        //        [dic setObject:[NSString stringWithFormat:@"%lld",headId] forKey:@"headId"];
        //        [dic setObject:[NSString stringWithFormat:@"%lld",userId] forKey:@"userId"];
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:notifyTouch object:nil userInfo:dic];
        NSString *dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        [dic setObject:dateStr forKey:@"date"];
        NSString *content = [NSString stringWithFormat:@"%@同意了你的请求，请将Ta保存到联系人中，方便随时联系。",c.userSetName];
        [dic setObject:content forKey:@"content"];
        [[TCCore sharedCore].noticeManager notifyTouchMeInBizThread:dic];
    }
}

-(void) onAddBuddyAgree: (CinUserInfo *) info{
    tanZhiInfoLog(@"<AddFetionBuddy> onAddBuddyAgree userid:%lld mobile:%lld head:%lld name:%@ mood:%@ IsFetionChatUser:%d IsFetionBuddy:%d FetionName:%@ FetionNickName:%@ UserName:%@" ,
                  info.UserId,info.MobileNo,info.HeadId,info.UserName,info.UserMood, info.IsFetionChatUser, info.IsFetionBuddy,info.FetionName, info.FetionNickName, info.UserName);
    [[TCBuddyManager sharedManager] dealOneCinClinetNotifyUserInfo:info];
    TCContact *contact = [[TCCore sharedCore]findContactByUID:info.UserId];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *addBuddySuccessContent = [NSString stringWithFormat:@"%@已同意你的飞信好友请求",contact.name];
    if (contact.userId)
        [dic setObject:contact.userId forKey:@"userId"];
    if (contact.name)
        [dic setObject:contact.name forKey:@"name"];
    [dic setObject:addBuddySuccessContent forKey:@"content"];
    NSString *dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [dic setObject:dateStr forKey:@"date"];
    
    [[TCCore sharedCore].noticeManager notifyAddBuddySuccessInBizThread:dic];
    [self performSelectorOnMainThread:@selector(onAddBuddyAgreeInMainThread:) withObject:contact waitUntilDone:NO];
}
-(void) onAddBuddyRefuse: (long long) mobileNo{
    tanZhiInfoLog(@"<AddFetionBuddy> onAddBuddyRefuse mobileNo=%qi",mobileNo);
    
    NSString *number = [NSString stringWithFormat:@"%qi",mobileNo];
    TCContact *contact = [[TCCore sharedCore]findContactByMobileNumber:number];
    //    if ([TCCore sharedCore].addFetionBuddyCallback) {
    //        [[TCCore sharedCore].addFetionBuddyCallback addFail:contact];
    //    }
    if (contact) {
        [contact clearContactAtomicType:AtomicContactTypeFetion];
        [contact clearContactAtomicType:AtomicContactTypeFetionBuddy];
    }
    [self performSelectorOnMainThread:@selector(onAddBuddyRefuseInMainThread:) withObject:contact waitUntilDone:NO];
}

-(void) onAddBuddyReceived: (long long) sourceid andAppText:(NSString *)text andSourceName:(NSString *)name
{
    tanZhiInfoLog(@"<TCNetworkManager>onAddBuddyReceived add_fetion_log sourceid=%qi text=%@ ,name = %@", sourceid, text,name);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if(text == nil){
        text = @"";
    }
    //    TCContact *contact = [[TCCore sharedCore] findContactByUID:sourceid];
    //    [contact updateContactImage];
    [dic setObject:name forKey:@"name"];
    [dic setObject:text forKey:@"content"];
    NSString *dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [dic setObject:dateStr forKey:@"date"];
    [dic setObject:[NSString stringWithFormat:@"%qi" ,sourceid] forKey:@"userId"];
    [[TCCore sharedCore].noticeManager notifyAddBuddyInBizThread:dic];
}

-(void) onGroupJoined: (CinGroup *) group andSourceId:(long long)sourceId andTopic: (NSString *) topic andHeadId:(long long) headId{
    tanZhiInfoLog(@"groupHeadImage group.id=%qi, topic=%@, headId=%qi group=%@",group.GroupId,topic,headId,group);
    
    NSString *gIDOfServer  = [NSString stringWithFormat:@"%qi",group.GroupId];
    TCGroupSession *gsExist = [[TCCore sharedCore] groupExist:gIDOfServer];
    if (gsExist != nil) {
        //被踢掉的逻辑
        group.Event = gsExist;
        gsExist.cinGroup = group;
        return;
    }
    TCGroupSession *gs = [[TCGroupSession alloc] initWithNumbers:nil withTopic:topic withImageIndex:headId groupIsInServer:YES];
    gs.groupSessionIDofServer = gIDOfServer;
    group.Event = gs;
    gs.cinGroup = group;
    [group initialize:gs.maxMessageKey];
    [[TCCore sharedCore].groupSessionList setObject:gs forKey:gs.sessionID];
    
    //如果是自定义头像,去server取一下
    if (headId>255)
    {
        NSNumber *gID = [NSNumber numberWithLongLong:group.GroupId];
        tanZhiInfoLog(@"groupHeadImage will download group head image. groupID=%@",gID);        
        [self takePortraitInBizThread:gID];
        //        [[TCNetworkManager sharedInstance] takePortrait:gIDOfServer];
    }
    
    NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:0];
    [contacts addObject: [UserConfig shareConfig].lastLoginAccUserID];
    [gs addContact:contacts contactsInServer:YES];
    [[TCDbOpreater shareDb] updateGroupSession:gs]; //更改了groupSessionIDofServer 属性所以要保存
    
    //后台模拟push消息
    if ([TCCore sharedCore].appIsRunningInBackground)
    {
        if(!(topic ==nil || [topic isEqualToString:@""]))
        {
            NSString *bodyMessage = [NSString stringWithFormat:@"你被加入了群聊[%@]",topic];
            [Utility scheduleLocalNotificationAfter:0 withMessage:bodyMessage];
        }
    }
    [self performSelectorOnMainThread:@selector(onJoinGroupInMainThread:) withObject:gs waitUntilDone:NO];
    [gs release];
    NSLog(@"onGroupJoined group end");
}

//添加打招呼接收方回调
-(void) onSayHiNotifyReceived: (NSNumber *)userid 
                  andPortrait:(NSNumber *)portait 
                      andName:(NSString*)name 
                  andDistance:(NSString*)distance
                   andMessage:(NSString*)msg
{
    tanZhiInfoLog(@"<TCNetworkManager onSayHiNotifyReceived> userid = %@  portait = %@  name = %@  msg = %@",userid,portait,name,msg);
    //创建TCTextMessage对象
    NSString *userID = [NSString stringWithFormat:@"%@" ,userid];
    NSString *portraitId = [NSString stringWithFormat:@"%d" ,[portait intValue]];
    //接收到消息创建会话
    TCSingleSession *currentSession = [[TCCore sharedCore].singleSessionList objectForKey:userID];
    
    NSMutableDictionary *sayHiNoticeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [sayHiNoticeDic setObject:portraitId forKey:@"headPortraitId"];
    if (name)
    {
        [sayHiNoticeDic setObject:name forKey:@"name"];
    }
    if (userID) 
    {
        [sayHiNoticeDic setObject:userID forKey:@"userId"];
    }
    if (msg)
    {
        [sayHiNoticeDic setObject:msg forKey:@"content"];
    }
    if (distance) 
    {
        [sayHiNoticeDic setObject:distance forKey:@"distance"];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [sayHiNoticeDic setObject:dateStr forKey:@"date"];
    
    TCContact *contact = [[TCCore sharedCore] findContactFromSocialityList:userid];
    if (contact){
        
        //更新接收到招呼的人的最新状态
        //contact.userSetName = [Utility calculateStringAndCutoutString:name];
        contact.userHeadImageServerVersion = [portait intValue];
        contact.serverMessage = msg;
        [[TCCore sharedCore] saveSayHiContactList];
        [contact updateContactImage];
        //如果用户已经被加黑，不能受到打招呼消息
        if (contact.isBlock) {
            return;
        }
        
        //做一个补偿逻辑，避免server没有保存打招呼人的情况下，用户注销两个人不能再联系了。
        if(contact.sayHiContactType == sayHiTypeSuccess)
        {
            [self performSelectorOnMainThread:@selector(sayHiInMainThread:) withObject:contact waitUntilDone:NO];
            return;
        }
        //防止把会话删除后数组中没有移除，然后再次收到没有提示显示。
        else if (contact.sayHiContactType == sayHiTypeReceive)
        {
            [[TCCore sharedCore].noticeManager notifySayHiInBizThread:sayHiNoticeDic];
            
        }
        else if (contact.sayHiContactType == sayHiTypeSend)
        {
			// 这个补偿逻辑有点问题，请立冬改一下
			
            contact.sayHiContactType = sayHiTypeSuccess;
            [[TCCore sharedCore] saveSayHiContactList];
            if (currentSession == nil)
            {
                currentSession = [[TCCore sharedCore] openSession:contact];
            }
            currentSession.lastMessageContent = msg;
            currentSession.lastMessageDate = [NSDate date];
            
            //构造TCTextMessage对象
            NSString *msgContent = msg;
            msgContent = [[Utility sharedUtility] decodeAppleEmotionString:msgContent];
            TCTextMessage *tcMsg = [[TCTextMessage alloc] initWithContent:msgContent];
            
            tcMsg.isReceive = YES;
            tcMsg.type = TCMessageText;
            tcMsg.time = [[NSDate date] timeIntervalSince1970];
            //tcMsg.msgID = [NSData dataWithData:message.mMessageGlobalId];
            tcMsg.contactID = [NSString stringWithString:contact.contactPeerID];
            tcMsg.messageManagerDelegate = currentSession;
            currentSession.unreadMessageCount++;
            [currentSession addSayHiMessageTomessageCollection:tcMsg];
            [[TCDbOpreater shareDb] insertMessage:tcMsg withSingleSession:currentSession];
            
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setObject:currentSession forKey:@"currentSession"];
            [dic setObject:tcMsg forKey:@"tcMsg"];
            [self performSelectorOnMainThread:@selector(onMessageReceivedInMainThread:) withObject:dic waitUntilDone:NO];
            //            [self performSelectorOnMainThread:@selector(onSayHiNotifyReceivedInMainThread:) withObject:dic waitUntilDone:NO];
            [tcMsg release];
            
            //后台模拟push消息
            if ([TCCore sharedCore].appIsRunningInBackground)
            {
                [currentSession showLocalPush];
            }
            
            //            contact.serverMessage = [NSString stringWithFormat:@"%@ 回应了你的招呼，和Ta随便聊聊吧",name];
            //            ClientMessage *cinClientMessage = [[ClientMessage alloc] initWith:contact.serverMessage andMessageId:[NSData data] andCreatedTime:[[NSDate date] timeIntervalSince1970] andDialog:nil];
            //            contact.sayHiContactType = sayHiTypeSuccess;
            //            [[TCCore sharedCore] saveSayHiContactList];
            //            if (currentSession == nil)
            //            {
            //                currentSession = [[TCCore sharedCore] openSession:contact];
            //            }
            //            currentSession.lastMessageContent = contact.serverMessage;
            //            currentSession.lastMessageDate = [NSDate date];
            //            [currentSession onMessageReceived:cinClientMessage];
            //            [cinClientMessage release];
            //            
            //            return;
        }
        
        return;
    }//end if (contact) 
    
    //    }//end for
    
    //补偿逻辑，防止可能认识的人中有该人，对象通讯录中删除我，再注销给我打招呼，我能接到招呼
    TCContact *contact2 = [[TCCore sharedCore] findContactByUID2:userid];
    if (contact2.isBlock) {
        return;
    }
    if (contact2 && contact2.sayHiContactType == sayHiTypeNone) {
        [self performSelectorOnMainThread:@selector(sayHiInMainThread:) withObject:contact2 waitUntilDone:NO];
        return;
    }
    
    TCContact *sayHiContact = [[TCContact alloc] init];
    sayHiContact.userId = [NSString stringWithFormat:@"%@" ,userid];
    sayHiContact.userSetName = [Utility calculateStringAndCutoutString:name];
    [sayHiContact setContactAtomicType:AtomicContactTypeFelio];
    [sayHiContact updateSystemContactStat];
    //    sayHiContact.isSocialityContact = YES;
    sayHiContact.userHeadImageServerVersion = [portait intValue];
    sayHiContact.serverMessage = msg;
    sayHiContact.sayHiContactType = sayHiTypeReceive;
    [sayHiContact setNearbySocialityType];
    //    [[TCCore sharedCore].sayHiContactList addObject:sayHiContact];
    [[TCCore sharedCore] addContact2SocialityList:sayHiContact];
    [[TCCore sharedCore] saveSayHiContactList];
    [sayHiContact updateContactImage];
    //发送打招呼消息到消息盒子中
    
    [[TCCore sharedCore].noticeManager notifySayHiInBizThread:sayHiNoticeDic];
    [sayHiContact release];
}


//收到摇一摇的打招呼
-(void) onShakeSayHiNotifyReceived:(NSNumber *)userid andPortrait:(NSNumber *)portait andName:(NSString *)name andMessage:(NSString *)msg
{
    TCContact *shakeContact = [[TCContact alloc] init];
    shakeContact.userId = [NSString stringWithFormat:@"%@" ,userid];
    shakeContact.userSetName = [Utility calculateStringAndCutoutString:name];
    [shakeContact setContactAtomicType:AtomicContactTypeFelio];
    [shakeContact updateSystemContactStat];
    shakeContact.userHeadImageServerVersion = [portait intValue];
    shakeContact.serverMessage = msg;
    shakeContact.sayHiContactType = sayHiTypeSuccess;
    [shakeContact setShakeShakeSocialityType];
    [[TCCore sharedCore] addAndStoreShakeShakeContact:shakeContact];
    [shakeContact updateContactImage];
    [shakeContact release];
}

//收到搜索的打招呼
-(void)onSearchSayHiNotifyReceived:(NSNumber *)userid andPortrait:(NSNumber *)portait andName:(NSString *)name andMessage:(NSString *)msg
{
    NSMutableDictionary *sayHiNoticeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [NSString stringWithFormat:@"%@" ,userid];
    [sayHiNoticeDic setObject:portait forKey:@"headPortraitId"];
    if (name)
    {
        [sayHiNoticeDic setObject:name forKey:@"name"];
    }
    if (userid) 
    {
        [sayHiNoticeDic setObject:userID forKey:@"userId"];
    }
    if (msg)
    {
        [sayHiNoticeDic setObject:msg forKey:@"content"];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [sayHiNoticeDic setObject:dateStr forKey:@"date"];
    
    TCContact *searchContact = [[TCContact alloc] init];
    searchContact.userId = [NSString stringWithFormat:@"%@" ,userid];
    searchContact.userSetName = [Utility calculateStringAndCutoutString:name];
    [searchContact setContactAtomicType:AtomicContactTypeFelio];
    [searchContact updateSystemContactStat];
    searchContact.userHeadImageServerVersion = [portait intValue];
    searchContact.serverMessage = msg;
    searchContact.sayHiContactType = sayHiTypeReceive;
    [searchContact setSearchedSocialityType];
    [[TCCore sharedCore] addContact2SocialityList:searchContact];
    [[TCCore sharedCore] saveSayHiContactList];
    [[TCCore sharedCore].noticeManager notifySayHiInBizThread:sayHiNoticeDic];
    [searchContact updateContactImage];
    [searchContact release];
}

//收到小纸条的打招呼
-(void) onNoteSayHiNotifyReceived:(NSNumber *)userid andPortrait:(NSNumber *)portrait andName:(NSString *)name andGender:(NSString *)gender andProvice:(NSString *)province andNoteId:(NSNumber *)noteId andMessage:(NSString *)message
{
    
}


-(void)onMessageReceivedInMainThread:(NSDictionary *)dic
{
    TCSingleSession *currentSession = [dic objectForKey:@"currentSession"];
    TCTextMessage *msg = [dic objectForKey:@"tcMsg"];
    [currentSession onMessageReceivedInMainThread:msg];
}

#pragma mark -
#pragma mark socket thread funtion

-(void) beginConnect2ServerInBizThread:(AccountInfo*) accountInfo{
    tanZhiInfoLog(@"<TCNetworkManager> beginConnect2ServerInBizThread connect_log reRegistLog:accountInfo=%@",accountInfo);
    
    if (_cinUser == nil) {
//        NSData *dataDeviceToken = nil;
//		if (_currentAccount.strDeviceToken != nil){
//			dataDeviceToken = [AccountInfo ConvertHexStringToBytes:_currentAccount.strDeviceToken];
//		}
        _cinUser = [[CinUser alloc] initWithUserInfo:[_currentAccount.strUid longLongValue]
                                            MobileNo:[_currentAccount.strMoblie longLongValue]
                                               Token:[AccountInfo ConvertHexStringToBytes:_currentAccount.strToken]
                                            Password:[AccountInfo ConvertHexStringToBytes:_currentAccount.strPwd]
                                         deviceToken:nil];
        
        NSNumber *ver = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kUserSettingVersion];
        _cinUser.UserSettingsVersion = ver==nil ? [NSNumber numberWithInt:-1] : ver;
    }
    
    //用户被踢掉后重复注册的逻辑
    if (_cinUser.UserId != [accountInfo.strUid longLongValue]) {
        _cinUser.UserId = [accountInfo.strUid longLongValue];
        _cinUser.MobileNo = [accountInfo.strMoblie longLongValue];
        _cinUser.Token = [AccountInfo ConvertHexStringToBytes:accountInfo.strToken];
        _cinUser.Password = [AccountInfo ConvertHexStringToBytes:accountInfo.strPwd];
        _cinUser.Credential = nil;
        
        NSNumber *ver = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kUserSettingVersion];
        _cinUser.UserSettingsVersion = ver==nil ? [NSNumber numberWithInt:-1] : ver;
    }
    
    if (_cinClient == nil)
	{
		//连接cinclient
		_cinClient = [[CinClient alloc] initWithCinUser:_cinUser andClientVersion:ios_version andAbility:g_ability];
		_cinClient.Event = self;	
        //        _cinClient.mCore.mImageSendingService.mCallback = [TCCore sharedCore].imageSendingManager;
        
        [TCAudioManager initCinClientCore:_cinClient.mCore];
        [[TCBuddyManager sharedManager] setCinClientCore:_cinClient.mCore];
        [[TCSingleSessionManager shareSingleSessionManager]setCinClientCore:_cinClient.mCore];
        [[TCGroupSessionManager shareGroupSessionManager]setCinClientCore:_cinClient.mCore];
        [[TCImageSendingManager shareSendingManager]setCinClientCore:_cinClient.mCore];
        [[TCImageReceivingManager shareReceivingManager]setCinClientCore:_cinClient.mCore];
        [[TCMiscellaneousManager shareInstance] setCinClientCore:_cinClient.mCore];
        [[TCSocialityServiceManager sharedManager] setCinClientCore:_cinClient.mCore];
        
	}
    
    
    BOOL usePush = [[NSUserDefaults standardUserDefaults] boolForKey:kshouldUseApplePushMessage];
    if ( usePush && _currentAccount.strDeviceToken != nil)
    {
        tanZhiInfoLog(@"cinClient beginConnect usePush");
        _cinClient.User.DeviceToken = [AccountInfo ConvertHexStringToBytes:_currentAccount.strDeviceToken];
    }
    else
    {
         tanZhiInfoLog(@"cinClient beginConnect noPush");
        _cinClient.User.DeviceToken =nil;
    }
    
    //oem_tag配置文件
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"oem" ofType:@"txt"];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSString *readStr = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    _cinClient.OemTag = [readStr longLongValue];
    [readStr release];
    if(_currentAccount.ip!=nil && _currentAccount.port!=0) {
        if (!(_cinClient.IsConnected || _cinClient.IsConnecting))
        {
            tanZhiInfoLog(@"<TCNetworkManager> beginConnect2Server connect_log uid:%lld will connect to server ip=%@ port=%d",_cinUser.UserId, _currentAccount.ip, _currentAccount.port);
            //连接服务器
            [[StatusBarData statusBarData] connectToServerNetworkStatus];
            [_cinClient connect:_currentAccount.ip andPort:_currentAccount.port];	
        }
        else{
            tanZhiInfoLog(@"<TCNetworkManager> beginConnect2Server connect_log 正在链接中 ip=%@ port=%d",_currentAccount.ip,_currentAccount.port);
        }
    }
    else{
        [self onConnectFailed]; //通知失败
        tanZhiDebugLog(@"<TCNetworkManager> beginConnect2Server no ip and port");
    }
}


//-(void)createGroupInBizThread:(TCGroupSession*) gs{
//    [_cinClient createGroupWith:gs.topic andGroupTitleImageId:gs.imageIndex andGroupEvent:gs]; 
//}

-(void)updateMyInformationInBizThread:(NSMutableDictionary*)pram{
    NSString *name = [pram objectForKey:@"name"];
    NSString *mood =[pram objectForKey:@"mood"];
    NSString *gender = [pram objectForKey:@"gender"];
    NSString *province=[pram objectForKey:@"province"];
    NSString *city = [pram objectForKey:@"city"];
    NSData *token = [pram objectForKey:@"token"];
    NSObject<CinCallback>  *callback = [pram objectForKey:@"callback"];
    
    [_cinClient updateMyInformation:name andMood:mood andGender:gender andProvince:province andCity:city andAppDeviceToken:token andCallback:callback];
}

-(void)disconnectInBizThread{
    [_cinClient disconnect];
}

-(void)uploadPortraitInBizThread:(NSMutableDictionary*)param{
    NSData *portrait = [param objectForKey:@"portrait"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    [_cinClient uploadPortrait:portrait andCallback:callback];
}

-(void)takePortraitInBizThread:(NSNumber *)uid
{
    [[TCImageReceivingManager shareReceivingManager] queuePortraitQueryOf:uid];
}
-(void)setApplePushTypeInBizThread:(NSMutableDictionary *)param{
    NSNumber *pushType = [param objectForKey:@"pushType"];
    NSObject<CinCallback> *callback =[param objectForKey:@"callback"];
    
    [_cinClient setApplePushType:[pushType longLongValue] andCallback:callback];
}
-(void)setReceiveFetionMessageInBizThread:(NSMutableDictionary *)param{
    
    NSNumber *flag = [param objectForKey:@"flag"];
    NSObject<CinCallback> *callback =[param objectForKey:@"callback"];
    
    [_cinClient setReceiveFetionMessage:[flag boolValue] andCallback:callback];
}
-(void)setFetionLogonInBizThread:(NSMutableDictionary *)param{
    
    NSNumber *flag = [param objectForKey:@"flag"];
    NSObject<CinCallback> *callback =[param objectForKey:@"callback"];
    
    [_cinClient setFetionLogon:[flag boolValue] andCallback:callback];
}

-(void) getInTouchInBizThread:(NSMutableDictionary *)param{
    NSNumber *userId = [param objectForKey:@"userId"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    tanZhiInfoLog(@"<TCNetworkManager> agreeAddFetionBuddyInBizThread add_fetion_log userId = %@",userId);
    [_cinClient getInTouch:[userId longLongValue] andCallback:callback];
}
-(void) acceptTouchMeInBizThread:(NSMutableDictionary *)param{
    NSNumber *userId = [param objectForKey:@"userId"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    
    [_cinClient acceptTouchMe:[userId longLongValue] andCallback:callback];
}
-(void) refuseTouchMeInBizThread:(NSMutableDictionary *)param{
    NSNumber *userId = [param objectForKey:@"userId"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    
    [_cinClient refuseTouchMe:[userId longLongValue] andCallback:callback];
}
-(void) agreeAddFetionBuddyInBizThread:(NSMutableDictionary *)param{
    NSNumber *targetid = [param objectForKey:@"targetid"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    tanZhiInfoLog(@"<TCNetworkManager> agreeAddFetionBuddyInBizThread add_fetion_log targetid = %@",targetid);
    [_cinClient agreeAddFetionBuddy:[targetid longLongValue] andCallback:callback];
}

-(void)refuseAddFetionBuddyInBizThread:(NSMutableDictionary *)param
{
    NSNumber *targetid = [param objectForKey:@"targetid"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    [_cinClient refuseAddFetionBuddy:[targetid longLongValue] andCallback:callback];
}

-(void) addFetionBuddyInBizThread:(NSMutableDictionary *)param{
    NSNumber *mobileNo = [param objectForKey:@"mobileNo"];
    NSObject<CinBuddyCallback> *callback = [param objectForKey:@"callback"];
    
    [_cinClient addFetionBuddy:[mobileNo longLongValue] andCallback:callback];
    tanZhiDebugLog(@"<TCNetworkManager> addFetionBuddyInBizThread mobileNo=%@", mobileNo);
}

-(void) sendMutipleMessageInBizThread:(NSMutableDictionary *)param{
    NSArray *peerIds = [param objectForKey:@"peerIds"];
    NSString *message = [param objectForKey:@"message"];
    NSObject<CinMutipleCallback>  *callback = [param objectForKey:@"callback"];
    
    [_cinClient sendMutipleMessage:peerIds andMessage:message andCallback:callback];
}

-(void) sendMutipleMessageImageInBizThread:(NSMutableDictionary *)param{
    NSArray *peerIds = [param objectForKey:@"peerIds"];
    NSString *message = [param objectForKey:@"message"];
    CinImage *image = [param objectForKey:@"image"];
    NSObject<CinMutipleCallback>  *callback = [param objectForKey:@"callback"];
    
    [_cinClient sendMutipleMessage:peerIds andMessage:message andImage:image andCallback:callback];
}

-(void) sendMutipleMessageVoiceInBizThread:(NSMutableDictionary *)param{
    NSArray *peerIds = [param objectForKey:@"peerIds"];
    NSString *message = [param objectForKey:@"message"];
    CinVoice *voice = [param objectForKey:@"voice"];
    NSObject<CinMutipleCallback>  *callback = [param objectForKey:@"callback"];
    
    [_cinClient sendMutipleMessage:peerIds andMessage:message andVoice:voice andCallback:callback];
}

-(void) shareLocationInBizThread:(NSMutableDictionary *)param{
    
    NSString *longitude = [param objectForKey:@"longitude"];
    NSString *latitude = [param objectForKey:@"latitude"];
    NSObject<CinCallback> *callback = [param objectForKey:@"callback"];
    
    long long lon = (180.0-[longitude doubleValue]) * 1000000LL;
    long long lat = (90.0-[latitude doubleValue]) * 1000000LL;
    
    [_cinClient shareLocation:lon andLatitude:lat andCallback:callback];
}

-(void) cancelLocationInBizThread:(NSMutableDictionary *)param{
    
    NSObject<CinCallback> *callback = [param objectForKey:@"callback"];
    
    [_cinClient cancellocation:callback];
}

-(void)sayHiInBizThread:(NSMutableDictionary *)param
{
    TCContact *contact = [param objectForKey:@"contact"];
    NSObject<CinCallback>* callback = [param objectForKey:@"callback"];
    TCSayHiCallBack *sayHicallback = [[TCSayHiCallBack alloc] init];
    sayHicallback.callback = callback;
    sayHicallback.contact = contact;
    [_cinClient sayHi:[contact.userId longLongValue] andCallback:sayHicallback];
    [sayHicallback release];
}

-(void)getMatchResultInBizThread:(TCGetMatchResultCallBack*)callback
{
    [_cinClient getMatchResult:callback];
}

#pragma mark -
#pragma mark main thread notify funtion
-(void)onConnectedInMainThread{
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerConnectServerSuccess)]) 
	{
		[_delegate TCNetworkManagerConnectServerSuccess];
	}
}

-(void)onRegisteredInMainThread{
    //注册一个观察者,当contactAddressList初始化完成时
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyAddressBookFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self  selector: @selector(notifyAddressBookFinished:)  name: notifyAddressBookFinished object: nil];
    
    //登录成功5秒钟后如果没有收到离线消息，关闭自动切换到会话列表的标志位
	[TCCore sharedCore].shouldSwitchToChatlistView = YES;
	[self performSelector:@selector(turnOffShouldSwitchToChatlistView)
			   withObject:nil
			   afterDelay:5];
    
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerLogonSuccess)]) 
	{
		[_delegate TCNetworkManagerLogonSuccess];
	}
    
    [StatusBarData statusBarData].networkConnectStatus = connectReachable;
    [[StatusBarData statusBarData] monitorNetworkConnectStatus];
    
    //广播通知：
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyLogonSuccess
                                                        object:nil
                                                      userInfo:nil];
}
-(void)onTakeVisitingCardInMainThread{
    //广播通知：名片信息发生了变更
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNameCardUpdated
                                                        object:nil
                                                      userInfo:nil];
    
    if ([TCCore sharedCore].contactManager.contactsReady)
    {
        NSLog(@"notifyAddressBookUpdaeData:2");
        [[NSNotificationCenter defaultCenter] postNotificationName:notifyAddressBookUpdaeData
                                                            object:nil
                                                          userInfo:nil];
    }
}

-(void)onTakePortraitInMainThread:(NSString *)sessionID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:sessionID forKey:@"groupSessionID"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyGroupImageChanged object:nil userInfo:dic];
}

-(void)onRegisterFailedInMainThread{
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerLogonFailed)]) 
	{
		[_delegate TCNetworkManagerLogonFailed];
	}
}

-(void)onRegisterFailedNeedReregInMainThread{
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerLogonFailedNeedReLogon)])
	{
		[_delegate TCNetworkManagerLogonFailedNeedReLogon];
	}
}
-(void)onCheckCredentialFailedInMainThread{
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerCheckCredentialFailed)])
	{
		[_delegate TCNetworkManagerCheckCredentialFailed];
	}
}
-(void)onDisconnectedInMainThread{
    
	//调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerDisconnectServerSuccess)])
	{
		[_delegate TCNetworkManagerDisconnectServerSuccess];
	}
}
-(void)onConnectFailedInMainThread{
    //调用代理方法
	if (_delegate && [_delegate respondsToSelector:@selector(TCNetworkManagerConnectServerFailed)])
	{
		[_delegate TCNetworkManagerConnectServerFailed];
	}
}
-(void)getingHeadImageFinishedInMainThread{
    [self getingHeadImageFinished];
}

-(void)onAddBuddyAgreeInMainThread:(TCContact *)contact{
    if ([TCCore sharedCore].addFetionBuddyCallback) {
        [[TCCore sharedCore].addFetionBuddyCallback addOK:contact];     
    }
}
-(void)onAddBuddyRefuseInMainThread:(TCContact *)contact{
    if ([TCCore sharedCore].addFetionBuddyCallback) {
        [[TCCore sharedCore].addFetionBuddyCallback addFail:contact];
    }
}

-(void)onSayHiNotifyReceivedInMainThread:(NSMutableDictionary*)dic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyMessageReceived object:nil userInfo:dic];
}

-(void)onJoinGroupInMainThread:(TCGroupSession *)gs
{
    if ([TCCore sharedCore].groupSessionMgrDelegate) {
        [[TCCore sharedCore].groupSessionMgrDelegate onJoinGroup:gs];
    }
}

//补偿逻辑，server建好这个功能后取消。
-(void)sayHiInMainThread:(TCContact *)contact
{
    TCContact *selfContact = [TCCore sharedCore].selfContact;
    [[TCSingleSessionManager shareSingleSessionManager] responseSayHi:contact andContent:[NSString stringWithFormat:@"%@回应了你的招呼，和Ta随便聊聊吧",selfContact.userSetName] andComplete:^(NSNumber *success)
     {
         if ([success boolValue]) {
             tanZhiDebugLog(@"<TCNetWorkManager> responseSayHi success");
         }
     }];
}

-(void)checkUpDateInMainThread:(NSDictionary *)userInfo
{
    //post notifyCheckUpdate
	[[NSNotificationCenter defaultCenter] postNotificationName:notifyCheckUpdate 
														object:nil 
													  userInfo:userInfo]; 
}

#pragma mark -
#pragma mark notifyAddressBookFinished
- (void)notifyAddressBookFinished :(NSNotification *)note
{
    NSLog(@"notifyAddressBookFinished 1" );
    if ([TCNetworkManager sharedInstance].IsRegisted)
    {
        //设置名字  1.50版本不再需要专门改名字，每次登录注册都会设置
//        NSString *registerName = [[NSUserDefaults standardUserDefaults] stringForKey:@"RegisterName"];
//        if ([registerName length] != 0) {
//            NSLog(@"<TCNetworkManager> onRegistered set Name card name=%@",registerName);
//            TCLogonNameCardCallBackWrap *logonNameCardCallBackWrap = [[TCLogonNameCardCallBackWrap alloc] init];
//            [self updateMyInformation:registerName andMood:nil andGender:nil andProvince:nil andCity:nil andCallback:logonNameCardCallBackWrap];
//            [logonNameCardCallBackWrap release];
//        }
        [self uploadContactAddressList];
    }
    
}

#pragma mark - privat
//-(void)changeContactType:(CinUserInfo*)serverUserInfo contact:(TCContact*)aContact{
//    if ((serverUserInfo.IsFetionChatUser==0) && (serverUserInfo.IsFetionBuddy==0)) { //00
//        tanZhiWarningLog(@"<TCNetworkManager> onUserInfoNotifyReceived 不是飞信好友，也不是飞聊用户，这样的用户不应当出现！");
//        tanzhiLogFlush();
//        tanzhiAssert(0);
//        //continue; //正式上下用这个逻辑
//    }
//    switch(serverUserInfo.IsFetionBuddy){
//        case 0:
//            [aContact clearContactAtomicType:AtomicContactTypeFetion];
//            [aContact clearContactAtomicType:AtomicContactTypeFetionBuddy];
//            break;
//        case 1:
//            [aContact setContactAtomicType:AtomicContactTypeFetion];
//            [aContact setContactAtomicType:AtomicContactTypeFetionBuddy];
//            break;
//        default:
//            break;
//    }
//    switch(serverUserInfo.IsFetionChatUser){
//        case 0:
//            [aContact clearContactAtomicType:AtomicContactTypeFelio];
////            [aContact clearContactAtomicType:AtomicContactTypeFelioBuddy];
//            break;
//        case 1:
//            [aContact setContactAtomicType:AtomicContactTypeFelio];
////            if([aContact numberIsValid]){
////                [aContact setContactAtomicType:AtomicContactTypeFelioBuddy];
////            }
//            break;
//        default:
//            break;
//    }
//    [aContact updateSystemContactStat];
//}


//-(void)dealOneCinClinetNotifyUserInfo:(CinUserInfo*)i{
//
//    if([i.UserName isEqualToString:@""]){
//        i.UserName = nil;
//    }
//    if([i.FetionNickName isEqualToString:@""]){
//        i.FetionNickName = nil;
//    }
//    if([i.FetionName isEqualToString:@""]){
//        i.FetionName = nil;
//    }
//    TCContact *c = [[TCCore sharedCore] findContactByUID:i.UserId];
//    if(c.isSocialityContact){
//        [[TCCore sharedCore] addContactToTanzhiUserListFromSayHiList:c];
//    }
//    if (c!=nil) {
//        if (i.MobileNo!=-1){
//            //有手机号的飞聊用户，不允许再更改手机号
//            if(!([c numberIsValid] && ((c.contactType&AtomicContactTypeFelio) == 1))){
//                c.number = [NSString stringWithFormat:@"%qi",i.MobileNo];
//            }
//        }
//    }
//    //更新姓名，头像和心情短语更新。
//    if (c != nil)
//    {
//        //心情不为空时不更新心情。
//        if (i.UserMood!=nil) 
//        {
//            tanZhiInfoLog(@"更改%@的心情为:%@ type=%d",c.userId,i.UserMood, c.contactType);
//            c.impresa = [[Utility sharedUtility] decodeAppleEmotionString:i.UserMood];
//        }
//        if (i.UserName!=nil)
//        {
//            tanZhiInfoLog(@"更改UserName %@的名片名称为:%@ type=%d",c.userId,i.UserName, c.contactType);
//            NSString *tmp = [[Utility sharedUtility] decodeAppleEmotionString:i.UserName];
//            c.userSetName = [Utility calculateStringAndCutoutString:tmp];
//        }
//        if (i.FetionName != nil) {
//            tanZhiInfoLog(@"更改FetionName %@的名片名称为:%@ type=%d",c.userId,i.FetionName, c.contactType);
//            NSString *tmp = [[Utility sharedUtility] decodeAppleEmotionString:i.FetionName];
//            c.fetionName = [Utility calculateStringAndCutoutString:tmp];
//        }
//        if (i.FetionNickName!=nil)
//        {
//            tanZhiInfoLog(@"更改FetionNickName %@的名片名称为:%@ type=%d",c.userId,i.FetionNickName, c.contactType);
//            NSString *tmp = [[Utility sharedUtility] decodeAppleEmotionString:i.FetionNickName];
//            c.fetionNickName = [Utility calculateStringAndCutoutString:tmp];
//        }
//        if (i.HeadId > 0)
//        {
//            c.userHeadImageServerVersion = i.HeadId;
//            if (c.userHeadImageServerVersion != c.userHeadImageVersion) 
//            {
//                tanZhiInfoLog(@"更改%@的名片头像为:%lld",c.userId,i.HeadId);
//            }
//        }
//        [self changeContactType:i contact:c];
//        [self addNewContactFinished];
//        return;
//    }        
//    TCContact *aContact = [[TCContact alloc] initWithCinUserInfo:i];
//    
//    [self changeContactType:i contact:aContact];        
//    
//    aContact.userSetName = i.UserName;
//    aContact.userHeadImageServerVersion = i.HeadId;
//    if(i.UserId>=10000000L && i.UserId<=99999999L)
//    {
//        [aContact setContactAtomicType:AtomicContactTypeRobot];
//        //飞聊小助手
//        if ([aContact.userId isEqualToString:kTanzhiRobotUserid]) 
//        {
//            aContact.userSetName = @"飞聊小助手";
//        }
//        //新浪微博小助手
//        else if ([aContact.userId isEqualToString:kSinaWeiboRobotUserid]) 
//        {
//            aContact.userSetName = @"新浪微博小助手";
//        }
//        //移动微博小助手
//        else if ([aContact.userId isEqualToString:kCMCCWeiboRobotUserid]) 
//        {
//            aContact.userSetName = @"移动微博小助手";
//        }
//        //私密日记
//        else if ([aContact.userId isEqualToString:kSpaceBlogRobotUserid]) 
//        {
//            aContact.userSetName = @"私密日记";
//        }
//        else
//        {
//            aContact.userSetName = @"机器人";
//        }
//    }
//    
//    [[TCCore sharedCore] addContactToContactList:aContact];
//    [aContact release];
//    [self addNewContactFinished];
//    
//}

- (void)timerFiredInBizThread:(NSTimer *)timer
{
	NSLog(@"do nothing");
}

-(void)uploadContactAddressListInBizThread{
    [[TCCore sharedCore].contactManager uploadContactAddressListInBizThread];
}

//- (void)addNewContactFinishedPrivate{
//    
//}

@end
