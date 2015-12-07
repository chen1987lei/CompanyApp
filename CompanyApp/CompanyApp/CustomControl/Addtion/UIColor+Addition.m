//
//  UIColor+Addition.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)
+ (UIColor *) TDOrange
{
    return RGB(255, 102, 0);
}

+ (UIColor *) TDTabBlack{
    return RGB(40, 40, 40);
}

+ (UIColor *) TDMilkWhite
{
    return RGB(250, 250, 250);
}

+ (UIColor *) TDMainBackgroundColor{
    return RGB(240, 240, 240);
    //return [UIColor colorWithPatternImage:Image(@"bg_common.png")];
}

+ (UIColor *) TDFontColor{
    return RGB(70, 70, 70);//127
}

+ (UIColor *) TDTraceColor {
    
    return RGBA(217, 217, 217, 1);
}

+ (UIColor *) TDSiftBackground
{
    return [UIColor colorWithPatternImage:Image(@"channel_bg.png")];
}

+ (UIColor *) TDDetailUGCColor{
    return [UIColor colorWithPatternImage:Image(@"the_details_ugc_bg.png")];
}

+ (UIColor *) TDFontBlack
{
    return RGB(48, 48, 48);
}

+ (UIColor *) TDPlayerTransparentBlack
{
    return RGBA(0, 0, 0, 0.7);
}

+ (UIColor *) TDFontLigthGray{
    return RGB(140, 140, 140);
}
+ (UIColor *) TDTimeFontColor{
    return RGB(184, 184, 184);
}
+ (UIColor *) TDLineLightGray{
    return RGBS(217);
}
+ (UIColor *) TDWhiteColor253{
    return RGB(253, 253, 253);
}

//4.0
+ (UIColor *)TDTitleColor{
    return RGBS(60);
}
+ (UIColor *)TDSubTitleColor{
    return RGBS(102);
}
+ (UIColor *)TDFailedFontColor{
    return RGBS(180);
}

//4.4.1
+ (UIColor *)TDSubTitleColor2{
    return RGBS(150);
}

@end
