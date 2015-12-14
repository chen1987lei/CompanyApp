//
//  NCModelManager.h
//  CompanyApp
//
//  Created by chenlei on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NCCertificate : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString * subtitle;
@property(nonatomic,strong) NSString *content;

@end



@interface NCModel : NSObject

@property(nonatomic,assign) NSInteger modelId;
@property(nonatomic,assign) NSInteger parentModel;
@property(nonatomic,strong) NSString *modelName;

@property(nonatomic,strong) NSString *fid;
@property(nonatomic,strong) NSString *rank;


@property(nonatomic,assign) NSInteger status;

@property(nonatomic,assign) NSInteger top;



@end


@interface NCModelManager : NSObject
{
    
}


@property(nonatomic,strong) NSArray *modelData;

@end
