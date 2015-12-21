//
//  NCPracticeManager.h
//  CompanyApp
//
//  Created by chenlei on 15/12/21.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSPracticeQuestion.h"

@interface NCPracticeManager : NSObject

@property(nonatomic,strong) NSArray *questionList; //NSPracticeQuestion
@property(nonatomic,strong) NSString *testStartId;

@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,strong) NSString *endDate;

@property(nonatomic,assign) NSTimeInterval usedtime;

+(NCPracticeManager *)sharedInstance;

-(void)requestQuestionlistWithComplete:(void (^)(NSArray *result))completeBlock;
@end
