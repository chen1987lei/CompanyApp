//
//  EmptyView.h
//  Tudou
//
//  Created by 李福庆 on 13-2-14.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmptyView;
@protocol EmptyViewDelegate <NSObject>
@optional
- (void)emptyViewDidClick:(EmptyView *)emptyView;
- (void)loginButtonDidClick:(EmptyView *)emptyView;
@end

@interface EmptyView : UIView
@property (nonatomic, strong) UIImage   *emptyIcon;
@property (nonatomic, copy)   NSString  *emptyString;
@property (nonatomic, strong) UILabel   *label;
@property (nonatomic, weak) id<EmptyViewDelegate> delegate;
- (void)showLoginButton DEPRECATED_ATTRIBUTE;
- (void)hideLoginButton DEPRECATED_ATTRIBUTE;
- (id)initOtherStyleWithFrame:(CGRect)frame;
@end