//
//  NCInitial.h
//  CompanyApp
//
//  Created by chenlei on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCInitial : NSObject
{
    
}


+(NCInitial *)sharedInstance;

+(NSDictionary *)getBaseParams;
-(void)initial;
-(void)requestInitialDataWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestHomeBannerWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;

-(void)requestCategoryData:(NSString *)cagID
WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestNewsListData:(NSString *)cagID withPageFrom:(NSInteger)startpage
withOnePageCount:(NSInteger)onepageCount
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestServerMessageData:(NSInteger )page withPageNumber:(NSInteger)pagenum
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


@end
