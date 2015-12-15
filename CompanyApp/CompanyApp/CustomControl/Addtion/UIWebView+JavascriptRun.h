//
//  UIWebView+JavascriptRun.h
//  Tudou
//
//  Created by lihang on 15/6/25.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavascriptRun)

//获取页面地址
- (NSString*)getWebPageUrl;

//获取页面标题
- (NSString*)getWebPageTitle;

//获取主站h5 desctiption标签
- (NSString*)getTudouH5description;

//获取主站h5 分享图片地址
- (NSString*)getTudouH5sharePhotoUrl;

//判断页面是否有video标签
- (BOOL)hasVideo;

//播放video
- (void)playVideo;

//调用主站h5 orientationchange事件
- (void)runOrientationchange;

//移除h5焦点(关闭键盘用)
- (void)resignFocus;

@end
