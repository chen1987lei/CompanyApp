//
//  Marco.h
//  Youku
//
//  Created by 光 李 on 5/16/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//
/*土豆1.0版本的viewframe去除顶部titlebar和下方tabbar高度*/
//#define TD_VIEW_FRAME CGRectMake(0.0, self.titleBarHeight, self.view.frame.size.width, self.view.frame.size.height - self.titleBarHeight)
#define TD_VIEW_FRAME CGRectMake(0.0, self.titleBarHeight, self.view.width, self.view.height - self.titleBarHeight)

//去除performSelector may cause a leak because its selector is unknown警告的宏http://stackoverflow.com/questions/11895287/performselector-arc-warning

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/*常用的宏*/

#define StatusBar_Height 20

#define kSINGLE_LINE_WIDTH  (1.0f/[UIScreen mainScreen].scale)
#define kSINGLE_LINE_ADJUST_OFFSET ((1.0f/[UIScreen mainScreen].scale)/2)
//to use: CGRect(x-kSINGLE_LINE_ADJUST_OFFSET,0,kSINGLE_LINE_WIDTH,100)

//日志

#define DLog( s, ... )     { if([[TDConfig sharedInstance] isNeedLog]) { NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ); } }
#define DLogRect(r)     { if([[TDConfig sharedInstance] isNeedLog]) { NSLog( @"<%p %@:(%d)> (%.1fx%.1f)-(%.1fx%.1f)", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, r.origin.x, r.origin.y, r.size.width, r.size.height); } }
#define DVoidLog(s, ... )  {if([[TDConfig sharedInstance] isNeedLog]){NSLog( @"<%@ :(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] );  }}

//#define DLogPlace(x) DLog(@"**********\n*%@\n*%s\n*%i\n*loadData failed\n**********",NSStringFromClass([self class]),__FUNCTION__,__LINE__)

//内存
#define RELEASE_SAFELY(p) { [p release]; p = nil; }

//角度变换
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//=================================================================================================
//Notification Event Name
//=================================================================================================

//土豆视频类型
//typedef NS_ENUM(NSInteger, TDVideoType) {
//	TDAlbumVideoType,  //剧集类视频
//	TDUGCVideoType     //单视频.
//};

#define TDALBUM_VIDEO_TYPE @"video"
#define TDUGC_VIDEO_TYPE @"item"
//弱引用宏定义
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

typedef NS_ENUM(NSInteger, TDImageType) {
	HorizonImage,   //横图
	VerticalImage  //竖图
};
//是否是推荐播客
typedef NS_ENUM(NSInteger, TDPotcastType) {
    PotcastChannelNo  =0,       //非推荐播客
	PotcastChannelYes =1,       //推荐播客，但无最新视频
	PotcastChannelYesLut =2     //推荐播客，且有最新视频
};

#define VERTICAL_IMAGE_TYPE @"vertical"
#define HORIZON_IMAGE_TYPE @"horizon"

#define TDAPP ((TDAppDelegate*) [UIApplication sharedApplication].delegate)

#define kAlertSpaceLimit (500.0 * 1024 * 1024)
#import <sys/sysctl.h>

static inline NSString* iphone_device_info(){
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1699)";
    
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return nil;
}

static inline CGSize mainScreenSize()
{
    CGSize screenSize =  [UIScreen mainScreen].bounds.size;
    
    //iOS8 返回bounds 宽高已经随着旋转变化，这里加入了判断代码，长边必然为高，短边必然为宽
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.height;
    
    CGFloat deviceHeight = MAX(width, height);
    CGFloat deviceWidth = MIN(width, height);
    
    return CGSizeMake(deviceWidth, deviceHeight);
}

static inline BOOL is_iPod()
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    if ([platform rangeOfString:@"iPod"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

static inline BOOL is_Simulator() {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

static inline BOOL is_iphone4()
{
    return mainScreenSize().height == 480;
}

static inline BOOL is_iphone5()
{
    if (!is_Simulator()) {
        return (mainScreenSize().height == 568) && ![iphone_device_info() isEqualToString:@"iPhone 6 (A1549/A1586)"];
    }else{
        return mainScreenSize().height == 568;
    }
}

static inline BOOL is_iphone6()
{
    if (!is_Simulator()) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            CGSize size = [[UIScreen mainScreen] nativeBounds].size;
            float width = MIN(size.width, size.height);
            NSString *deviceInfo = iphone_device_info();
            if ((width == 750 && ([deviceInfo isEqualToString:@"iPhone 6 (A1549/A1586)"] || [deviceInfo isEqualToString:@"iPhone 6s (A1633/A1688/A1700)"]))){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    }else {
        
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        float width = MIN(size.width, size.height);
        if (width == 750) {
            return YES;
        }else{
            return NO;
        }
        
    }
}

static inline BOOL is_iphone6Plus()
{
    if (!is_Simulator()) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            CGSize size = [[UIScreen mainScreen] nativeBounds].size;
            float width = MIN(size.width, size.height);
            NSString *deviceInfo = iphone_device_info();
            if (width == 1080 && ([deviceInfo hasPrefix:@"iPhone 6 Plus"]||[deviceInfo hasPrefix:@"iPhone 6s Plus"])) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    }else {
        
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        float width = MIN(size.width, size.height);
        if (width == 1242) {
            return YES;
        }else{
            return NO;
        }
        
    }
}

static inline BOOL is_iphone6S()
{
    if (!is_Simulator()) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            CGSize size = [[UIScreen mainScreen] nativeBounds].size;
            float width = MIN(size.width, size.height);
            if (width == 750 && [iphone_device_info() isEqualToString:@"iPhone 6s (A1633/A1688/A1700)"]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    }else {
        
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        float width = MIN(size.width, size.height);
        if (width == 750) {
            return YES;
        }else{
            return NO;
        }
        
    }
}

static inline BOOL is_iphone6SPlus()
{
    if (!is_Simulator()) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            CGSize size = [[UIScreen mainScreen] nativeBounds].size;
            float width = MIN(size.width, size.height);
            if (width == 1080 && [iphone_device_info() isEqualToString:@"iPhone 6s Plus (A1634/A1687/A1699)"]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    }else {
        
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        float width = MIN(size.width, size.height);
        if (width == 1242) {
            return YES;
        }else{
            return NO;
        }
        
    }
}



static inline BOOL is_iphone_scale_mode()
{
    CGSize size = [[UIScreen mainScreen] currentMode].size;
    float width = MIN(size.width, size.height);
    if (is_iphone6() && width == 640) {
        return YES;
    }else if(is_iphone6Plus() && width == 1125){
        return YES;
    }else if(is_iphone6S() && width == 640){
        return YES;
    }else if(is_iphone6SPlus() && width == 1125){
        return YES;
    }else {
        return NO;
    }
}
/**
 *  不包括放大模式
 *
 *  @return
 */
static inline BOOL is_iphone6OrIs_iphone6Plus(){
    //暂时添加6s/plus
    if ((is_iphone6()||is_iphone6Plus()||is_iphone6S()||is_iphone6SPlus())&&!is_iphone_scale_mode()) {
        return YES;
    }
    else{
        return NO;
    }
}
/**
 *  包括放大模式
 *
 *  @return 
 */
static inline BOOL is_iphone6OrIs_iphone6PlusIncludScaleMode(){
    if (is_iphone6()||is_iphone6Plus()) {
        return YES;
    }
    else{
        return NO;
    }
}

