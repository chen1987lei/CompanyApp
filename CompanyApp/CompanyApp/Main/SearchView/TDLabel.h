//
//  TDLabel.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-10.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//
//find in https://discussions.apple.com/message/8322622?messageID=8322622#8322622?messageID=8322622
#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface TDLabel : UILabel

@property (nonatomic,assign) VerticalAlignment verticalAlignment;
@property (nonatomic)        UIEdgeInsets textEdgeInsets;
@end
