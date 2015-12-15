//
//  TDBlurView.h
//  Tudou
//  毛玻璃效果视图，基于UINavigationBar实现，只支持ios7
//  Created by CL7RNEC on 13-8-31.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDBlurView : UIImageView

/**
 *  设置毛玻璃虚化颜色
 *
 *  @param blurTintColor 色值
 */
- (void)setBlurTintColor:(UIColor *)blurTintColor;
/**
 *  设置背景颜色为黑色
 */
-(void)setBlurTintBlackColor;
/**
 *  设置大小
 *
 *  @param frame 尺寸
 */
- (void)setBlurBarFrame:(CGRect)frame;
/**
 *  移除毛玻璃视图
 */
-(void)removeBlurView;
@end
