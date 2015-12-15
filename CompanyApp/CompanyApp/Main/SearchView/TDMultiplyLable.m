//
//  TDMultiplyLable.m
//  Tudou
//
//  Created by weiliang on 13-8-15.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDMultiplyLable.h"

@implementation LableTextAndColor
@end

#define kLableTAG    100
@implementation TDMultiplyLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) setMultiplyTexts:(NSArray*)textsAndColorArray
{
 
    [self removeAllSubviews];
    if ([textsAndColorArray count] == 0) {
        return;
    }
    int width = 0;
    for (int i = 0; i < [textsAndColorArray count]; i++) {
        LableTextAndColor* textAndColor = [textsAndColorArray objectAtIndex:i];
        CGSize  lableSize = [textAndColor.lableText sizeWithFont:textAndColor.lableFont];
        UILabel* lable;
        lable = [[UILabel alloc] initWithFrame:CGRectMake(width, (self.frame.size.height > lableSize.height ? (self.frame.size.height - lableSize.height)/2 : 0), lableSize.width + width > self.frame.size.width ? self.frame.size.width - width : lableSize.width,lableSize.height)];
        lable.font = textAndColor.lableFont;
        lable.textColor = textAndColor.lableColor;
        lable.text = textAndColor.lableText;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.lineBreakMode = NSLineBreakByTruncatingTail;
        lable.backgroundColor = [UIColor clearColor];
        [self addSubview:lable];
        
        //越界处理
        width += lableSize.width;
//        if (width > self.frame.size.width + 5 && i < [textsAndColorArray count] - 1) {
//            lable.text = @"...";
//            break;
//        }
//        else
        
        
        
//        DLog(@" %d   lableText  %@",i,lable.text);
//        DLog(@"%d :%d",i,width);
 
    }
}

@end
