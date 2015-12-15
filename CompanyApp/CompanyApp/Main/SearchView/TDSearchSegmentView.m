//
//  TDSearchSegmentView.m
//  Tudou
//
//  Created by weiliang on 14-3-14.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDSearchSegmentView.h"

@implementation TDSearchSegmentView
#define kButtonTag 1000
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonsArray = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)setTitleArray:(NSArray*)array{
    
    for (int i = 0; i < [array count]; i++) {
        UIButton* buttonMore = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonMore.frame = CGRectMake(30 + (i%2) * 160, 5, 100, 30);
        [buttonMore addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        buttonMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [buttonMore setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [buttonMore setBackgroundColor:[UIColor clearColor]];
        buttonMore.tag = i + kButtonTag;
        if (i == 0) {
            currentSelect = i;
            [buttonMore setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
        }
        else
        {
            [buttonMore setTitleColor:RGB(95, 99, 107) forState:UIControlStateNormal];
        }
        [self addSubview:buttonMore];
    }
}
- (void)setCurrentSelect:(NSInteger)selectTag
{
    if (currentSelect == selectTag) {
        return;
    }
    [(UIButton*)[self viewWithTag:currentSelect + kButtonTag] setTitleColor:RGB(95, 99, 107) forState:UIControlStateNormal];
    currentSelect = selectTag;
    [(UIButton*)[self viewWithTag:currentSelect + kButtonTag] setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
    
}
- (void)clickButton:(UIButton*)sender
{
    int buttonTAG = (int)sender.tag;
    if (currentSelect + kButtonTag == buttonTAG) {
        return;
    }
    [sender setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
    [(UIButton*)[self viewWithTag:currentSelect + kButtonTag] setTitleColor:RGB(95, 99, 107) forState:UIControlStateNormal];
    currentSelect = buttonTAG - kButtonTag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonAtIndex:)]) {
        [self.delegate clickButtonAtIndex:currentSelect];
    }
}
 
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, RGBS(217).CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, -1, self.height - 1);
    CGContextAddLineToPoint(context, self.width + 4, self.height - 1);
  
    CGContextMoveToPoint(context, self.width/2, 0);
    CGContextAddLineToPoint(context, self.width/2, self.height - 1);
    CGContextStrokePath(context);
}
 

@end
