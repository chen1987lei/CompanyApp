//
//  TDTitleBar.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-20.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ShadowPathLayer.h"
#import "TDRightImageLabel.h"
#import "TDBlurView.h"

//ios7适配，蔡亮，2013-9-22，针对ios7的状态栏问题做调整
extern int sSTATUS_BAR_HEIGHT ;         //状态栏，在init方法中调用
extern int sVIEW_TOP_MARGIN ;           //上边的距离
extern int sSTATUS_BAR_MARGIN_TOP ;     //距离顶边距20
//之所以有这个宏，是因为有些view如果视图不是白色背景，title栏底部的阴影效果会变成银白色细条
#define kTITLEBAR_BOTTOM_LINE_HEIGHT    1
#define TitleBar_Height (MY_IOS_VERSION_7?(44+20):44)
#define TitleBar_Btn_Width 39 //10+19+10
#define TitleBar_Btn_String_Width 90

#define kBlurTintColoriOS7 RGBA(255, 102, 0, 0.9)
#define kBlurTintColor  RGBA(255, 102, 0, 0.98)

#define kTDTitleBarShowMarketControlNotification    @"TDTitleBarShowMarketControlNotification"

@class TDTitleBar;

@protocol TDTitleBarDelegate <NSObject>

@optional
- (void)titleBar:(TDTitleBar *)titleBar didClickRightItemAtIndex:(NSInteger)index;
- (void)titleBardidClickleftItem:(TDTitleBar *)titleBar;
- (void)titleBardidClickRightTitle:(TDTitleBar *)titleBar;

@end

@interface TDTitleBar : TDBlurView
{
    SEL _leftSelector;
}
@property(nonatomic,weak) id<TDTitleBarDelegate> delegate;
@property(nonatomic,strong,readonly) NSMutableArray *rightItemArray;
@property(nonatomic,strong) TDRightImageLabel * titleLabel;
@property(nonatomic,readonly) UIButton *leftItem;
@property(nonatomic,readonly) UIView *leftLogView;
@property(nonatomic, assign) BOOL isShowLeftLogo;//用于主页显示左侧 频道名称和 土豆网几个字
@property(nonatomic, assign) BOOL shouldIgnoreAction;
@property(nonatomic, assign) BOOL cancelLayout;

- (id)init;
- (void)setTitle:(NSString *) title;

/**
 *添加title图标，播客页面（播客加V）用到
 */
- (void)setLeftItemTitle:(NSString*)title;
- (void)setLeftTitle:(NSString *)title withSelector:(SEL)selector;
- (void)setLeft:(UIImage *)image highLight:(UIImage *)highlightImage withSelector:(SEL)selector;

//右边item
- (void)setRightTitle:(NSString *)title;
- (void)setRightItemImage:(UIImage *)image selectedImage:(UIImage *)selectedImage atIndex:(NSInteger)index;
- (void)addRightItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;

- (UIButton *)getRightItemWithIndex:(NSInteger)index;

//其他设置
-(void)setTitleColor:(UIColor *)color;
-(void)setTitleBarTudouColor;
-(void)setTitleBarColor:(UIColor *)color;
-(void)setLeftLogView:(UIView *)logView;
-(void)setCenterView:(UIView *)centerView;
-(void)setRightView:(UIView *)rightView;
-(void)setBottomLineViewHidden:(BOOL)ishidden;

@end
