//
//  ShadowPathLayer.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-21.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "ShadowPathLayer.h"

@implementation ShadowPathLayer
- (id)init
{
    self = [super init];
    if(self)
    {
        _shadowLayer = [CALayer layer];
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.strokeColor = [UIColor TDOrange].CGColor;
        [self addSublayer:_shadowLayer];
        [_shadowLayer addSublayer:_pathLayer];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _shadowLayer.frame = frame;
    _pathLayer.frame = frame;
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

- (void)setFillColor:(CGColorRef)fillColor
{
    _pathLayer.fillColor = fillColor;
}

- (void)setPath:(CGPathRef) path
{
    _pathLayer.path = path;
}

- (void)setShadowColor:(CGColorRef)shadowColor
{
    _shadowLayer.shadowColor = shadowColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowLayer.shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(float)shadowOpacity
{
    _shadowLayer.shadowOpacity = shadowOpacity;

}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowLayer.shadowRadius = shadowRadius;
}

@end
