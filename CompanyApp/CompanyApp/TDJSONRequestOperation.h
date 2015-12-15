//
//  TDJSONRequestOperation.h
//  Tudou
//
//  Created by Li Chao  on 13-3-8.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>

@interface TDJSONRequestOperation : AFHTTPRequestOperation
@property (nonatomic, strong) NSString *targetIdentifier;    //唯一标示符
@property (nonatomic, strong, readonly) id responseJSON;

+ (TDJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
