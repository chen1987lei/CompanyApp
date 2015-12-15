//
//  EmptyView.m
//  Tudou
//
//  Created by 李福庆 on 13-2-14.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "EmptyView.h"
@interface EmptyView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *loginButton;
@end
@implementation EmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor TDMainBackgroundColor];
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 20)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, (self.width-80), 40)];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:16.f];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor TDFailedFontColor];

        [_backView addSubview:_imageView];
        [_backView addSubview:_label];
        [self addSubview:_backView];
    }
    return self;
}


- (id)initOtherStyleWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor TDMainBackgroundColor];
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _imageView = [[UIImageView alloc] init];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, (self.width-80), 40)];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:16.f];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor TDFailedFontColor];
        _label.numberOfLines = 0;
    
        [_backView addSubview:_imageView];
        [_backView addSubview:_label];
        [self addSubview:_backView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat cellHeight = self.emptyIcon.size.height + 15 + _label.height;
    
    _backView.frame = CGRectMake(0, (self.height - 250 ) / 2, self.width, 250);
    float left = (_backView.width - self.emptyIcon.size.width) / 2;
    float top = (_backView.height - cellHeight-20) / 2;
    
    CGRect iconRect = CGRectMake(left, top, self.emptyIcon.size.width, self.emptyIcon.size.height);
    _imageView.frame = iconRect;
    
    _label.top = _imageView.bottom + 15;
    
    if (_loginButton) {
        _loginButton.frame = CGRectMake(0, _label.bottom + 20, 100, 42);
        _loginButton.centerX = self.centerX;
    }
}
- (void)showLoginButton{
    self.loginButton.hidden = NO;
    [self setNeedsLayout];
}
- (void)hideLoginButton{
    self.loginButton.hidden = YES;
    [self setNeedsLayout];
}
- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin;
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        //这里暂时只在iPad里面使用.
//        [_loginButton setBackgroundImage:[UIImage imageWithTudouOrangeImage] forState:UIControlStateNormal];
        [_loginButton setTitle:LocalizedString(@"马上登录") forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginDidClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.hidden = YES;
        [_backView addSubview:_loginButton];
    }
    return _loginButton;
    
}
- (void)setEmptyIcon:(UIImage *)emptyIcon{
    _emptyIcon = emptyIcon;
    _imageView.image = _emptyIcon;
    [self setNeedsLayout];
}

- (void)setEmptyString:(NSString *)emptyString {
    _emptyString = emptyString;
    _label.text = _emptyString;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(emptyViewDidClick:)]) {
        [_delegate emptyViewDidClick:self];
    }
}
- (void)loginDidClick{
    if ([_delegate respondsToSelector:@selector(loginButtonDidClick:)]) {
        [_delegate loginButtonDidClick:self];
    }
}
@end

