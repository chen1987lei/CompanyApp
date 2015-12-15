//
//  UIScreen+Addition.m
//  Tudou
//  屏幕适配类
//  Created by CL7RNEC on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "UIScreen+Addition.h"

@implementation UIScreen (Addition)
/**
 *  屏幕scale
 *
 *  @return scale
 */
+(CGFloat)screenScale;
{
    return [[self class] width]/320.0;
}
/**
 *  屏幕宽度
 *
 *  @return 宽度
 */
-(CGFloat)screenWidth{
    return [self screenSize].width;
}
/**
 *  屏幕长度
 *
 *  @return 长度
 */
-(CGFloat)screenHeight{
    return [self screenSize].height;
}
/**
 *  屏幕尺寸
 *
 *  @return 尺寸
 */
-(CGSize)screenSize{
    CGSize screenSize = self.bounds.size;
    
    //iOS8 返回bounds 宽高已经随着旋转变化，这里加入了判断代码，长边必然为高，短边必然为宽
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.height;
    
    CGFloat deviceHeight = MAX(width, height);
    CGFloat deviceWidth = MIN(width, height);
    
    return CGSizeMake(deviceWidth, deviceHeight);
}
/**
 * 屏幕Rect
 *
 * @return rect
 */
-(CGRect)screenBounds{
    CGSize screenSize = [self screenSize];

    return CGRectMake(0, 0, screenSize.width, screenSize.height);
}
/**
 *  屏幕自适应宽度
 *
 *  @return 宽度
 */
-(CGFloat)screenAutoWidth{
    return [self screenSize].width;
}
/**
 *  屏幕自适应长度
 *
 *  @return 长度
 */
-(CGFloat)screenAutoHeight{
    return [self screenSize].height;
}
/**
 *  屏幕自适应尺寸
 *
 *  @return 尺寸
 */
-(CGSize)screenAutoSize{
    return [self screenSize];
}

+ (CGFloat)width
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    float width = MIN(size.width, size.height);
    return width;
}

+ (CGFloat)height
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    float height = MAX(size.width, size.height);
    return height;
}

+ (CGFloat)transIphone5Width:(CGFloat)w
{
    CGFloat width = w;
    if (is_iphone5() || is_iphone4()) {
        width = w;
    }else{
        width = w/320 *[UIScreen width];
    }
    return width;
}

+ (CGFloat)transIphone5Height:(CGFloat)h
{
    CGFloat height = h;
    if (is_iphone5() || is_iphone4()) {
        height = h;
    }else{
        height = h/568 *[UIScreen height];
    }
    return height;
}

+ (CGFloat)calHeight:(CGFloat)width width_height_ratio:(CGFloat)ratio
{
    if (ratio > 0) {
        return width / ratio;
    }
    return 0;
}

+ (CGFloat)calWidth:(CGFloat)height width_height_ratio:(CGFloat)ratio
{
    if (ratio > 0) {
        return height * ratio;
    }
    return 0;
}

+ (CGFloat)screenNoneTabBarAreaHeight{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return ([UIScreen height] - TAB_BAR_HEIGHT);
    }
    return ([UIScreen height] - 20.0f - TAB_BAR_HEIGHT);
}


@end
