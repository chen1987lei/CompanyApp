//
//  TDCommActivity.m
//  Tudou
//
//  Created by zhangjiwang on 14-3-26.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDCommActivity.h"

@implementation TDCommActivity

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.bgLayer.contents = nil;
        self.rotateLayer.contents = (id)Image(@"comm_loading").CGImage;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
