//
//  TDBorderView.m
//  Tudou
//
//  Created by lihang on 15/2/10.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBorderView.h"

@implementation TDBorderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _borderColor = RGBA(180.0, 180.0, 180.0,0.6);
        
        _borderWidth = 0.5;
        
        self.layer.shouldRasterize = YES;
        
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    
    CGContextSetLineWidth(context, _borderWidth);
    

    CGContextMoveToPoint(context, 0.5, 0.5);
    
    CGContextAddLineToPoint(context, self.width-0.5, 0.5);
    
    CGContextAddLineToPoint(context, self.width-0.5, self.height-0.5);

    CGContextAddLineToPoint(context, 0.5, self.height-0.5);
    
    CGContextAddLineToPoint(context, 0.5, 0.5);
    
    
    CGContextStrokePath(context);
}

@end
