//
//  WKWebView+JavascriptRun.m
//  Tudou
//
//  Created by lihang on 15/9/25.
//  Copyright © 2015年 Youku.com inc. All rights reserved.
//

#import "WKWebView+JavascriptRun.h"

@implementation WKWebView (JavascriptRun)

- (void)getWebPageUrl:(void (^)(NSString* result, NSError* error))completion
{
    NSString *jsString = @"document.location.href";
    [self evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError * _Nullable error) {
        if (completion) {
            completion(result,error);
        }
    }];
}

- (void)getWebPageTitle:(void (^)(NSString* result, NSError* error))completion
{
    NSString *jsString = @"document.title";
    [self evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError * _Nullable error) {
        if (completion) {
            completion(result,error);
        }
    }];
}

- (void)getTudouH5description:(void (^)(NSString* result, NSError* error))completion
{
    NSString *jsString = @"var array=document.getElementsByTagName('meta');for(var i=0;i<array.length;i++){if(array[i]['name']=='description'){array[i]['content']}}";
//    NSString *jsString2 = @"var array=document.getElementsByTagName('meta');for(var i=0;i<array.length;i++){if(array[i]['name']=='Description'){array[i]['content']}}";
    [self evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError * _Nullable error) {
        if (completion) {
            completion(result,error);
        }
    }];
}

- (void)getTudouH5sharePhotoUrl:(void (^)(NSString* result, NSError* error))completion
{
    NSString *jsString = @"document.getElementById('wxImg')['src']";
    [self evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError * _Nullable error) {
        if (completion) {
            completion(result,error);
        }
    }];
}

- (void)hasVideo:(void (^)(BOOL hasVideo, NSError* error))completion
{
    NSString *jsString = @"document.documentElement.getElementsByTagName(\"video\").length";
    [self evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError * _Nullable error) {
        BOOL hasVideoTag = [result integerValue] >= 1? YES : NO;
        if (completion) {
            completion(hasVideoTag,error);
        }
    }];
}

- (void)playVideo:(void (^)(NSError* error))completion
{
    NSString *jsString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
    [self evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)runOrientationchange:(void (^)(NSError* error))completion
{
    NSString *jsString = @"orientationchange()";
    [self evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)resignFocus:(void (^)(NSError* error))completion
{
    NSString *jsString = @"document.activeElement.blur()";
    [self evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}


@end
