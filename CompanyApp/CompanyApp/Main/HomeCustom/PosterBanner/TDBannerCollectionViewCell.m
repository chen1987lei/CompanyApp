//
//  TDBannerCollectionViewCell.m
//  Tudou
//
//  Created by chenlei on 15/7/15.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBannerCollectionViewCell.h"

@implementation TDBannerCollectionViewCell
{
//     UILabel *_titleLabel;
    
//     UILabel *_bottomSubTitleLab;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self addSubview:imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.textColor=RGBS(255);
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?17:15];
        [self addSubview:_titleLabel];
        
        _bottomTitleLabel=[[UILabel alloc] init];
        [self addSubview:_bottomTitleLabel];
        
        _bottomTitleLabel.backgroundColor=[UIColor clearColor];
        _bottomTitleLabel.textColor=RGBS(204);
        _bottomTitleLabel.textAlignment=NSTextAlignmentLeft;
        _bottomTitleLabel.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?14:12];
        
        
        WS(weakSelf)
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.height.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
        }];
        
        [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.left.equalTo(@10);
            make.bottom.equalTo(weakSelf).offset(-10);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.left.equalTo(@10);
            make.baseline.equalTo(_bottomTitleLabel.mas_top).offset(-8);
        }];
        

    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
    
}

- (void)setBottomTitle:(NSString *)bottomTitle
{
    _bottomTitleLabel.text = [NSString stringWithFormat:@"%@", bottomTitle];
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    _imageView.frame = self.bounds;
//    
//    CGFloat titleLabelW = self.width;
//    CGFloat titleLabelH = 30;
//    CGFloat titleLabelX = 0;
//    CGFloat titleLabelY = self.height - titleLabelH*2 -20;
//    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
//    _titleLabel.hidden = !_titleLabel.text;
//    
//    _bottomSubTitleLab.frame = CGRectMake(titleLabelX, titleLabelY+20, titleLabelW, titleLabelH);
//    _bottomSubTitleLab.hidden = !_bottomSubTitleLab.text;
//}

@end
