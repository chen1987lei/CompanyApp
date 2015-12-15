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

@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSNumber *sexValue;
@property(nonatomic, strong) NSString *certCard;
@property(nonatomic, strong) NSString *mobilenumber;
@property(nonatomic, strong) NSString *validatecode;
@property(nonatomic, strong) NSString *tmppasswd;
@property(nonatomic, strong) NSString *secondpwd;

@property(nonatomic, strong) NSString *invitecode;


@property(nonatomic, strong) NSString *uuid;



+(NCUserConfig *)sharedInstance;


-(void)saveUserData;
@end
