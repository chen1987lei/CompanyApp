//
//  NCHomeSectionView.m
//  CompanyApp
//
//  Created by chenlei on 15/12/15.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCHomeSectionView.h"

@interface NCHomeSectionView()
{
    
}


@end
@implementation NCHomeSectionView


#define kLeftButtonWidth  (kScreenWidth-20 - 4)/3
#define kLeftButtonHeight 100

#define kFirstButtonWidth kLeftButtonWidth
#define kFirstButtonHeight 48

#define ktopOffset 0
#define kSepLineWidth 2
#define kSepLineTop 2

#define kMoreButtonWidth 2*(kScreenWidth-20 - 4)/3

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseView];
        
        [self.leftImageButton addTarget:self action:@selector(leftImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.firstButton addTarget:self action:@selector(firstButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.secondButton addTarget:self action:@selector(secondButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

-(void)leftImageButtonAction
{
    if ([_actiondelegate respondsToSelector:@selector(homeSectionLeftButtonAction:)]) {
        [_actiondelegate homeSectionLeftButtonAction:self];
    }
}

-(void)firstButtonAction
{
    if ([_actiondelegate respondsToSelector:@selector(homeSectionFisrtButtonAction:)]) {
        [_actiondelegate homeSectionFisrtButtonAction:self];
    }
}

-(void)secondButtonAction
{
    if ([_actiondelegate respondsToSelector:@selector(homeSectionSecondButtonAction:)]) {
        [_actiondelegate homeSectionSecondButtonAction:self];
    }
}

-(void)moreButtonAction
{
    if ([_actiondelegate respondsToSelector:@selector(homeSectionMoreButtonAction:)]) {
        [_actiondelegate homeSectionMoreButtonAction:self];
    }
}

-(UIButton *)leftImageButton
{
    if (_leftImageButton == nil) {
        _leftImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ktopOffset, kLeftButtonWidth, kLeftButtonHeight)];
        

        _leftImageButton.backgroundColor = [UIColor brownColor];
        _leftImageButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    
    return _leftImageButton;
}


-(UIButton *)firstButton
{
    if (_firstButton == nil) {
        _firstButton = [[UIButton alloc] initWithFrame:CGRectMake(_leftImageButton.right+kSepLineWidth, ktopOffset, kLeftButtonWidth, kFirstButtonHeight)];        _firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
              _firstButton.backgroundColor = [UIColor brownColor];
        _firstButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    
    return _firstButton;
}


-(UIButton *)secondButton
{
    if (_secondButton == nil) {
        _secondButton = [[UIButton alloc] initWithFrame:CGRectMake(self.firstButton.right +kSepLineWidth, self.firstButton.top, self.firstButton.width, self.firstButton.height)];
        _secondButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _secondButton.backgroundColor = [UIColor brownColor];
    }
    
    return _secondButton;
}

-(UIButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.firstButton.left, self.firstButton.bottom+kSepLineTop, kMoreButtonWidth, self.firstButton.height)];
        
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _moreButton.backgroundColor = [UIColor brownColor];
    }
    
    return _moreButton;
}


-(void)initBaseView
{
    [self addSubview:self.leftImageButton];
      [self addSubview:self.firstButton];
      [self addSubview:self.secondButton];
      [self addSubview:self.moreButton];
}

@end
