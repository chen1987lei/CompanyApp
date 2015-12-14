//
//  TCRegisterManager.m
//  feilio
//
//  Created by chen lei on 12-5-4.
//  Copyright (c) 2012年 Feiliao. All rights reserved.
//

#import "TCRegisterManager.h"

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSRange.h>
#import <Foundation/NSString.h>


#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH

static TCRegisterManager *sharedInstance = nil;


@implementation TCRegisterManager 
@synthesize accountText = _accountText;
@synthesize passwordText = _passwordText;
@synthesize smscode = _smscode;
@synthesize registerType = _registerType;
@synthesize bindingMobileNumber = _bindingMobileNumber;
@synthesize userSetName = _userSetName;
@synthesize socialityName = _socialityName;

@synthesize needVerification = _needVerification;
@synthesize needBindMobile = _needBindMobile;
@synthesize bindActionType = _bindActionType;

@synthesize passwordExpressInfo = _passwordExpressInfo;
@synthesize passwordResetMobileNumber = _passwordResetMobileNumber;  
@synthesize passwordResetWebAddress = _passwordResetWebAddress;

+(TCRegisterManager *)sharedManager
{
    if (sharedInstance==nil)
    {
        sharedInstance = [[TCRegisterManager alloc] init];
    }
    return sharedInstance;
}


