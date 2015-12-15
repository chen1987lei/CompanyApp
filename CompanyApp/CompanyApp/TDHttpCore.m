//
//  TDHttpCore.m
//  Tudou
//
//  Created by CL7RNEC on 15/3/2.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDHttpCore.h"
#import <AFNetworkActivityIndicatorManager.h>

//#import "TDStringRequestOperation.h"
//#import "TDJSONRequestOperation.h"
//#import "TDXMLRequestOperation.h"
#import <AFNetworking.h>

static const NSInteger kMaxCount = 3;   //最大并发数
static const NSInteger kTimeout = 20;   //超时时间
NSString *const kYktkCookiePath = @"yktkCookiePath";
NSString *const kYktkCookie = @"yktkCookie";

NSString * const TDNetworkingErrorDomain = @"TDNetworkingErrorDomain";

@interface TDHttpCore()

@property (nonatomic, retain) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, assign) NSInteger timeout;

@end

@implementation TDHttpCore
#pragma mark - Life cycle
+ (TDHttpCore *)sharedInstance
{
    static TDHttpCore *httpCore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpCore = [[TDHttpCore alloc] init];
    });
    return httpCore;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        self.requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        //最大并发数：3
        [self.requestManager.operationQueue setMaxConcurrentOperationCount:kMaxCount];
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"image/gif",nil];
        [self.requestManager.requestSerializer setValue:[[UIDevice currentDevice] defaultUserAgent] forHTTPHeaderField:@"User-Agent" ];
    }
    return self;
}

- (void)dealloc
{
    _requestManager = nil;
}
#pragma mark - request
-(void)getRequestWithPath:(NSString *)url
                   target:(id)target
                   params:(NSDictionary *)params
                  success:(TDHttpSuccessByDictionary)success
                  failure:(TDHttpError)failure{
    [self getRequestWithPath:url target:target params:params cookie:nil isExternal:NO success:success failure:failure];
}
-(void)getRequestByStringWithPath:(NSString *)url
                           target:(id)target
                           params:(NSDictionary *)params
                          success:(TDHttpSuccessByString)success
                          failure:(TDHttpError)failure{
 /*
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:[self combineParams:params] error:nil];
    request.timeoutInterval = self.timeout;
    __weak typeof(self) wSelf=self;
    TDStringRequestOperation *operation = [TDStringRequestOperation StringRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSString *string) {
        if (success) {
            success(string,request,response);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"\n[getRequestByStringWithPath]url: %@statusCode: %ld", request.URL, (long)response.statusCode);
        NSInteger requestErrorType = [wSelf erroeTypeFromStatusCode:response.statusCode];
        NSError *aError = [NSError errorWithDomain:TDNetworkingErrorDomain code:requestErrorType userInfo:nil];
        if (requestErrorType == TDHttpRequestErrorTypeSecretTimedOut) {
            [wSelf handleSecretTimeOut:response];
        }
        if (failure) {
            failure(aError);
        }
    } ];
    [operation setTargetIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)[target hash]]];
    [self.requestManager.operationQueue addOperation:operation];
  */
}

-(void)getRequestWithPath:(NSString *)url
                   target:(id)target
                   params:(NSDictionary *)params
                   cookie:(NSString *)cookie
               isExternal:(BOOL)isExternal
                  success:(TDHttpSuccessByDictionary)success
                  failure:(TDHttpError)failure{
    //如果isExternal=YES不需要绑定基础参数
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:isExternal?params:[self combineParams:params] error:nil];
    request.timeoutInterval = self.timeout;
    if (cookie&&[cookie isNotBlankString]) {
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    [self httpRequest:request target:self success:success failure:failure];
}
-(void)getRequestWithPath:(NSString *)url
                   target:(id)target
                   params:(NSDictionary *)params
                  timeout:(NSInteger)timeout
               isExternal:(BOOL)isExternal
                  success:(TDHttpSuccessByDictionary)success
                  failure:(TDHttpError)failure{
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:isExternal?params:[self combineParams:params] error:nil];
    request.timeoutInterval = timeout;
    [self httpRequest:request target:self success:success failure:failure];
}

-(void)postRequestWithPath:(NSString *)url
                    target:(id)target
                    params:(NSDictionary *)params
                   success:(TDHttpSuccessByDictionary)success
                   failure:(TDHttpError)failure{
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST"
                                                                 URLString:url
                                                           parameters:[self combineParams:params] error:nil];
    request.timeoutInterval = self.timeout;
    [self httpRequest:request target:self success:success failure:failure];
}

-(void)postRequestWithPath:(NSString *)url
                    target:(id)target
                    params:(NSDictionary *)params
 constructingBodyWithBlock:(TDConstructBodyBlock)constructBlock
                   success:(TDHttpSuccessByDictionary)success
                   failure:(TDHttpError)failure{
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:url
                                    parameters:[self combineParams:params]
                                    constructingBodyWithBlock:constructBlock
                                    error:nil];
    
    request.timeoutInterval = self.timeout;
    [self httpRequest:request target:self success:success failure:failure];
}

