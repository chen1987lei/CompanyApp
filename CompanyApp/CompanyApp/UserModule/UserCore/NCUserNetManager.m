//
//  NCUserNetManager.m
//  CompanyApp
//
//  Created by chenlei on 15/12/9.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCUserNetManager.h"
#import "NCUserConfig.h"

#define regurl  @"http://anquan.weilomo.com/Api/User/reg.html"
#define loginurl  @"http://anquan.weilomo.com/Api/User/reg.html"
@implementation NCUserNetManager

-(id)init
{
    self = [super init];
    if (self) {
        
        self.requestManager = [[AFHTTPRequestOperationManager alloc] init];
        [self.requestManager.requestSerializer setValue:[[UIDevice currentDevice] defaultUserAgent] forHTTPHeaderField:@"User-Agent"];
        self.requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/x-mpegurl",@"application/vnd.apple.mpegurl",@"application/json", nil];
        [self.requestManager.operationQueue setMaxConcurrentOperationCount:3];
        
    }
    return self;
}

-(void)dealloc
{
    self.requestManager = nil;
}

- (void)cancelAllOperation {
    [self.requestManager.operationQueue cancelAllOperations];
}


-(void)registerWithMailAccount:(NCUserConfig *)user
{
//    NSString *account = nil;
//    NSString *password = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:regurl];
    request.timeoutInterval = 10;
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleLoginCompletionWithResponse:operation.response];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleLoginError:error  response:operation.response];
        
    }];
    
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
    
}


-(void)registerWithUser:(NCUserConfig *)user;
{
    
}

-(void)loginWithMailAccount:(NSString *)mailAccount andPassword:(NSString *)password
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginurl];
    request.timeoutInterval = 10;
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleLoginCompletionWithResponse:operation.response];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleLoginError:error  response:operation.response];
        
    }];
    
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
    
}


- (void)handleLoginCompletionWithResponse:(NSHTTPURLResponse *)response
{
    
}

- (void)handleLoginError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    
}

@end
