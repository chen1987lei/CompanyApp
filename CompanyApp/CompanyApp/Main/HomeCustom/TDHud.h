//
//  TDHud.h
//  Tudou
//
//  Created by zhang jiangshan on 13-1-29.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCommActivity.h"
@interface TDHud : UIView
{
    TDCommActivity * _activity;
}
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
