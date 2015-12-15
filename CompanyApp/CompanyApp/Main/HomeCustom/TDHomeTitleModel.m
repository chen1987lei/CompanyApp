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
    
    if (self.selectedIcon == nil || [self.selectedIcon length] == 0) {
        if ([[TDImageCache sharedImageCache] imageFromKey:self.icon]) {
            self.isValid = YES;
        }
    }else if ([[TDImageCache sharedImageCache] imageFromKey:self.icon] &&
        [[TDImageCache sharedImageCache] imageFromKey:self.selectedIcon]) {
        self.isValid = YES;
    }else {
        //缓存 icon
        [[TDImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.icon]
                                                     options:TDWebImageRetryFailed
                                                    progress:nil
                                                   completed:^(UIImage *image, NSError *error, TDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       if (image) {
                                                           [[TDImageCache sharedImageCache] storeImage:image forKey:self.icon];
                                                       }
                                                   }];
        [[TDImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.selectedIcon]
                                                     options:TDWebImageRetryFailed
                                                    progress:nil
                                                   completed:^(UIImage *image, NSError *error, TDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       if (image) {
                                                           [[TDImageCache sharedImageCache] storeImage:image forKey:self.selectedIcon];
                                                       }
                                                   }];

    }
}

@end
