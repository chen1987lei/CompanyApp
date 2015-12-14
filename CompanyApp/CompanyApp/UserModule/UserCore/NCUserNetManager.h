//
//  NCUserNetManager.h
//  CompanyApp
//
//  Created by chenlei on 15/12/9.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

#import "NCUserConfig.h"

@interface NCUserNetManager : NSObject
{
    
}

+(NCUserNetManager *)sharedInstance;

//获取验证码
-(void)getValidateCodeWithPhone:(NSString *)phoneNumber toRegister:(BOOL)isRegister
                   withComplate:(void (^)(NSDictionary *result
                                          , NSError *error))completeBlock;
//注册的
-(void)registerWithUser:(NCUserConfig *)user withComplate:(void (^)( NSDictionary *result, NSError *error))completeBlock;

//登录
-(void)loginWithAccount:(NSString *)account andPassword:(NSString *)password  withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;

//找回密码
-(void)recoveryWithAccount:(NSString *)account andPassword:(NSString *)password secondPassword:(NSString *)secondpwd andValidateCode:(NSString *)validatecode  withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


/// 修改密码
-(void)modifyAccountPwd:(NSString *)password newPwd:(NSString *)newpwd secondPassword:(NSString *)secondpwd   withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


@end
