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


#define kNewsContentURL @"http://anquan.weilomo.com/Api/News/content.html"



#define kMessageCenterURL @"http://anquan.weilomo.com/Api/Message/list.html"

#define kMessageContentURL @"http://anquan.weilomo.com/Api/Message/info.html"

#define kCorpListUrl @"http://anquan.weilomo.com/Api/Organ/list.html"
#define  kCorpInfoUrl @"http://anquan.weilomo.com/Api/Organ/info.html"


#define kTestListURL @"http://anquan.weilomo.com/Api/Test/list.html"


#define kResumeListURL @"http://anquan.weilomo.com/Api/Resume/list.html"


@implementation NCBaseModel

@end

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


-(NCBaseModel *)parseData:(id)mdData andParentModel:(NCBaseModel *)parent
{
    if([mdData isKindOfClass:[NSArray class]])
    {
        //只可能是childmodel
        NSArray *arr = (NSArray *)mdData;
        NSMutableArray *tmparr = [NSMutableArray new];
        for(NSDictionary *dict in arr)
        {
            NCBaseModel *mb = [[NCBaseModel alloc] init];
            mb.modelName = dict[@"name"];
            if(dict[@"id"])
                mb.modelId = dict[@"id"];
            if(dict[@"top"])
                mb.topValue = dict[@"top"];
            if(dict[@"content"])
                mb.content = dict[@"content"];
            if(dict[@"child"])
            {
                id tttt = dict[@"child"];
                if ([tttt isKindOfClass:[NSArray class]]) {
                    mb = [self parseData:tttt andParentModel:mb];
                }
            }
            
            [tmparr addObject:mb];
        }
        if (parent == nil) {
            parent =  [[NCBaseModel alloc] init];
        }
        parent.childSectionData = tmparr;
        return parent;
    }
    else if([mdData isKindOfClass:[NSDictionary class]])
    {
        if (parent == nil) {
            parent =  [[NCBaseModel alloc] init];
        }
        NSDictionary *dict = (NSDictionary *)mdData;
        parent.modelName =  dict[@"name"];
        if(dict[@"id"])
            parent.modelId = dict[@"id"];
        if(dict[@"top"])
            parent.topValue = dict[@"top"];
        if(dict[@"child"])
        {
            id child = dict[@"child"];
            if (child) {
                parent = [self parseData:child  andParentModel:parent];
            }
            else
            {
                NSLog(@"323");
            }
        }
        return parent;
    }
    else
    {
        return nil;
    }
                                     
}

