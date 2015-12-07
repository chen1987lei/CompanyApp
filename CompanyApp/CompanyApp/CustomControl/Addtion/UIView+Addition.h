//
//  UIView+Addition.h
//  Youku
//
//  Created by liguang on 8/3/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SINGLE_LINE_WIDTH               (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_HEIGHT              (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET       ((1 / [UIScreen mainScreen].scale) / 2)

@interface UIView(Addition)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

- (void)removeAllSubviews;

//将UIView的frame的origin调整为整型
- (void)makeFrameOriginPointToInteger;

- (void)addControllerView:(UIViewController *)controller;//自定义方法，会产生viewwillappear回调，（解决ios4.3第二次加载不会回调的问题，第一次会调两次）
@end
