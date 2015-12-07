//
//  UIView+Addition.m
//  Youku
//
//  Created by liguang on 8/3/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "UIView+Addition.h"


@implementation UIView(Addition)

- (CGFloat)left {
	return self.frame.origin.x;
}


- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}


- (CGFloat)top {
	return self.frame.origin.y;
}


- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}


- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}


- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}


- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}


- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}


- (CGFloat)centerX {
	return self.center.x;
}


- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerY {
	return self.center.y;
}


- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)width {
	return self.bounds.size.width;
}


- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


- (CGFloat)height {
	return self.bounds.size.height;
}


- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


- (CGPoint)origin {
	return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}


- (CGSize)size {
	return self.frame.size;
}


- (void)setSize:(CGSize)size {
	CGRect frame = self.bounds;
	frame.size = size;
	self.frame = frame;
}


- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}


- (void)makeFrameOriginPointToInteger {
    CGRect frame = self.frame;
    frame.origin = CGPointMake(round(CGRectGetMinX(frame)), round(CGRectGetMinY(frame)));
    self.frame = frame;
}

- (void)addControllerView:(UIViewController *)controller
{
    if(SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        [controller viewWillAppear:NO];
        [self addSubview:controller.view];
        [controller viewDidAppear:NO];
    }
    else
        [self addSubview:controller.view];
}
@end