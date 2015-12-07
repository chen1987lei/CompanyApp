//
//  Universal.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc.All rights reserved.
//

#import "Universal.h"
#import <mach/mach_time.h>

int sSTATUS_BAR_MARGIN_TOP=20;  //非ios7下是20

BOOL isPhone()
{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?  YES : NO);
}

//判断硬件设备是否是ipad
BOOL isIpadDevice()
{
    NSString *  nsStrIpad=@"iPad";
    NSString* deviceType = [UIDevice currentDevice].model;
    NSRange range = [deviceType rangeOfString:nsStrIpad];
    return range.location != NSNotFound;
}

BOOL isPad()
{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?  YES : NO);
}

BOOL isPhone5()
{
    if(isPad())
        return NO;
    return [[UIScreen mainScreen] screenHeight] > 480 ? YES : NO;//iPhone5  568
}

CGSize screenSize()
{
    CGSize size = [[UIScreen mainScreen] screenSize];
    
    //如果是ios7，则调整状态栏和上边距的值
    if (MY_IOS_VERSION_7) {
//        sSTATUS_BAR_HEIGHT=20;
//        sVIEW_TOP_MARGIN=10;
        sSTATUS_BAR_MARGIN_TOP=0;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        return CGSizeMake(size.width, size.height-sSTATUS_BAR_MARGIN_TOP);
    else
        return CGSizeMake(size.height-sSTATUS_BAR_MARGIN_TOP, size.width);
}

UIImage *Image(NSString *name)
{
    if (![name isNotBlankString]) {
        return nil;
    }
    NSMutableString *imageName = [NSMutableString stringWithString:name];
    if (![name hasSuffix:@".png"] && ![name hasSuffix:@".jpg"]) {
        [imageName appendString:@".png"];
    }
    return [UIImage imageNamed:imageName];
}


NSString *LocalizedString(NSString* key)
{
    return NSLocalizedString(key, key);
}

NSString* PathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

NSString* PathForDocumentsResource(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (!documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString *PathForCacheResource(NSString *relativePath){
    NSString *cachesPath = nil;
    cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    if (relativePath) {
        cachesPath = [cachesPath stringByAppendingPathComponent:relativePath];
    }
    return cachesPath;
}

NSString * convertTimeWithSecondes(double seconds)
{
    int m = seconds/60;
    int s = (int)seconds%60;
    int h = m/60;
    m = m%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}
/**
 *weiliang 2013.10.17 添加
 */
NSString * convertTimeWithSecondes_cutoffHour(double seconds)
{
    int m = seconds/60;
    int s = (int)seconds%60;
    int h = m/60;
    m = m%60;
    if(h == 0)
    {
        return [NSString stringWithFormat:@"%02d:%02d",m,s];
    }
    else
        return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}
CGFloat caculateTimeBlock (void (^block)(void)){
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
}
@implementation Universal

+ (CGSize)calTextSize:(NSString*)str
          limiteWidth:(CGFloat)width
                 font:(UIFont*)font
{
    CGSize size = CGSizeZero;
    if (str && [str length]>0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            size = [str sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByCharWrapping];
        }else{
            size = [str boundingRectWithSize:CGSizeMake(width, 0) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
        }
    }
    return size;
}

@end
