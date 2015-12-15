//
//  TDHomeTitleModel.m
//  Tudou
//
//  Created by zhongzhendong on 15/9/8.
//  Copyright © 2015年 Youku.com inc. All rights reserved.
//

#import "TDHomeTitleModel.h"

@implementation TDHomeTitleModel

-(void)parseWithDictionary:(NSDictionary *)dict{
    NSArray *keys = [dict allKeys];
    self.icon = [keys containsObject:@"icon_for_phone"]?dict[@"icon_for_phone"]:nil;
    self.selectedIcon = [keys containsObject:@"selected_icon_for_phone"]?dict[@"selected_icon_for_phone"]:nil;
    self.skipInfo = [keys containsObject:@"skip_inf"]?dict[@"skip_inf"]:nil;
    
    if (self.skipInfo == nil || self.skipInfo[@"skip_type"] == nil) {
        self.isValid = NO;
        return;
    }
    

}

@end
