//
//  TDCustomSeg.h
//  Tudou
//
//  Created by 李 福庆 on 13-6-28.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TDCustomSegDelegate<NSObject>
- (void)clickButtonAtIndex:(NSUInteger)index;
@end
@interface TDCustomSeg : UIView
@property(nonatomic,weak) id delegate;

- (id)initWithItemArray:(NSArray *)itemArray;    //初始化方法必须调用其一，默认frame
- (id)initWithItemArray:(NSArray *)itemArray
              withFrame:(CGRect)frame;                  //初始化方法必须调用其一，此frame是每一个item的frame
- (void)didSelectIndex:(NSInteger)index;
- (void)setItemTitle:(NSString *)title ForIndex:(NSUInteger)index;//动态变化标题
- (void)setItemWidth:(CGFloat)width;
/**
 *  是否隐藏
 *
 *  @param hide 1隐藏0显示
 */
- (void)setSelectViewHide:(BOOL)hide;
@end
