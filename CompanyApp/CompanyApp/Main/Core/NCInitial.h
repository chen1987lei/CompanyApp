//
//  NCInitial.h
//  CompanyApp
//
//  Created by chenlei on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NCBaseModel : NSObject
{
    
}

@property(nonatomic,strong) NSString *modelId;
@property(nonatomic,strong) NSString *modelName;
@property(nonatomic,strong) NSString *modelSubTitle;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSNumber *topValue;
@property(nonatomic,strong) NSArray *childSectionData;
@end


@interface NCInitial : NSObject
{
    
}

@property(nonatomic,strong) NCBaseModel *indexData;
@property(nonatomic,strong) NCBaseModel *certificate_searchData;

@property(nonatomic,strong) NCBaseModel *collectionData;
@property(nonatomic,strong) NCBaseModel *indexSearchData;
@property(nonatomic,strong) NCBaseModel *organization_searchData;
@property(nonatomic,strong) NCBaseModel *practiceData;

@property(nonatomic,strong) NCBaseModel *reg_certificateData;
@property(nonatomic,strong) NCBaseModel *resume_certificateData;
@property(nonatomic,strong) NCBaseModel *signup_cateData;
@property(nonatomic,strong) NCBaseModel *talents_cateData;


+(NCInitial *)sharedInstance;

+(NSDictionary *)getBaseParams;
-(void)initialWithComplate:(void (^)(BOOL succeed, NSError *error))completeBlock;
-(void)requestInitialDataWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestHomeBannerWithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;

-(void)requestCategoryData:(NSString *)cagID
WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestNewsListData:(NSString *)cagID withPageFrom:(NSInteger)startpage
withOnePageCount:(NSInteger)onepageCount
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestServerMessageData:(NSInteger )page withPageNumber:(NSInteger)pagenum
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
-(void)requestMessageContentData:(NSString *)msgid
                    WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;


-(void)requestServerTestData:(NSInteger )page withPageNumber:(NSInteger)pagenum
                   WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
-(void)requestServerTestContent:(NSString *)msgid
                    WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;

-(void)requestCorpListData:(NSString *)area page:(NSInteger )page withPageNumber:(NSInteger)pagenum
                WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
-(void)requestCorpInfo:(NSString *)corpId
                   WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;

-(void)requestQuestionListData:(NSString *)cagID
          WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
@end