/*
-(void)dealloc
{
    [_accountText release];
    [_passwordText release];
    [_smscode release];
    [_bindingMobileNumber release];
    
    [_passwordExpressInfo release];
    [_passwordResetMobileNumber release];  
    [_passwordResetWebAddress release];
    [super dealloc];
}

-(void)clearAllAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _registerType = registerNone;
    _needVerification = NO;
    _needBindMobile = NO;
    _bindingMobileNumber = nil;
}

+(BOOL)checkIsChinaMobile:(NSString *)numberText
{
    if ([Utility validateMobileNumber:numberText]) { 
        if ([numberText hasPrefix:@"1349"]) {
            return NO;  //分给电信，卫星手机卡
        }
        
        NSArray *arr = [NSArray arrayWithObjects:@"134",@"135", @"136",@"137",@"138",@"139",@"147",@"150",@"151",@"152",@"157",@"158",@"159",@"182",@"183",@"187",@"188",nil];//移动号段
        for (NSString *str in arr) {
            if ([numberText hasPrefix:str]) 
            {
                return YES;  
            }
        }
    }
    return NO;  
}

#pragma mark - 
#pragma mark notifyGetDomain
-(void)notifyGetDomainInfoResult:(NSNotification *)note
{                   // 手机号登录，邮箱登录， 手机号注册，都需要domain （邮箱注册）
    NSNumber* responseCode = [note.userInfo objectForKey:@"responseCode"];
    switch (_registerType) {
            case requestPasswordInfo:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:notifyRequestPasswordResetInfoResult object:nil userInfo:note.userInfo];
        }
            break;
        case mobileLogin:
        {
             if ( [responseCode intValue] == 0x80) {
                 [[TCNetworkManager sharedInstance] fetionUserReg1:_accountText andDomainPsd:_passwordText ];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginMobileNumberResult object:nil userInfo:note.userInfo];
             }
        }
            break;
        case mailLogin:
        {
            if ( [responseCode intValue] == 0x80) {
                [[TCNetworkManager sharedInstance] mailLoginFirstStep:_accountText andPsd:_passwordText];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:notifyLoginMailAccountResult
                                                                    object:nil userInfo:note.userInfo];
            }
        }
            break;
        case mobileRegister:
        {
            if ( [responseCode intValue] == 0x80) {
                [[TCNetworkManager sharedInstance] mobileRegistFirstStep:_accountText];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMobileRequestSMSResult
                                                                    object:nil userInfo:note.userInfo];
            }
        }
            break;
        case mailRegister:  // 现在没有走getdomain这步
        {
            if ( [responseCode intValue] == 0x80) {
                [[TCNetworkManager sharedInstance] mailRegistFirstStep:_accountText];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:notifyRegisterMailAccountResult
                                                                    object:nil userInfo:note.userInfo];
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark - 
#pragma mark reset Password server info

-(void)requestPasswordResetInfoFromServer
{
    _registerType = requestPasswordInfo;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyGetDomainInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyGetDomainInfoResult:) name:notifyGetDomainInfo object:nil];
    [[TCNetworkManager sharedInstance] getMobileRegistDomain];
}

#pragma mark - 
#pragma mark login 
-(void)loginWithMobileNumber:(NSString *)mobileNumber andPassword:(NSString *)password
{
    _registerType = mobileLogin;
    [_accountText release];
    _accountText = [mobileNumber retain];
    [_passwordText release];
    _passwordText = [password retain]; 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyGetDomainInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyGetDomainInfoResult:) name:notifyGetDomainInfo object:nil];
    
    [[TCNetworkManager sharedInstance] getMobileRegistDomain];
}

-(void)loginWithMailAccount:(NSString *)mailAccount andPassword:(NSString *)password
{
     _registerType = mailLogin;
    [_accountText release];
    _accountText = [mailAccount retain];
    [_passwordText release];
    _passwordText = [password retain]; 
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyGetDomainInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyGetDomainInfoResult:) name:notifyGetDomainInfo object:nil];
    
    [[TCNetworkManager sharedInstance] getMobileRegistDomain];
}

#pragma mark - 
#pragma mark register  withMobile
-(void)registerWithMobileNumber:(NSString *)mobileNumber
{
     _registerType = mobileRegister;
    [_accountText release];
    _accountText = [mobileNumber retain];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyGetDomainInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyGetDomainInfoResult:) name:notifyGetDomainInfo object:nil];
    [[TCNetworkManager sharedInstance] getMobileRegistDomain];
}

-(void)registerWithMobileNumberCheckSmsCode:(NSString *)regsms
{
    [_smscode release];
    _smscode = [regsms retain];
    [[TCNetworkManager sharedInstance] mobileRegistSecondStep:_accountText andDomainPsd:_smscode];
}


#pragma mark - 
#pragma mark registerWithMailAccount
-(void)registerWithMailAccount:(NSString *)mailAccount  //界面可以直接调用
{
    _registerType = mailRegister;
    [_accountText release];
    _accountText = [mailAccount retain];
    [[TCNetworkManager sharedInstance] mailRegistFirstStep:mailAccount];
}



#pragma mark - 
#pragma mark registerGetVertifacation

-(void)loginAndRegisterSetName:(NSString *)userName andNickName:(NSString *)nickName  // 参数使用属性变量 //界面可以直接调用
{
    [_userSetName release];
    _userSetName = [userName retain];
    
    [_socialityName release];
    _socialityName = [nickName retain];
    switch (_registerType) {
        case mobileLogin:
        {
            [[TCNetworkManager sharedInstance] fetionUserReg2:_accountText
                                                 andDomainPsd:_passwordText andName:userName andNickName:nickName];
        }
            break;
        case mailLogin:
        {
            [[TCNetworkManager sharedInstance] mailLoginSecondStep:_accountText andName:userName andNickName:nickName andPsd:_passwordText];    
        }
            break;
        case mobileRegister:
        {
            [[TCNetworkManager sharedInstance] mobileRegistThirdStep:_accountText andDomainPsd:_smscode andName:userName andNickName:nickName];
        }
            break;
        case mailRegister: 
        {
            [[TCNetworkManager sharedInstance] mailRegistSecondStep:_accountText
                                                            andName:userName andNickname:nickName andPsd:_passwordText];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 
#pragma mark registerGetVertifacation

-(void)registerGetVertifacation
{
    //图验
//    UIKIT_EXTERN NSString *const notifyPicVerifyInfo;
}

-(void)registerCheckVertifacationWithPicCodeContent:(NSString *)picCodeContent
{
    
//    UIKIT_EXTERN NSString *const notifyPicVerifyCodeInfo;  
}

#pragma mark - 
#pragma mark  picVerify
-(void)requestpicVerifyImage
{
    [[TCNetworkManager sharedInstance] picVerify];
}

-(void)checkVerifyImageID:(NSString *)picCodeID andPicCodeContent:(NSString *)codeContent
{
    [[TCNetworkManager sharedInstance] verifyPicCode:picCodeID andPicCodeContent:codeContent];
}

#pragma mark - bind mobile with email
-(void)getVerifyCodeForBindMobile:(NSString *)mobileNo andUserId:(NSNumber *)userId
{
    _registerType = bindMobile;
    [[TCNetworkManager sharedInstance] bindMobileNo1:userId andMobile:mobileNo];
}

-(void)verifyBindRequestWithMobile:(NSString *)mobileNo andUserId:(NSNumber *)userId andSMSCode:(NSString *)code
{
    [[TCNetworkManager sharedInstance] bindMobileNo2 :userId andMobile:mobileNo andVerifyCode:code];
}

-(void)bindMobileSuccessUpdateContact
{
    [self performSelector:@selector(bindMobileSuccessUpdateContactInBizThread) onThread:[TCNetworkManager sharedInstance].bizThread withObject:nil waitUntilDone:NO];
}

-(void)bindMobileSuccessUpdateContactInBizThread
{
    TCContact *selfContact = [TCCore sharedCore].selfContact;
    selfContact.number = [TCRegisterManager sharedManager].bindingMobileNumber;
    [[TCDbOpreater shareDb]updateContact:selfContact];
}
*/
@end
