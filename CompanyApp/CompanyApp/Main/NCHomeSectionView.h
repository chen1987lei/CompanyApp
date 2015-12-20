//
//  NCHomeSectionView.h
//  CompanyApp
//
//  Created by chenlei on 15/12/15.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCHomeSectionView;
@protocol NCHomeSectionViewDelegate <NSObject>

-(void)homeSectionLeftButtonAction:(NCHomeSectionView *)secview;
-(void)homeSectionFisrtButtonAction:(NCHomeSectionView *)secview;
-(void)homeSectionSecondButtonAction:(NCHomeSectionView *)secview;

-(void)homeSectionMoreButtonAction:(NCHomeSectionView *)secview;
@end
@interface NCHomeSectionView : UIView
{
    
}
@property(nonatomic,assign ) id<NCHomeSectionViewDelegate> actiondelegate;

@property(nonatomic,strong) UIButton *leftImageButton;
@property(nonatomic,strong) UIButton *firstButton;
@property(nonatomic,strong) UIButton *secondButton;
@property(nonatomic,strong) UIButton *moreButton;
@property(nonatomic,assign) NSInteger rowIndex;

-(instancetype) initWithFrame:(CGRect)frame;

@end
