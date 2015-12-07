//
//  UIScreen+Addition.h
//  Tudou
//  屏幕适配类
//  Created by CL7RNEC on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Addition)
/**
 *  屏幕宽度
 *
 *  @return 宽度
 */
+(CGFloat)screenScale;
/**
 *  屏幕宽度
 *
 *  @return 宽度
 */
-(CGFloat)screenWidth;
/**
 *  屏幕长度
 *
 *  @return 长度
 */
-(CGFloat)screenHeight;
/**
 *  屏幕尺寸
 *
 *  @return 尺寸
 */
-(CGSize)screenSize;
/**
 * 屏幕Rect边界
 *
 * @return rect
 */
-(CGRect)screenBounds;

+ (CGFloat)width;

+ (CGFloat)height;

+ (CGFloat)transIphone5Width:(CGFloat)w;

+ (CGFloat)transIphone5Height:(CGFloat)h;

+ (CGFloat)calWidth:(CGFloat)height width_height_ratio:(CGFloat)ratio;

+ (CGFloat)calHeight:(CGFloat)width width_height_ratio:(CGFloat)ratio;

+ (CGFloat)screenNoneTabBarAreaHeight;//tabbar之上可用区域的高度

@end
