//
//  NCUserNetManager.h
//  CompanyApp
//
//  Created by chenlei on 15/12/9.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>
@interface NCUserNetManager : NSObject
{
    
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
-(void)loginWithMailAccount:(NSString *)mailAccount andPassword:(NSString *)password;
@end
