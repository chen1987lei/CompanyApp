//
//  TDBlurView.m
//  Tudou
//
//  Created by CL7RNEC on 13-8-31.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDBlurView.h"
#import <QuartzCore/QuartzCore.h>
@interface TDBlurView()

@property (nonatomic, strong) UINavigationBar *toolbar;
@property (nonatomic, strong) CALayer *blurLayer;

@end

@implementation TDBlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        [self initView];
    }
    return self;
}

/**
 *  初始化毛玻璃效果
 */
-(void)initView{
    if (MY_IOS_VERSION_7) {
        _toolbar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.userInteractionEnabled=NO;
        //需要移除子视图中高度为1的iamge黑边框
        for (UIView *views in _toolbar.subviews) {
            for (UIView *viewImg in views.subviews) {
                if ([viewImg isKindOfClass:[UIImageView class]]) {
                    [viewImg removeFromSuperview];
                }
            }
        }
        _blurLayer = [CALayer layer];
        _blurLayer.frame = CGRectMake(0, 0, _toolbar.frame.size.width, _toolbar.frame.size.height);
        //[_blurLayer setBackgroundColor:[UIColor clearColor].CGColor];
        [_toolbar.layer addSublayer:_blurLayer];
        [self addSubview:_toolbar];
    }
}

- (void)setBlurTintColor:(UIColor *)blurTintColor {
    if (MY_IOS_VERSION_7) {
        _toolbar.barStyle=UIBarStyleDefault;
        [_blurLayer setBackgroundColor:blurTintColor.CGColor];
        [_blurLayer setNeedsDisplay];
    }
    else{
        [self setBackgroundColor:blurTintColor];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _blurLayer.frame = CGRectMake(0, 0, _toolbar.frame.size.width, _toolbar.frame.size.height);
}
-(void)setBlurTintBlackColor{
    if (MY_IOS_VERSION_7) {
        _toolbar.barStyle=UIBarStyleBlack;
    }
    else{
        self.backgroundColor=RGBS(0);
    }
}

- (void)setBlurBarFrame:(CGRect)frame{
    [self setFrame:frame];
    if (MY_IOS_VERSION_7) {
        [_toolbar setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

-(void)removeBlurView{
    if (MY_IOS_VERSION_7) {
        [_toolbar removeFromSuperview];
    }
}
@end
