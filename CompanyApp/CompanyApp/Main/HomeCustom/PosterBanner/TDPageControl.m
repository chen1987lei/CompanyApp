//
//  TDPageControl.m
//  Tudou
//
//  Created by CL7RNEC on 15/4/3.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDPageControl.h"

@implementation TDPageControl

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _lastPage=-1;
    }
    return self;
}

-(void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages=numberOfPages;
    [self removeAllSubviews];
    for (int i=0;i<numberOfPages;i++) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*i, 0, 5, 5)];
        view.layer.cornerRadius=3;
        view.backgroundColor=RGBS(130);
        [self addSubview:view];
    }
}

-(void)setCurrentPage:(NSInteger)currentPage{
    _currentPage=currentPage;
    if ([self.subviews hasIndex:_currentPage]) {
        //当前page
        UIView *view=(UIView *)self.subviews[_currentPage];
        view.backgroundColor=RGB(255, 102, 0);
    }
    if (_currentPage!=_lastPage&&[self.subviews hasIndex:_lastPage]) {
        //上一个page
        UIView *view=(UIView *)self.subviews[_lastPage];
        view.backgroundColor=RGBS(130);
    }
    _lastPage=_currentPage;
}

@end
