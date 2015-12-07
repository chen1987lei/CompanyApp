//
//  Universal.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#define PushMsgVideoWillPlayNotification @"PushMsgVideoWillPlayNotification"

#define DownloadPath PathForDocumentsResource(@"Download/")
#define LocalCachePath PathForCacheResource(@"DataCache/")

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define TD_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define TD_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#define kHudYOffset (-80)
BOOL isPhone();
BOOL isPad();
BOOL isPhone5();
BOOL isIpadDevice();
CGSize screenSize();
UIImage *Image(NSString *name);
NSString *LocalizedString(NSString* key);

NSString* PathForBundleResource(NSString* relativePath);
NSString* PathForDocumentsResource(NSString* relativePath);
NSString *PathForCacheResource(NSString *relativePath);

NSString * convertTimeWithSecondes(double seconds);
NSString * convertTimeWithSecondes_cutoffHour(double seconds);

CGFloat caculateTimeBlock (void (^block)(void));
@interface Universal : NSObject

/**
 *  计算str定宽size
 *
 *  @param str   文字
 *  @param width 固定宽度
 *  @param font  字体
 *
 *  @return CGSize
 */
+ (CGSize)calTextSize:(NSString*)str
          limiteWidth:(CGFloat)width
                 font:(UIFont*)font;
@end
