//
//  NCInitial.m
//  CompanyApp
//
//  Created by chenlei on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCInitial.h"
#import <AFNetworking.h>
#import "NCUserConfig.h"

#define kInitialURL @"http://anquan.weilomo.com/Api/Index/init.html"
#define kHomeBannerURL @"http://anquan.weilomo.com/Api/Slide/list.html"
#define kCategoryURL @"http://anquan.weilomo.com/Api/Class/list.html"
#define kNewsListURL @"http://anquan.weilomo.com/Api/News/list.html"

#define kNewsListURL @"http://anquan.weilomo.com/Api/News/list.html"

#define kNewsContentURL @"http://anquan.weilomo.com/Api/News/content.html"






@interface NCInitial()
{
    
}
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@end

@implementation NCInitial

+(NCInitial *)sharedInstance{
    static NCInitial *analytics = nil;
    if (analytics == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            analytics = [[NCInitial alloc] init];
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

+(NSDictionary *)getBaseParams
{
    NSDictionary *dict = @{@"apiversion":@"1.0",@"safecode":@"apisafecode"};
    return dict;
}

-(void)initial
{
    WS(weakself);
    
    [[NCInitial sharedInstance] requestInitialDataWithComplate:^(NSDictionary *dict, NSError *error) {
        if (dict) {
            NSInteger code = [dict[@"code"] integerValue];
            if (code == 200) {
                NSDictionary *res = dict[@"res"];
                
                NSDictionary *signup_cate = res[@"signup_cate"];
                
                NSDictionary *collection_cate = res[@"collection_cate"];
                
                NSDictionary *talents_cate = res[@"talents_cate"];
                


                NSDictionary *index_cate = res[@"index_cate"];
                 NSDictionary *index_search_cate = res[@"index_search_cate"];
                
                NSDictionary *certificate_search_cate = res[@"certificate_search_cate"];
              
                NSDictionary *organization_search_cate = res[@"organization_search_cate"];
                
                NSDictionary *reg_certificate = res[@"reg_certificate"];
                
                
                
                NSDictionary *resume_certificate = res[@"resume_certificate"];
                
                NSDictionary *practice_cate = res[@"practice_cate"];
                
                
                
            }
        }
    }];
    
//    weakself
    
}




-(void)requestInitialDataWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock
{
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kInitialURL
                                                                               parameters:params error:nil];
    
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
//                   [NSURL URLWithString: kInitialURL ]];
    
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



-(void)requestHomeBannerWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kHomeBannerURL
                                                                                 parameters:params error:nil];
    
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
    //                   [NSURL URLWithString: kInitialURL ]];
    
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

-(void)requestCategoryData:(NSString *)cagID
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    
        [params addEntriesFromDictionary: [NCInitial getBaseParams]];
        
        
        NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kCategoryURL
                                                                                     parameters:params error:nil];
        
        
        //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
        //                   [NSURL URLWithString: kInitialURL ]];
        
        request.timeoutInterval = 10;
        
        WS(weakself)
        __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            {"code":200,"res":[{"id":"12","name":"个人证书查询","fid":"7","top":"99"},{"id":"13","name":"认证机构查询","fid":"7","top":"99"}]}
            
            
            NSDictionary *dict = [operation.responseData objectFromJSONData];
            
            completeBlock(dict, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completeBlock(nil, error);
            
        }];
        
        [operation setQueuePriority:NSOperationQueuePriorityLow];
        [self.requestManager.operationQueue addOperation:operation];
    }


-(void)requestNewsListData:(NSString *)cagID withPageFrom:(NSInteger)startpage
          withOnePageCount:(NSInteger)onepageCount
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:cagID forKey:@"cid"];
    
    [params setObject:[NSNumber numberWithInteger:startpage] forKey:@"page"];
    
    [params setObject:[NSNumber numberWithInteger:onepageCount] forKey:@"pagenum"];
    
    
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kNewsListURL
                                                                                 parameters:params error:nil];
    
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
    //                   [NSURL URLWithString: kInitialURL ]];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //            {"code":200,"res":[{"id":"12","name":"个人证书查询","fid":"7","top":"99"},{"id":"13","name":"认证机构查询","fid":"7","top":"99"}]}
        
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}


-(void)requestNewsContentData:(NSString *)newsID
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:newsID forKey:@"id"];

    
    [params setObject:@"1" forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kNewsContentURL
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//{"code":200,"res":[{"id":"4","title":" 以下信息根据您的兴趣推荐 山东东营村民用塑料袋灌天然气带回家","summary":" 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n山东东营村民用塑料袋灌天然气带回家 以下信息根据您的兴趣推荐 \r\n","time":"2015-12-07","img":"http://anquan.weilomo.com/Uploads/2015/1214/thumb/154x154/566e983918e4a.jpg"},{"id":"1","title":"安全局安全局安全局","summary":"安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局安全局 ","time":"2015-12-01","img":"http://anquan.weilomo.com/Uploads/2015/1214/thumb/154x154/566e97135ff00.jpg"}]}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}

@end
