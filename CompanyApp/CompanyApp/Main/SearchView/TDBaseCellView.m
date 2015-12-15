//
//  TDBaseCellView.m
//  Tudou
//
//  Created by CL7RNEC on 15/3/31.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseCellView.h"

@implementation TDBaseCellView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.exclusiveTouch=YES;
        _isCornerHidden=NO;
        _isMarkHidden=NO;
    }
    return self;
}

- (void)refreshCellView{
    
}

-(void)animationWithImage{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transition forKey:nil];
}

@end
