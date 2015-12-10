//
//  TCRegisterManager.h
//  feilio
//
//  Created by chen lei on 12-5-4.
//  Copyright (c) 2012年 Feiliao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    registerNone = 0,
    requestPasswordInfo,
    mobileLogin,
    mailLogin,
    mobileRegister,
    mailRegister,
    bindMobile  //邮箱注册用户绑定手机号
}RegisterType;


typedef enum{
    bindActionSelf = 0,
    bindActionOthers,
    bindActionNotice
}BindMobileActionType;

@interface TCRegisterManager : NSObject
{
    NSString *_accountText;  //
    NSString *_passwordText;
    NSString *_bindingMobileNumber; //正在绑定的手机号
    
    NSString *_smscode;   //手机注册，短信验证码

    RegisterType _registerType;   //邮箱注册或登录

    NSString *_userSetName;
    NSString *_socialityName;
    
    NSString *_picCodeID;
    
    BOOL _needVerification;
    BOOL _needBindMobile;
    BindMobileActionType _bindActionType;
    
    NSString *_passwordResetMobileNumber;  // server短信重置密码号码
    NSString *_passwordResetWebAddress;  // server官网重置密码网址
    NSString *_passwordExpressInfo;  //server接口密码规则
}

@property(nonatomic,assign) BOOL needVerification;
@property(nonatomic,assign) BOOL needBindMobile;
@property(nonatomic,assign) BindMobileActionType bindActionType;

@property (nonatomic,readonly) NSString *smscode;
@property (nonatomic,readonly) NSString *accountText;
@property (nonatomic,retain) NSString *passwordText; // 没有接口交互，只是暂存

@property(nonatomic,retain) NSString *passwordExpressInfo;
@property(nonatomic,retain) NSString *passwordResetMobileNumber;  // server短信重置密码号码
@property(nonatomic,retain) NSString *passwordResetWebAddress;  // server官网重置密码网址

@property (nonatomic,readonly) NSString *userSetName;
@property (nonatomic,readonly) NSString *socialityName;
@property (nonatomic,readonly) RegisterType registerType;
@property (nonatomic,retain) NSString *bindingMobileNumber;
+(TCRegisterManager *)sharedManager; 
-(void)clearAllAction;

+(BOOL)checkIsChinaMobile:(NSString *)numberText;

-(void)requestPasswordResetInfoFromServer;   //获取短信手机号，官网 网址
-(void)loginWithMobileNumber:(NSString *)mobileNumber andPassword:(NSString *)password;
-(void)loginWithMailAccount:(NSString *)mailAccount andPassword:(NSString *)password;

#pragma mark - 
#pragma mark register  withMobile
-(void)registerWithMobileNumber:(NSString *)mobileNumber;
-(void)registerWithMobileNumberCheckSmsCode:(NSString *)regsms;

#pragma mark - 
#pragma mark registerWithMailAccount
-(void)registerWithMailAccount:(NSString *)mailAccount ;
-(void)loginAndRegisterSetName:(NSString *)userName andNickName:(NSString *)nickName;

#pragma mark - 
#pragma mark  picVerify
-(void)requestpicVerifyImage;
-(void)checkVerifyImageID:(NSString *)picCodeID andPicCodeContent:(NSString *)codeContent;

#pragma mark - bind mobile with email
-(void)getVerifyCodeForBindMobile:(NSString *)mobileNo andUserId:(NSNumber *)userId;
-(void)verifyBindRequestWithMobile:(NSString *)mobileNo andUserId:(NSNumber *)userId andSMSCode:(NSString *)code;
-(void)bindMobileSuccessUpdateContact;
@end
