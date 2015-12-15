//
//  UIWebView+JavascriptRun.m
//  Tudou
//
//  Created by lihang on 15/6/25.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "UIWebView+JavascriptRun.h"

@implementation UIWebView (JavascriptRun)

- (NSString*)getWebPageUrl
{
    NSString *jsString = @"document.location.href";
    return [self stringByEvaluatingJavaScriptFromString:jsString];
}

- (NSString*)getWebPageTitle
{
    NSString *jsString = @"document.title";
    return [self stringByEvaluatingJavaScriptFromString:jsString];
}

- (NSString*)getTudouH5description
{
    NSString *jsString = @"var array=document.getElementsByTagName('meta');for(var i=0;i<array.length;i++){if(array[i]['name']=='description'){array[i]['content']}}";
    NSString *jsString2 = @"var array=document.getElementsByTagName('meta');for(var i=0;i<array.length;i++){if(array[i]['name']=='Description'){array[i]['content']}}";
    NSString *resultString = [self stringByEvaluatingJavaScriptFromString:jsString];
    if (![resultString isNotBlankString]) {
        resultString = [self stringByEvaluatingJavaScriptFromString:jsString2];
    }
    return resultString;
}

- (NSString*)getTudouH5sharePhotoUrl
{
    NSString *jsString = @"document.getElementById('wxImg')['src']";
    NSString *resultString = [self stringByEvaluatingJavaScriptFromString:jsString];
    return resultString;
}

- (BOOL)hasVideo
{
    NSString *hasVideoTestString = @"document.documentElement.getElementsByTagName(\"video\").length";
    NSString *result = [self stringByEvaluatingJavaScriptFromString:hasVideoTestString];
    BOOL hasVideoTag = [result integerValue] >= 1? YES : NO;
    return hasVideoTag;
}

- (void)playVideo
{
    NSString *jsString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)runOrientationchange
{
    NSString *jsString = @"orientationchange()";
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)resignFocus
{
    NSString *jsString = @"document.activeElement.blur()";
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

@end
