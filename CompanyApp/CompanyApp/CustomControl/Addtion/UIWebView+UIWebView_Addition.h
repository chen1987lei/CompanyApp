//
//  UIWebView+UIWebView_Addition.h
//  Tudou
//
//  Created by Li Chao on 13-6-24.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (UIWebView_Addition)<UIAlertViewDelegate>
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end
