//
//  CALayer+Addition.m
//  Youku
//
//  Created by 光 李 on 4/17/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "CALayer+Addition.h"

@implementation CALayer (Addition)
- (void)autoSetContentsScale {
    if ([self respondsToSelector:@selector(contentsScale)]) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
}

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
	return self.position.x;
}


- (void)setCenterX:(CGFloat)centerX {
	self.position = CGPointMake(centerX, self.position.y);
}


- (CGFloat)centerY {
	return self.position.y;
}


- (void)setCenterY:(CGFloat)centerY {
	self.position = CGPointMake(self.position.x, centerY);
}


- (CGFloat)width {
	return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


- (CGFloat)height {
	return self.frame.size.height;
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
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

@end
