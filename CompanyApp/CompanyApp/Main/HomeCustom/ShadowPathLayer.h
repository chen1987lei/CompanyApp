//
//  ShadowPathLayer.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-21.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ShadowPathLayer : CALayer

@property (nonatomic, strong) CALayer * shadowLayer;
@property (nonatomic, strong) CAShapeLayer * pathLayer;

- (void)setBackgroundColor:(CGColorRef)backgroundColor;

- (void)setFillColor:(CGColorRef)fillColor;

- (void)setPath:(CGPathRef) path;

- (void)setShadowColor:(CGColorRef)shadowColor;

- (void)setShadowOffset:(CGSize)shadowOffset;

- (void)setShadowOpacity:(float)shadowOpacity;

- (void)setShadowRadius:(CGFloat)shadowRadius;

@end
