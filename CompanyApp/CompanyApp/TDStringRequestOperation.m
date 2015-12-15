//
//  TDStringRequestOperation.m
//
//  Created by Li Chao on 13-3-8.
//
//

#import "TDStringRequestOperation.h"

@interface TDStringRequestOperation ()
@end

@implementation TDStringRequestOperation
@synthesize targetIdentifier = _targetIdentifier;

//- (void)dealloc {
//    [_targetIdentifier release];
//    [super dealloc];
//}

+ (TDStringRequestOperation *)StringRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSString *string))success
                                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    TDStringRequestOperation *requestOperation = [[TDStringRequestOperation alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            success(operation.request, operation.response, responseString);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];
    
    return requestOperation;
}

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
//            if (success) {
//                dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
//                    success(self, self.responseString);
//                });
//            }
//        }
//    };
//#pragma clang diagnostic pop
//}

@end
