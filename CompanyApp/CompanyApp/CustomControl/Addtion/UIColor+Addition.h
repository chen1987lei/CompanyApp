//
//  UIColor+Addition.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define RGBS(s) RGBA(s,s,s,1.0f)

@interface UIColor (Addition)
+ (UIColor *) TDOrange;//土豆黄色titlebar颜色
+ (UIColor *) TDTabBlack;
+ (UIColor *) TDMilkWhite;
+ (UIColor *) TDMainBackgroundColor;//土豆客户端主背景色
+ (UIColor *) TDFontColor;//土豆字体特殊黑色
+ (UIColor *) TDSiftBackground;//土豆筛选背景
+ (UIColor *) TDFontBlack;
+ (UIColor *) TDPlayerTransparentBlack;//播放器控制条透明后
+ (UIColor *) TDDetailUGCColor;//详情页相关选集背景色
+ (UIColor *) TDTraceColor;

//3.1 ipad
+ (UIColor *) TDFontLigthGray;
+ (UIColor *) TDLineLightGray;
+ (UIColor *) TDTimeFontColor;
+ (UIColor *) TDWhiteColor253;

//4.0
+ (UIColor *)TDTitleColor;
+ (UIColor *)TDSubTitleColor;
+ (UIColor *)TDFailedFontColor;//空数据 网络错误 刷新错误 提示的字体颜色

//4.4.1
+ (UIColor *)TDSubTitleColor2;
@end