- (void)httpRequest:(NSMutableURLRequest *)request
             target:(id)target
            success:(TDHttpSuccessByDictionary)success
            failure:(TDHttpError)failure{
    
    __weak typeof(self) wSelf=self;
    TDJSONRequestOperation *operation = [TDJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        if (success) {
            DLog(@"\n[getRequestWithPath-success]url: %@ statusCode: %ld", request.URL, (long)response.statusCode);
            if ([json isKindOfClass:[NSDictionary class]]) {
                success(json,request,response);
            } else {
                success(nil,request,response);
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        DLog(@"\n[getRequestWithPath-error]url: %@ statusCode: %ld", request.URL, (long)response.statusCode);
        NSInteger requestErrorType = [wSelf erroeTypeFromStatusCode:response.statusCode];
        if ([json isKindOfClass:[NSDictionary class]]) {
            //status=failed, code=400, desc=login first
            if ([json[@"code"] integerValue] == 400) {
                requestErrorType = TDHttpRequestErrorTypeAuthentication;
            }
        }
        NSError *aError = [NSError errorWithDomain:TDNetworkingErrorDomain code:requestErrorType userInfo:json];
        if (requestErrorType == TDHttpRequestErrorTypeSecretTimedOut) {
            [wSelf handleSecretTimeOut:response];
        }
        if (failure) {
            failure(aError);
        }
    }];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [operation setTargetIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)[target hash]]];
    [self.requestManager.operationQueue addOperation:operation];
}

-(void)xmlRequestWithPath:(NSString *)url
                   target:(id)target
                 md5digit:(NSString*)md5
                  success:(TDHttpSuccessByXML)success
                  failure:(TDHttpError)failure
{
    /*
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    TDXMLRequestOperation *operation =
    [TDXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *resonseData) {
        success(request,response,resonseData);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [operation setMd5Digit:md5];
    [operation setTargetIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)[target hash]]];
    [self.requestManager.operationQueue addOperation:operation];
    */
}

#pragma mark - cancel
- (void)cancelAllOperations
{
    [self.requestManager.operationQueue cancelAllOperations];
    while ([[AFNetworkActivityIndicatorManager sharedManager] isNetworkActivityIndicatorVisible]) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    }
}

- (void)cancelOperationByTarget:(id)target
{
    for (AFHTTPRequestOperation *operation in self.requestManager.operationQueue.operations) {
        if ([operation isKindOfClass:[TDJSONRequestOperation class]]) {
            if ([[(TDJSONRequestOperation *)operation targetIdentifier] integerValue] == [target hash]) {
                [operation cancel];
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            }
        }
        else if ([operation isKindOfClass:[TDStringRequestOperation class]]) {
            if ([[(TDStringRequestOperation *)operation targetIdentifier] integerValue] == [target hash]) {
                [operation cancel];
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            }
        }
    }
}
#pragma mark - tools
-(NSDictionary *)combineParams:(NSDictionary *)param{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:[TDConfig sharedInstance].pid forKey:@"pid"];
    [params setObject:[TDConfig sharedInstance].guid forKey:@"guid"];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *version = [userDefault objectForKey:@"version"];
    if (version) {
        [params setObject:version forKey:@"ver"];
    }
    NSString *network = [TDAPP currentReachabilityStatus] == ReachableViaWWAN ? @"WWAN" : @"WIFI";
    //解决某些时刻可能出现崩溃问题
    //[[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN ? @"WWAN" : @"WIFI";
    [params setObject:network forKey:@"network"]; //联网方式，必选参数。
    params[@"operator"] = [[UIDevice currentDevice] carrier]?[[UIDevice currentDevice] carrier]:@"";
    if ([YKIndentifier VendorUDID]) {
        [params setObject:[[YKIndentifier VendorUDID] copy] forKey:@"vdid"];
    }
    if ([YKIndentifier OpenUDID]) {
        [params setObject:[[YKIndentifier OpenUDID] copy] forKey:@"ouid"];
    }
    if ([[[UIDevice currentDevice] getIDFA] isNotBlankString]) {
        [params setObject:[[UIDevice currentDevice] getIDFA] forKey:@"idfa"];
    }
    return params;
}
/**
 *  请求错误码转换
 *
 *  @param statusCode 原始错误码
 *
 *  @return 转换后错误码
 */
- (TDHttpRequestErrorType)erroeTypeFromStatusCode:(NSInteger)statusCode
{
    switch (statusCode) {
        case 0: return TDHttpRequestErrorTypeNotConnection; break;
        case 1: return TDHttpRequestErrorTypeCancelled; break;
        case 204:
        case 200: return TDHttpRequestErrorTypeServerOK; break;
            //客户端错误
        case 400: return TDHttpRequestErrorTypeBadRequest; break;
        case 401: return TDHttpRequestErrorTypeAuthentication; break;
        case 403: return TDHttpRequestErrorTypeForbidden; break;
        case 404: return TDHttpRequestErrorTypeNotFound; break;
        case 408: return TDHttpRequestErrorTypeTimedOut; break;
        case 410: return TDHttpRequestErrorTypeSecretTimedOut; break;
            //服务器错误
        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
        case 505: return TDHttpRequestErrorTypeServerError; break;
        default: return TDHttpRequestErrorTypeUnknow; break;
    }
}
/**
 *  处理超时
 *
 *  @param response
 */
- (void)handleSecretTimeOut:(NSHTTPURLResponse *)response
{
    NSDictionary *dict = response.allHeaderFields;
    if (dict[@"server-time"]) {
        [TDConfig sharedInstance].serverTime = [dict[@"server-time"] integerValue];
    }
}
/**
 *  请求超时时间
 *  不包括上传视频,下载视频,上传图片,下载图片以及inital接口
 *  @return NSInteger
 */
- (NSInteger)timeout{
    TDConfig *config = [TDConfig sharedInstance];
    if (config.timeoutOnWifi != 0 && config.timeoutOnNonWifi != 0) {
        if (TDAPP.currentReachabilityStatus==ReachableViaWiFi) {
            return config.timeoutOnWifi;
        }else if(TDAPP.currentReachabilityStatus==ReachableViaWWAN){
            return config.timeoutOnNonWifi;
        }else{
            return kTimeout;
        }
    }
    return kTimeout;
}

@end
