//
//  TDHomeTitleModel.h
//  Tudou
//
//  Created by zhongzhendong on 15/9/8.
//  Copyright © 2015年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDBaseObject.h"

@interface TDHomeTitleModel : TDBaseObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *selectedIcon;
@property (nonatomic, strong) NSDictionary *skipInfo;
@property (nonatomic, assign) BOOL isValid;

@end
