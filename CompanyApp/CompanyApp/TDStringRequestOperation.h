//
//  TDStringRequestOperation.h
//
//  Created by Li Chao on 13-3-8.
//
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>

@interface TDStringRequestOperation : AFHTTPRequestOperation
@property (nonatomic, strong) NSString *targetIdentifier;    //唯一标示符

+ (TDStringRequestOperation *)StringRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSString *string))success
                                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
