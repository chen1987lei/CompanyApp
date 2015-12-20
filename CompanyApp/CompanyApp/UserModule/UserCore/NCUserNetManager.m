//
//  NCUserNetManager.m
//  CompanyApp
//
//  Created by chenlei on 15/12/9.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCUserNetManager.h"
#import "NCUserConfig.h"
#import "NCInitial.h"

#define regcodeurl  @"http://anquan.weilomo.com/Api/User/send.html"
#define regurl  @"http://anquan.weilomo.com/Api/User/reg.html"
#define loginurl  @"http://anquan.weilomo.com/Api/User/login.html"

#define recoveryurl  @"http://anquan.weilomo.com/Api/User/pwd.html"

#define userinfourl  @"http://anquan.weilomo.com/Api/User/info.html"

#define newpwdurl  @"http://anquan.weilomo.com/Api/User/newspwd.html"
#define kUserNewNameUrl  @"http://anquan.weilomo.com/Api/User/name.html"
#define kUserNewSexURL  @"http://anquan.weilomo.com/Api/User/sex.html"

#define kUserFavoriteURL  @"http://anquan.weilomo.com/Api/News/favorite.html"

@interface NCUserNetManager()
{
    
}
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@end

@implementation NCUserNetManager

+(NCUserNetManager *)sharedInstance{
    static NCUserNetManager *analytics = nil;
    if (analytics == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            analytics = [[NCUserNetManager alloc] init];
        });
    }
    
    return analytics;
}



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

-(void)getValidateCodeWithPhone:(NSString *)phoneNumber toRegister:(BOOL)isRegister
withComplate:(void (^)(NSDictionary *result
                                                     , NSError *error))completeBlock;
{
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"tel"];
    
    NSString *codetype = @"1";
    if (isRegister) {
       codetype = @"1";
    }
    else
    {
        codetype = @"2";
    }
    
    [params setObject:codetype forKey:@"type"]; //1 注册 2 找回密码
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:regcodeurl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
    
}

-(void)registerWithUser:(NCUserConfig *)user withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock
{
//    {"code":200,"res":{"uid":"6","uuid":"d6670616bebb04b770124f55d345aad4"}}
    
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:user.userName forKey:@"name"];
    [params setObject:user.sexValue forKey:@"sex"]; //1 注册
    [params setObject:user.certCard forKey:@"card"]; //1 注册
    [params setObject:user.mobilenumber forKey:@"tel"]; //1 注册
    
    [params setObject:user.validatecode forKey:@"code"]; //1 注册
    
    [params setObject:user.tmppasswd forKey:@"pwd"]; //1 注册
    [params setObject:user.secondpwd forKey:@"pwd2"]; //1 注册
    
    if (user.invitecode) {
        [params setObject:user.invitecode forKey:@"codes"]; //1 注册
    }
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:regurl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;

    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}


-(void)loginWithAccount:(NSString *)account andPassword:(NSString *)password  withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
//    {"code":200,"res":{"uid":"6","uuid":"d6670616bebb04b770124f55d345aad4"}}
    
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:account forKey:@"tel"];
    [params setObject:password forKey:@"pwd"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:loginurl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        {"code":200,"res":{"uid":"6","uuid":"d6670616bebb04b770124f55d345aad4"}}/
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}

-(void)recoveryWithAccount:(NSString *)account andPassword:(NSString *)password secondPassword:(NSString *)secondpwd andValidateCode:(NSString *)validatecode  withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    //    {"code":200,"res":{"uid":"6","uuid":"d6670616bebb04b770124f55d345aad4"}}
    
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:account forKey:@"tel"];
    [params setObject:validatecode forKey:@"code"];
    [params setObject:password forKey:@"pwd"];
    [params setObject:secondpwd forKey:@"pwd2"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:recoveryurl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        {"code":200,"res":{"uid":"6","uuid":"d6670616bebb04b770124f55d345aad4"}}/
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];}


-(void)requestUserInfoWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    if(![NCUserConfig haslogin])
    {
        completeBlock(nil,nil);
        return;
    }
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:userinfourl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//{"code":200,"res":{"id":"1","name":"路浩","sex":"1","card":"123456789123456789123","phone":"18669482003","img":"http://anquan.io/Uploads2015/1213/thumb/90x90/t_200x200_566cea1e0dd4d.jpg","addv":"0","code":"100001"}}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        NSInteger retcode = [dict[@"code"] integerValue];
        if (retcode == 200) {
            NSDictionary *resdata = dict[@"res"];
            
            NCUserConfig *user = [NCUserConfig sharedInstance] ;
            user.userName =resdata[@"name"];
             user.sexValue =resdata[@"sex"];
            user.certCard =resdata[@"card"];
            user.mobilenumber =resdata[@"phone"];
            user.photourl =resdata[@"img"];
            
            user.addv =resdata[@"addv"];
            user.invitecode =resdata[@"code"];
        }
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}


-(void)doUserFavoriteAction:(NSString *)nid andCategory:(NSString *)category  WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    if(![NCUserConfig haslogin])
    {
        completeBlock(nil,nil);
        return;
    }
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
 
    [params setObject:nid forKey:@"nid"];
    [params setObject:category forKey:@"class"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kUserFavoriteURL
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //{"code":200,"res":{"id":"1","name":"路浩","sex":"1","card":"123456789123456789123","phone":"18669482003","img":"http://anquan.io/Uploads2015/1213/thumb/90x90/t_200x200_566cea1e0dd4d.jpg","addv":"0","code":"100001"}}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        NSInteger retcode = [dict[@"code"] integerValue];
        if (retcode == 200) {
          
            //收藏成功
        }
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}



-(void)modifyAccountPwd:(NSString *)password newPwd:(NSString *)newpwd secondPassword:(NSString *)secondpwd   withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    
    [params setObject:password forKey:@"oldpwd"];
    [params setObject:newpwd forKey:@"pwd"];
    [params setObject:secondpwd forKey:@"pwd2"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:newpwdurl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}


-(void)modifyAccountName:(NSString *)newname withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    
    [params setObject:newname forKey:@"name"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kUserNewNameUrl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}


-(void)modifyAccountSex:(NSString *)sexstr   withComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    
    [params setObject:sexstr forKey:@"sex"];
    
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kUserNewSexURL
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}



@end
