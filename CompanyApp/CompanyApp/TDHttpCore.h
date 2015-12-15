//
//  TDHttpCore.h
//  Tudou
//  http请求核心类
//  Created by CL7RNEC on 15/3/2.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFMultipartFormData;

typedef NS_ENUM(NSInteger, TDHttpRequestErrorType)
{
    TDHttpRequestErrorTypeNotConnection,   //0     无网络连接
    TDHttpRequestErrorTypeCancelled,        //1     被取消
    TDHttpRequestErrorTypeBadRequest,       //400   请求失败（后台将客户端错误封装成400状态吗返回,比如用户名密码错误，参数错误等）
    TDHttpRequestErrorTypeAuthentication,   //401   认证、授权失效（cookie错误等）
    TDHttpRequestErrorTypeForbidden,        //403   客户端被禁止访问
    TDHttpRequestErrorTypeNotFound,         //404   URL错误或者URL不存在
    TDHttpRequestErrorTypeTimedOut,         //408   请求超时
    TDHttpRequestErrorTypeSecretTimedOut,   //410   防盗链的时间超时，需要校准时间
    TDHttpRequestErrorTypeServerError,      //500+  服务器端错误
    TDHttpRequestErrorTypeServerOK,         //200   服务器返回正确
    TDHttpRequestErrorTypeUnknow            //未知错误
};

typedef void(^TDHttpSuccessByDictionary)(NSDictionary *result,NSURLRequest *request, NSHTTPURLResponse *response);

typedef void(^TDHttpSuccessByString)(NSString *result,NSURLRequest *request, NSHTTPURLResponse *response);

typedef void(^TDHttpSuccessByXML)(NSURLRequest *request, NSHTTPURLResponse *response, NSData *responseData);

typedef void(^TDHttpError) (NSError *error);

typedef void(^TDConstructBodyBlock)(id <AFMultipartFormData> formData);


@interface TDHttpCore : NSObject
/**
 *  单例
 *
 *  @return
 */
+(TDHttpCore *)sharedInstance;
/**
 *  绑定基础参数
 *
 *  @param param 参数
 *
 *  @return 绑定后参数
 */
-(NSDictionary *)combineParams:(NSDictionary *)param;
/**
 *  GET请求，默认返回结果是字典，捆绑基础参数
 *
 *  @param url     请求地址
 *  @param target  目标
 *  @param params  参数
 *  @param success 成功块
 *  @param failure 失败块
 */
-(void)getRequestWithPath:(NSString *)url
                   target:(id)target
                   params:(NSDictionary *)params
                  success:(TDHttpSuccessByDictionary)success
                  failure:(TDHttpError)failure;
/**
 *  GET请求，默认捆绑基础参数
 *
 *  @param url     请求地址
 *  @param target  目标
 *  @param params  参数
 *  @param success 成功块，返回结果是字符
 *  @param failure 失败块
 */
-(void)getRequestByStringWithPath:(NSString *)url
                           target:(id)target
                           params:(NSDictionary *)params
                          success:(TDHttpSuccessByString)success
                          failure:(TDHttpError)failure;
/**
 *  GET请求，默认返回结果是字典
 *
 *  @param url        请求地址
 *  @param target     目标
 *  @param params     参数
 *  @param cookie     cookie
 *  @param isExternal 1外部请求，0内部请求，外部请求不捆绑基础参数
 *  @param success 成功块
 *  @param failure 失败块
 */
-(void)getRequestWithPath:(NSString *)url
                   target:(id)target
                   params:(NSDictionary *)params
                   cookie:(NSString *)cookie
               isExternal:(BOOL)isExternal
                  success:(TDHttpSuccessByDictionary)success
                  failure:(TDHttpError)failure;
/**
 *  GET请求，默认返回结果是字典，捆绑基础参数
 *
 *  @param url          请求地址
 *  @param target       目标
 *  @param params       参数
 *  @param timeout      超时时间
 *  @param isExternals  1外部请求，0内部请求，外部请求不捆绑基础参数
 *  @param success      成功块
 *  @param failure      失败块
 */
-(void)getRequestWithPath:(NSString *)url
                   target:(id)target
                   params:(NSDictionary *)params
                  timeout:(NSInteger)timeout
               isExternal:(BOOL)isExternal
                  success:(TDHttpSuccessByDictionary)success
                  failure:(TDHttpError)failure;
/**
 *  POST请求
 *
 *  @param url     请求地址
 *  @param target  目标
 *  @param params  参数
 *  @param success 成功块
 *  @param failure 失败块
 */
-(void)postRequestWithPath:(NSString *)url
                    target:(id)target
                    params:(NSDictionary *)params
                   success:(TDHttpSuccessByDictionary)success
                   failure:(TDHttpError)failure;

-(void)postRequestWithPath:(NSString *)url
                    target:(id)target
                    params:(NSDictionary *)params
 constructingBodyWithBlock:(TDConstructBodyBlock)constructBlock
                   success:(TDHttpSuccessByDictionary)success
                   failure:(TDHttpError)failure;
/**
 *  XML请求
 *
 *  @param url     请求地址
 *  @param target  目标
 *  @param md5     文件md5校验码，下载完毕校验用
 *  @param success 成功块
 *  @param failure 失败块
 */
-(void)xmlRequestWithPath:(NSString *)url
                    target:(id)target
                 md5digit:(NSString*)md5
                   success:(TDHttpSuccessByXML)success
                   failure:(TDHttpError)failure;

/**
 *  取消所有请求
 */
- (void)cancelAllOperations;
/**
 *  取消指定的请求
 *
 *  @param target 目标
 */
- (void)cancelOperationByTarget:(id)target;

@end
