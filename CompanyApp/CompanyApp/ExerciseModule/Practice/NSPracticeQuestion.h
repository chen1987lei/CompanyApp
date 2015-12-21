//
//  NSPracticeQuestion.h
//  CompanyApp
//
//  Created by chenlei on 15/12/21.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPracticeQuestion : NSObject

@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *question;
@property(nonatomic, strong) NSArray *choicelist; // A:weqwe
@property(nonatomic, strong) NSString *answer;

@property(nonatomic, strong) NSString *useranswer;

@property(nonatomic, strong) NSString *parsing;
@property(nonatomic, strong) NSString *cid;
@property(nonatomic, assign) NSInteger top;

//"problem":"岁寒三友不包括（）","a":"梅","b":".竹","c":"兰 ","d":"松","answer":"c","parsing":" 松松松松松松松松松松松松松松松松松松松松松松松松松松松松松","cid":"17","type":"1","top":"93

@end
