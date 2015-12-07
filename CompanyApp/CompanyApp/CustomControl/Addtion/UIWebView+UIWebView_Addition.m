//
//  UIWebView+UIWebView_Addition.m
//  Tudou
//
//  Created by Li Chao on 13-6-24.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "UIWebView+UIWebView_Addition.h"

@implementation UIWebView (UIWebView_Addition)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [customAlert show];
    
}
static BOOL diagStat = NO;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame
{
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [confirmDiag show];
    while (confirmDiag.hidden == NO && confirmDiag.superview != nil)
        
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    
    return diagStat;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        diagStat = NO;
    }
    else if (buttonIndex == 1)
    {
        diagStat = YES;
    }
}
@end
