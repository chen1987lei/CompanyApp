//
//  TDPageControl.h
//  Tudou
//  自定义page控件
//  Created by CL7RNEC on 15/4/3.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDPageControl : UIView

@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0.
@property(nonatomic) NSInteger lastPage;

@end
