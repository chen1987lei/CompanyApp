//
//  TDRightImageLabel.h
//  Tudou
//
//  Created by yujinliang on 13-4-15.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDRightImageLabel : UILabel

@property (nonatomic, assign) CGSize rightImageSize;
@property (nonatomic, assign) CGFloat paddingWidth;
@property (nonatomic, strong) UIImage* onImage;
@property (nonatomic, strong) UIImage* offImage;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) BOOL enableShowImage;
@property (nonatomic, strong) UILabel* leftTitleLabel;
//---
+ (id) rightImageLabel:(CGRect)frame onImage:(UIImage*)on offImage:(UIImage*)off title:(NSString*)title ;
- (BOOL)toggle;

- (void)refreshRect;

@end
