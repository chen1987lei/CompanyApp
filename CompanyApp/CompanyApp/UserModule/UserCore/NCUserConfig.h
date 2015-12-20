//
//  NCUserConfig.h
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NCUserConfig : NSObject
{
    
}

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSNumber *sexValue;
@property(nonatomic, copy) NSString *certCard;
@property(nonatomic, copy) NSString *mobilenumber;
@property(nonatomic, copy) NSString *validatecode;
@property(nonatomic, copy) NSString *tmppasswd;
@property(nonatomic, copy) NSString *secondpwd;
@property(nonatomic, copy) NSString *photourl;

@property(nonatomic, copy) NSString *invitecode;

@property(nonatomic, copy) NSString *addv;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *uuid;



@property(nonatomic, copy) NSString *security;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *book;
@property(nonatomic, copy) NSString *degree;
@property(nonatomic, copy) NSString *etime;

@property(nonatomic, copy) NSString *professional;
@property(nonatomic, copy) NSString *salary;

@property(nonatomic, copy) NSString *work;
@property(nonatomic, copy) NSString *training;

@property(nonatomic, copy) NSString *area;

@property(nonatomic, assign) BOOL open;
@property(nonatomic, assign) BOOL status;



+(BOOL)haslogin;
+(NCUserConfig *)sharedInstance;


-(void)saveUserData;
@end
