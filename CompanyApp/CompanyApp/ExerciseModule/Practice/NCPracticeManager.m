//
//  NCPracticeManager.m
//  CompanyApp
//
//  Created by chenlei on 15/12/21.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeManager.h"
#import "NCInitial.h"

@implementation NCPracticeManager



+(NCPracticeManager *)sharedInstance;
{
    static NCPracticeManager *config = nil;
    if (config == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            config = [[NCPracticeManager alloc] init];

        });
    }
    
    return config;
}


-(void)requestQuestionlistWithComplete:(void (^)(NSArray *result))completeBlock
{
    WS(weakself)
    [[NCInitial sharedInstance] requestQuestionListData:_testStartId WithComplate:^(NSDictionary *result, NSError *error) {
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSArray *qustlist = result[@"res"];
            
            NSMutableArray *mularr = [NSMutableArray new];
            for (NSDictionary *dict in qustlist) {
                NSPracticeQuestion *aa = [[NSPracticeQuestion alloc] init];
                
                aa.type = [dict[@"type"] integerValue];
                aa.question = dict[@"problem"];
                aa.answer = dict[@"answer"];
                
                NSMutableArray *cholist = [NSMutableArray new];
                [cholist addObject:@{@"a":dict[@"a"]}];
                [cholist addObject:@{@"b":dict[@"b"]}];
                [cholist addObject:@{@"c":dict[@"c"]}];
                [cholist addObject:@{@"d":dict[@"d"]}];
                aa.choicelist = cholist;
                
                aa.cid = dict[@"cid"];
                aa.parsing = dict[@"parsing"];
                aa.top = [dict[@"top"] integerValue];
                
                //"problem":"岁寒三友不包括（）","a":"梅","b":".竹","c":"兰 ","d":"松","answer":"c","parsing":" 松松松松松松松松松松松松松松松松松松松松松松松松松松松松松","cid":"17","type":"1","top":"93
                [mularr addObject:aa];
            }
            
            weakself.questionList = mularr;
            completeBlock(mularr);
        }
        else
        {
            completeBlock(nil);
        }
    }];
}


@end
