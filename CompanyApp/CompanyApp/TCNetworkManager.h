//
//  TCNetworkManager.h
//  tanzhi
//
//  Created by HanKui on 11-5-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinClientEvent.h"
//#import "TCCallBacks.h"
#import "ASIHTTPRequest.h"
#import "AccountInfo.h"
#import "define.h"
#import "Utility.h"
#import "TanzhiCore.h"
#import "Reachability.h"

@class CinClientCore;

typedef enum 
{
	// Apple NetworkStatus Constant Names.
	TCNotReachable     = 0,
	TCReachableViaWWAN = 1,
	TCReachableViaWiFi = 2
} TCNetworkStatus;

@protocol TCNetworkManagerDelegate <NSObject>

@optional
//导航注册回调
- (void) TCNetworkManagerNavSuccess;
- (void) TCNetworkManagerNavFailed;
- (void) TCNetworkManagerRegistSuc_bizThreadcess;
- (void) TCNetworkManagerRegistFailed;
- (void) TCNetworkManagerRegistSMSCheckSuccess:(NSMutableDictionary *)info;
- (void) TCNetworkManagerRegistSMSCheckFailed;

@optional
//服务器连接回调
- (void) TCNetworkManagerConnectServerSuccess;
- (void) TCNetworkManagerConnectServerFailed;
- (void) TCNetworkManagerDisconnectServerSuccess;

@optional
//登录相关回调
- (void) TCNetworkManagerLogonSuccess;
- (void) TCNetworkManagerLogonFailed;
- (void) TCNetworkManagerLogonFailedNeedReLogon;
- (void) TCNetworkManagerCheckCredentialFailed;

@end

@class TCGroupSession; 
@interface TCNetworkManager : BusinessActionPerformer <CinClientEvent>
{
    //是否客户端升级
    BOOL isClientUpdating;
    
	//user account info
	AccountInfo *_currentAccount;
	
	CinClient *_cinClient;
	CinUser *_cinUser;
	
    //NSString * _ipAddress;
    //NSInteger _port;
	
	id<TCNetworkManagerDelegate> _delegate;

    
    //Richability status
    TCNetworkStatus _networkStatus;
	NSDate *_getNavSuccessedTime;
    
    //userInfo回调中需要用到  11.7.21
//    NSOperationQueue *operationQueue;
//    BOOL isNeedUpdate;
//    NSMutableArray *_cinClientNotifyUserInfoCollection;
//    NSCondition *_cinClientNotifyUserInfoCondition;
    NSThread *_bizThread;
    NSTimer *_socketTimer;
    
    NSString* smschkDomain;
    NSString *_domainName;
    NSData* smschkCredential;
    
}
@property(assign) id<TCNetworkManagerDelegate> delegate;
//@property(nonatomic, readonly) CinClient *cinClient;
@property(nonatomic, readonly, getter=getAccountMobile) NSString *accountMobile;
@property(nonatomic,setter = setNetworkStatus:) TCNetworkStatus networkStatus;
@property(nonatomic, readonly)NSThread *bizThread;
@property(readonly,getter = getCounterSendBytes) long long Counter_SendBytes;
@property(readonly,getter = getCounterRecvBytes) long long Counter_RecvBytes;
@property(readonly,getter = getIsRegisted) BOOL IsRegisted;
@property(readonly,getter = getIsConnected) BOOL IsConnected;
@property(readonly,retain)NSString* smschkDomain;
@property(readonly,getter = getCredential)NSData *Credential;
@property(readonly,getter = getContactBookVersion) long long ContactBookVersion;
@property(readonly,getter = getCinClientCore) CinClientCore* cinClientCore;
+(TCNetworkManager *)sharedInstance;

- (void) CheckForUpdate;
- (void) GetNav:(NSString*)version Url:(NSString*)url AccountInfo:(AccountInfo*) accountInfo;
- (void) Regist:(NSString*)version Url:(NSString*)url Mobile:(NSString*) mobile;
- (void) RegistSMSCheck:(NSString*)sms Url:(NSString*)url userInputMobile:(NSString*)mobile;
- (void) createGroup:(TCGroupSession*) gs;
- (void) reInitializeGroupInBizThread:(TCGroupSession*) gs;
//add by laim
//-飞信
- (void) mobilePwdRegister:(NSString*)version Url:(NSString*)url Mobile:(NSString*) mobile;
- (void) mobilePwdChk:(NSString*)version Url:(NSString*)url Mobile:(NSString*) mobile Regkey:(NSString*) regkey;
//-飞聊
-(void) newRegistSMS:(NSString*)version Mobile:(NSString*) mobile;
-(void) newRegistSMSCheck:(NSString*)sms userInputMobile:(NSString*)mobile;
-(void) newRegistSMSSetPwd:(NSString*) mobile  password:(NSString*)password Userid:(NSNumber*)userID;

-(void)dynamicPasswordSMS:(NSString*)version Mobile:(NSString *)mobile;

-(void)getMobileRegistSMSInfo;

//手机号注册新2012.5.2

/*
    手机号和验证码注册调用 0、1、2、3
 */

-(void) getMobileRegistDomain;                          //0
-(void) mobileRegistFirstStep:(NSString *) mobile;      //1 getSMS  NeedVerification
-(void) mobileRegistSecondStep:(NSString *) mobile      //2 CheckSms NeedVerification
                  andDomainPsd:(NSString *)domainPsd;  