-(void)initialWithComplate:(void (^)(BOOL succeed, NSError *error))completeBlock
{
    WS(weakself);
    
    [[NCInitial sharedInstance] requestInitialDataWithComplate:^(NSDictionary *dict, NSError *error) {
        if (dict) {
            NSInteger code = [dict[@"code"] integerValue];
            if (code == 200) {
                NSDictionary *res = dict[@"res"];
                
                
                //不同model
                NSDictionary *signup_cate = res[@"signup_cate"];
                NSDictionary *signcitycate = signup_cate[@"city_cate"];
                
                NCBaseModel *signData =  [[NCBaseModel alloc] init];
                signData.modelName = @"signup_cate";
                
                NSMutableArray *signchild = [NSMutableArray new];
                NCBaseModel *signCityData =  [[NCBaseModel alloc] init];
                signCityData.modelName = @"city_cate";
                NSMutableArray *tmparr = [NSMutableArray new];
                for (NSDictionary *tmpdict in signcitycate) {
 
                    NCBaseModel *child =  [[NCBaseModel alloc] init];
                    child.modelId = tmpdict[@"id"];
                    child.modelName = tmpdict[@"name"];
                    [tmparr addObject:child];
                }
                signCityData.childSectionData = tmparr;
                [signchild addObject:signCityData];
                
                NSDictionary *signindustrycate = signup_cate[@"industry_cate"];
                NCBaseModel *signIndustryData =  [[NCBaseModel alloc] init];
                signIndustryData.modelName = @"industry_cate";
                tmparr = [NSMutableArray new];
                for (NSDictionary *tmpdict in signindustrycate) {
                    
                    NCBaseModel *child =  [[NCBaseModel alloc] init];
                    child.modelId = tmpdict[@"id"];
                    child.modelName = tmpdict[@"name"];
                    [tmparr addObject:child];
                }
                signIndustryData.childSectionData = tmparr;
                [signchild addObject:signIndustryData];
                
                signData.childSectionData = tmparr;
                weakself.signup_cateData = signData;
                
                
                
                NSDictionary *collection_cate = res[@"collection_cate"];
                NCBaseModel *collectionModel =  [[NCBaseModel alloc] init];
                collectionModel.modelName = @"collection_cate";
                NSMutableArray *collectionchild = [NSMutableArray new];
                for (NSDictionary *tmpdict in collection_cate) {
                    
                    NCBaseModel *child =  [[NCBaseModel alloc] init];
                    child.modelId = tmpdict[@"id"];
                    child.modelName = tmpdict[@"name"];
                    [collectionchild addObject:child];
                }
                collectionModel.childSectionData = collectionchild;
                weakself.collectionData = collectionModel;
                
                
                
                NSDictionary *talents_cate = res[@"talents_cate"];
                NCBaseModel *talentModel =  [[NCBaseModel alloc] init];
                talentModel.modelName = @"talents_cate";
                NSMutableArray *talentchild = [NSMutableArray new];
                
                NSDictionary *talentsAge_cate = talents_cate[@"age_cate"];
                NCBaseModel *talentAgeModel =  [[NCBaseModel alloc] init];
                talentAgeModel.modelName = @"age_cate";
                tmparr = [NSMutableArray new];
                for (NSDictionary *tmpdict in talentsAge_cate) {
                    
                    NCBaseModel *child =  [[NCBaseModel alloc] init];
                    child.modelId = tmpdict[@"id"];
                    child.modelName = tmpdict[@"name"];
                    [tmparr addObject:child];
                }
                talentAgeModel.childSectionData = tmparr;
                [talentchild addObject:talentAgeModel];
                
                  NSDictionary *talentCity_cate = talents_cate[@"city_cate"];
                NCBaseModel *talentCityModel =  [[NCBaseModel alloc] init];
                      talentCityModel.modelName = @"city_cate";
                tmparr = [NSMutableArray new];
                for (NSDictionary *tmpdict in talentCity_cate) {
                    
                    NCBaseModel *child =  [[NCBaseModel alloc] init];
                    child.modelId = tmpdict[@"id"];
                    child.modelName = tmpdict[@"name"];
                    [tmparr addObject:child];
                }
                talentCityModel.childSectionData = tmparr;
                
                talentModel.childSectionData = talentchild;
                weakself.talents_cateData = talentModel;
                
                

                NSArray *index_cate = res[@"index_cate"];
                NCBaseModel *indexModel =  [[NCBaseModel alloc] init];
                indexModel.modelName = @"index_cate";
                
                tmparr = [NSMutableArray new];
                for (NSDictionary *tmpdict in  index_cate) {
                    NCBaseModel *tmpmodel =  [[NCBaseModel alloc] init];
                    tmpmodel.modelId = tmpdict[@"id"];
                    tmpmodel.modelName = tmpdict[@"name"];
 
                    NSArray *sschild = tmpdict[@"child"];
                    NSMutableArray *tmparr2 = [NSMutableArray new];
                    if (sschild) {
                        for (NSDictionary *tmpdict2 in  sschild)
                        {
                            NCBaseModel *tmpmodel2 =  [[NCBaseModel alloc] init];
                            tmpmodel2.modelId = tmpdict2[@"id"];
                            tmpmodel2.modelName = tmpdict2[@"name"];
                            [tmparr2 addObject:tmpmodel2];
                        }
                    }
                    tmpmodel.childSectionData = tmparr2;
                    [tmparr addObject:tmpmodel];
                }
                
                indexModel.childSectionData = tmparr;
                weakself.indexData = indexModel;
                    
                

                NSDictionary *index_search_cate = res[@"index_search_cate"];
                NCBaseModel *index_searchModel = [self parseData:index_search_cate andParentModel:nil];
                index_searchModel.modelName = @"index_search_cate";
    
                weakself.indexSearchData  = index_searchModel;
                
                
                
                NSDictionary *certificate_search_cate = res[@"certificate_search_cate"];
                NCBaseModel *certificate_searchModel =  [self parseData:certificate_search_cate andParentModel:nil];
                certificate_searchModel.modelName = @"certificate_search_cate";
                weakself.certificate_searchData = certificate_searchModel;
              
                
                NSDictionary *organization_search_cate = res[@"organization_search_cate"];
                NCBaseModel *organization_searchModel =  [self parseData:organization_search_cate andParentModel:nil];
                organization_searchModel.modelName = @"organization_search_cate";
                weakself.organization_searchData = organization_searchModel;
                
                
                NSDictionary *reg_certificate = res[@"reg_certificate"];
                NCBaseModel *reg_certificateModel = [[NCBaseModel alloc] init];
                reg_certificateModel.modelName = reg_certificate[@"title"];
                reg_certificateModel.modelSubTitle =  reg_certificate[@"subtitle"];
                reg_certificateModel.content =  reg_certificate[@"content"];
                weakself.reg_certificateData = reg_certificateModel;
                
                //简历协议
                NSDictionary *resume_certificate = res[@"resume_certificate"];
                NCBaseModel *resume_certificateModel = [[NCBaseModel alloc] init];
                resume_certificateModel.modelName = resume_certificate[@"title"];
                resume_certificateModel.modelSubTitle =  resume_certificate[@"subtitle"];
                resume_certificateModel.content =  resume_certificate[@"content"];
                weakself.reg_certificateData = resume_certificateModel;
                
                
                weakself.reg_certificateData = resume_certificateModel;
                
                
                NSDictionary *practice_cate = res[@"practice_cate"];
                
                NCBaseModel *practice_catehModel =  [self parseData:practice_cate  andParentModel:nil];
                practice_catehModel.modelName = @"certificate_search_cate";
                weakself.practiceData = practice_catehModel;
                
                completeBlock(YES,nil);
            }
            else
            {
                 completeBlock(NO,error);
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
  
    if (![NCUserConfig haslogin]) {
        return;
    }
   NCUserConfig *currentUser = [NCUserConfig sharedInstance];
    [params setObject:currentUser.uid forKey:@"uid"];
    [params setObject:currentUser.uuid forKey:@"uuid"];
    
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
    
//    [params setObject:cagID forKey:@"cid"];
    [params setObject:user.uid forKey:@"uid"];
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
    if (![NCUserConfig haslogin]) {
        return;
    }
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:cagID forKey:@"cid"];
    
    [params setObject:[NSNumber numberWithInteger:startpage] forKey:@"page"];
    
    [params setObject:[NSNumber numberWithInteger:onepageCount] forKey:@"pagenum"];
    
    
    [params setObject:user.uid forKey:@"uid"];
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

-(void)requestPracticeLibraryData:(NSString *)cagID withPageFrom:(NSInteger)startpage
          withOnePageCount:(NSInteger)onepageCount
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    if (![NCUserConfig haslogin]) {
        return;
    }
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:cagID forKey:@"cid"];
    
    [params setObject:[NSNumber numberWithInteger:startpage] forKey:@"page"];
    
    [params setObject:[NSNumber numberWithInteger:onepageCount] forKey:@"pagenum"];
    
    
    [params setObject:user.uid forKey:@"uid"];
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



-(void)requestQuestionListData:(NSString *)cagID
                     WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{

    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setObject:cagID forKey:@"cid"];
    
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kTestListURL
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

-(void)requestServerMessageData:(NSInteger )page withPageNumber:(NSInteger)pagenum
                   WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    
    NSString *pagestr = [NSString stringWithFormat:@"%ld",(long)page ];
    [params setObject:pagestr forKey:@"page"];
    NSString *pagenumstr = [NSString stringWithFormat:@"%ld",(long)pagenum ];
    [params setObject:pagenumstr forKey:@"pagenum"];
    
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kMessageCenterURL
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//{"code":200,"res":[{"title":"版本更新2.0","id":"1"},{"title":"成绩公布","id":"2"}]}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}


-(void)requestMessageContentData:(NSString *)msgid
                   WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    
    [params setObject:msgid forKey:@"id"];
    
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kMessageContentURL
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//{"code":200,"res":{"title":"版本更新2.0","id":"1","content":"系统有的更新请及时更新","time":"2015-12-10"}}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}



-(void)requestCorpListData:(NSString *)area page:(NSInteger )page withPageNumber:(NSInteger)pagenum
              WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    
    if (area) {
        
        [params setObject:area forKey:@"area"];
    }
    
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:pagenum]  forKey:@"pagenum"];
    
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kCorpListUrl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //{"code":200,"res":{"title":"版本更新2.0","id":"1","content":"系统有的更新请及时更新","time":"2015-12-10"}}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}
-(void)requestCorpInfo:(NSString *)corpId
          WithComplate:(void (^)(NSDictionary *result, NSError *error))completeBlock;
{
    
    NCUserConfig *user = [NCUserConfig sharedInstance];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    
    [params setObject:corpId forKey:@"id"];
    
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.uuid forKey:@"uuid"];
    [params addEntriesFromDictionary: [NCInitial getBaseParams]];
    
    
    NSMutableURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:@"POST" URLString:kCorpInfoUrl
                                                                                 parameters:params error:nil];
    
    request.timeoutInterval = 10;
    
    WS(weakself)
    __weak AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //{"code":200,"res":{"title":"版本更新2.0","id":"1","content":"系统有的更新请及时更新","time":"2015-12-10"}}
        
        NSDictionary *dict = [operation.responseData objectFromJSONData];
        
        completeBlock(dict, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(nil, error);
        
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [self.requestManager.operationQueue addOperation:operation];
}

@end
