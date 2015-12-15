//
//  TDJSONRequestOperation.m
//  Tudou
//
//  Created by Li Chao on 13-3-8.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDJSONRequestOperation.h"
#import "JSONKit.h"

static dispatch_queue_t af_pk_request_operation_processing_queue;
static dispatch_queue_t pk_request_operation_processing_queue() {
    if (af_pk_request_operation_processing_queue == NULL) {
        af_pk_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.pk-request.processing", 0);
    }
    
    return af_pk_request_operation_processing_queue;
}

@interface TDJSONRequestOperation ()
@property (readwrite, nonatomic, strong) id responseJSON;
@property (readwrite, nonatomic, strong) NSError *JSONError;
@end

@implementation TDJSONRequestOperation
@synthesize targetIdentifier = _targetIdentifier;
@synthesize responseJSON = _responseJSON;
@synthesize JSONError = _JSONError;

//- (void)dealloc {
//    [_targetIdentifier release];
//    [_responseJSON release];
//    [_JSONError release];
//    [super dealloc];
//}

+ (TDJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    TDJSONRequestOperation *requestOperation = [[TDJSONRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/gif",@"application/json",@"text/html",nil];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(TDJSONRequestOperation *)operation responseJSON]);
        }
    }];
    
    return requestOperation;
}


- (id)responseJSON {
    if (!_responseJSON && [self.responseData length] > 0 && [self isFinished] && !self.JSONError) {
        NSError *error = nil;
        
        if ([self.responseData length] == 0) {
            self.responseJSON = nil;
        } else {
            //self.responseJSON = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
            self.responseJSON = [self.responseData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&error];
        }
        
        self.JSONError = error;
    }
    
    return _responseJSON;
}
//
//- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-retain-cycles"
//    self.completionBlock = ^ {
//        if ([self isCancelled]) {
//            /*
//            //被cancel的请求也需要回调
//            NSError *error = [NSError errorWithDomain:AFNetworkingErrorDomain code:PKRequestErrorTypeCancelled userInfo:nil];
//            dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
//                failure(self, error);
//            });
//             */
//            return;
//        }
//        
//        if (self.error) {
//            if (failure) {
//                dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
//                    failure(self, self.error);
//                });
//            }
//        } else {
//            dispatch_async(pk_request_operation_processing_queue(), ^{
//                id JSON = self.responseJSON;
//                
//                if (self.JSONError) {
//                    if (failure) {
//                        dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
//                            failure(self, self.error);
//                        });
//                    }
//                } else {
//                    if (success) {
//                        dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
//                            success(self, JSON);
//                        });
//                    }
//                }
//            });
//        }
//    };
//#pragma clang diagnostic pop
//}

@end
