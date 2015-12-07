//
//  WKWebView+JavascriptRun.h
//  Tudou
//
//  Created by lihang on 15/9/25.
//  Copyright © 2015年 Youku.com inc. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (JavascriptRun)

//获取页面地址
- (void)getWebPageUrl:(void (^)(NSString* result, NSError* error))completion;

//获取页面标题
- (void)getWebPageTitle:(void (^)(NSString* result, NSError* error))completion;

//获取主站h5 desctiption标签
- (void)getTudouH5description:(void (^)(NSString* result, NSError* error))completion;

//获取主站h5 分享图片地址
- (void)getTudouH5sharePhotoUrl:(void (^)(NSString* result, NSError* error))completion;

//判断页面是否有video标签
- (void)hasVideo:(void (^)(BOOL hasVideo, NSError* error))completion;

//播放video
- (void)playVideo:(void (^)(NSError* error))completion;

//调用主站h5 orientationchange事件
- (void)runOrientationchange:(void (^)(NSError* error))completion;

//移除h5焦点(关闭键盘用)
- (void)resignFocus:(void (^)(NSError* error))completion;

@end