-(void) mobileRegistThirdStep:(NSString *)mobile        //3 Regsms NeedVerification
                   andDomainPsd:(NSString *)domainPsd 
                      andName:(NSString *)name 
                  andNickName:(NSString *)nickName;

//飞信手机号登录
-(void)fetionUserReg1:(NSString *)mobile        // checkfetionpwd NeedVerification
         andDomainPsd:(NSString *)domainPsd;
-(void) fetionUserReg2:(NSString *)mobile       //regfetionuser NeedVerification
                 andDomainPsd:(NSString *)domainPsd 
                      andName:(NSString *)name 
                  andNickName:(NSString *)nickName;


//-邮箱注册
-(void) mailRegistFirstStep :(NSString*) mail;  //getemailuid NeedVerification

-(void) mailRegistSecondStep :(NSString*) mail  //sendmail NeedVerification
            andName:(NSString *)name 
        andNickname:(NSString *)nickName
             andPsd:(NSString *)psd;

//-邮箱登录 （邮箱地址和密码注册）
-(void) mailLoginFirstStep :(NSString*) mail    //checkmail NeedVerification
                     andPsd:(NSString *)psd;

-(void) mailLoginSecondStep :(NSString*) mail   //regmail NeedVerification
                     andName:(NSString *)name 
                 andNickName:(NSString *)nickName
                      andPsd:(NSString *)psd;

//图验
-(BOOL)needVerification: (NSDictionary *)userInfo;
-(void) picVerify;  
-(void) verifyPicCode:(NSString *)picCodeID 
    andPicCodeContent:(id)codeContent;

//绑定手机号
-(void)bindMobileNo1:(NSNumber *)userid 
           andMobile:(NSString *)mobile;

-(void)bindMobileNo2:(NSNumber *)userid 
           andMobile:(NSString *)mobile 
       andVerifyCode:(NSString *)code;

//返回值 YES :不需要马上获取导航
//      NO: IP,PORT 无效，需要马上获取导航
- (BOOL) beginConnect2Server:(AccountInfo*) accountInfo;
-(void)takePortrait:(NSString *)param;

-(void)updateMyInformation:(NSString*) name andMood:(NSString*) mood andGender:(NSString*) gender andProvince:(NSString*) province andCity: (NSString*) city andCallback:(NSObject<CinCallback> *)callback;
-(void)updateAppToken:(NSData*) token andCallback:(NSObject<CinCallback> *)callback;

//界面要上传
-(void) uploadContactAddressList;
-(void) newContactBook:(NSArray *)mobile version:(NSInteger) ver;
-(void)disconnect;
-(void)uploadPortrait:(NSData *)portrait andCallback:(NSObject<CinCallback>*) callback;
-(void) setApplePushType:(long long) value andCallback:(NSObject<CinCallback> *)callback;
-(void) setReceiveFetionMessage:(BOOL) flag andCallback:(NSObject<CinCallback> *)callback;
-(void) setFetionLogon:(BOOL) flag andCallback:(NSObject<CinCallback> *)callback;
//-(CinClientCore *) getCinClientCore;

-(void) getInTouch:(long long) userId andCallback:(NSObject<CinCallback>*) callback;
-(void) acceptTouchMe:(long long) userId andCallback:(NSObject<CinCallback> *) callback;
-(void) refuseTouchMe:(long long) userId andCallback:(NSObject<CinCallback> *) callback;
-(void) agreeAddFetionBuddy:(long long) targetid andCallback:(NSObject<CinCallback>*) callback;
-(void)refuseAddFetionBuddy:(long long) targetid andCallback:(NSObject<CinCallback>*) callback;
-(void) addFetionBuddy:(long long) mobileNo andCallback:(NSObject<CinBuddyCallback>*) callback;
-(void) addContactBook:(NSArray *) contacts version:(long long) ver;
-(void) removeContactBook:(NSArray *) contacts version:(long long) ver;
-(void) clearRecvBytes;
-(void) clearSendBytes;
//-(void) removeDialog: (CinDialog *) dialog ;
-(CinVoice *) createAttachVoice:(long long)rate andType:(long long)type;
-(CinImage *) createAttachImage:(NSData*)thumbData andFileName:(NSString*)fileName andImageData:(NSData*)imageData;
-(void) sendMutipleMessage:(NSArray*)peerIds andMessage:(NSString*) message andCallback:(NSObject<CinMutipleCallback> *) callback;
-(void) sendMutipleMessage:(NSArray*)peerIds andMessage:(NSString*) message andImage:(CinImage*) image andCallback:(NSObject<CinMutipleCallback> *) callback;
-(void) sendMutipleMessage:(NSArray*)peerIds andMessage:(NSString*) message andVoice:(CinVoice*) voice andCallback:(NSObject<CinMutipleCallback> *) callback;
-(void) initGroup; //有2个点调用此函数：登录成功；数据库读取完成
-(void)reSetCinUser;

-(void)shareLocation:(double)longitude andLatitude:(double)latitude andCallback:(NSObject<CinCallback>*) callback;
-(void)cancellocation:(NSObject<CinCallback>*) callback;
-(void)sayHi:(TCContact *)contact andCallback:(NSObject<CinCallback> *)callback;
-(void)getMatchResult:(NSObject<CinLocationCallback>*)callback;

@end
