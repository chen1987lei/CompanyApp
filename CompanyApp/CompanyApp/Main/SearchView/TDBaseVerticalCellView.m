//
//  TDBaseVerticalCellView.m
//  Tudou
//
//  Created by CL7RNEC on 15/4/1.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseVerticalCellView.h"

#define kIMAGE_HEIGHT (kVERTICAL_HEIGHT-57)
#define kIMAGE_CORNER_WIDTH  32
#define kIMAGE_CORNER_HEIGHT 17
#define kIMAGE_BOTTOM_HEIGHT 30

@interface TDBaseVerticalCellView()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *imgBottom;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subTitleLab;
@property (nonatomic,strong) UILabel *bottomTitleLab;
@property (nonatomic,strong) UILabel *bottomSubTitleLab;

@end

@implementation TDBaseVerticalCellView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView{
    WS(weakSelf)
    //横图
    _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, kIMAGE_HEIGHT)];
    _imgView.backgroundColor=[UIColor clearColor];
    [self addSubview:_imgView];
    //默认图
    self.defaultImg=Image(@"Animation_default_map");
    //角标
    _imgConner=[[UIImageView alloc] init];
    [self addSubview:_imgConner];
    _imgConner.backgroundColor=[UIColor clearColor];
    [_imgConner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kIMAGE_CORNER_WIDTH));
        make.height.equalTo(@(kIMAGE_CORNER_HEIGHT));
        make.top.equalTo(@0);
        make.right.equalTo(weakSelf.imgView);
    }];
    //腰封
    _imgBottom=[[UIImageView alloc] init];
    [self addSubview:_imgBottom];
    [_imgBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.imgView);
        make.height.equalTo(@(kIMAGE_BOTTOM_HEIGHT));
        make.bottom.equalTo(weakSelf.imgView);
        make.left.equalTo(weakSelf.imgView);
    }];
    _imgBottom.image=Image(@"bg_home_1yaofeng");
    _imgBottom.backgroundColor=[UIColor clearColor];
    _imgBottom.hidden=YES;
    //腰封标题
    _bottomTitleLab=[[UILabel alloc] init];
    [self addSubview:_bottomTitleLab];
    [_bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(-10);
        make.baseline.equalTo(weakSelf.imgView.mas_bottom).offset(-5);
        make.left.equalTo(weakSelf).offset(5);
        make.right.equalTo(weakSelf).offset(-5);
    }];
    _bottomTitleLab.backgroundColor=[UIColor clearColor];
    _bottomTitleLab.textColor=RGBS(255);
    _bottomTitleLab.textAlignment=NSTextAlignmentLeft;
    _bottomTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?13:11];
    _bottomTitleLab.hidden=YES;
    //腰封副标题
    _bottomSubTitleLab=[[UILabel alloc] init];
    [self addSubview:_bottomSubTitleLab];
    [_bottomSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.left.equalTo(@5);
        make.bottom.equalTo(weakSelf.imgView).offset(-5);
    }];
    _bottomSubTitleLab.backgroundColor=[UIColor clearColor];
    _bottomSubTitleLab.textColor=[UIColor TDOrange];
    _bottomSubTitleLab.textAlignment=NSTextAlignmentLeft;
    _bottomSubTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?13:11];
    _bottomSubTitleLab.hidden=YES;
    //标题
    _titleLab=[[UILabel alloc] init];
    [self addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.top.equalTo(weakSelf.imgView.mas_bottom).offset(8);
        make.left.equalTo(weakSelf.imgView);
    }];
    _titleLab.backgroundColor=[UIColor clearColor];
    _titleLab.textColor=RGBS(60);
    _titleLab.textAlignment=NSTextAlignmentLeft;
    _titleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?14:13];
    //副标题
    _subTitleLab=[[UILabel alloc] init];
    [self addSubview:_subTitleLab];
    [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.top.equalTo(weakSelf.titleLab.mas_baseline).offset(6);
        make.left.equalTo(weakSelf.imgView);
    }];
    _subTitleLab.backgroundColor=[UIColor clearColor];
    _subTitleLab.textColor=RGBS(153);
    _subTitleLab.textAlignment=NSTextAlignmentLeft;
    _subTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?12:11];
}

- (void)refreshCellView{
    _imgBottom.hidden=YES;
    _bottomTitleLab.hidden=YES;
    _bottomSubTitleLab.hidden=YES;
    WS(weakSelf)
    /*
    [_imgView td_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:self.defaultImg diskCachePath:CachePath_HomePage completed:^(UIImage *image, NSError *error, TDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [weakSelf animationWithImage];
            weakSelf.imgView.image = image;
            weakSelf.bottomTitleLab.text=self.imgBottomTitle;
            weakSelf.imgBottom.hidden=NO;
            weakSelf.bottomTitleLab.hidden=NO;
            if ([self.imgBottomSubTitle isNotBlankString]) {
                weakSelf.bottomSubTitleLab.text=self.imgBottomSubTitle;
                weakSelf.bottomSubTitleLab.hidden=NO;
            }
        }
    }];
    [_imgConner td_setImageWithURL:[NSURL URLWithString:self.imgCornerUrl] diskCachePath:CachePath_HomePage];
     */
    _titleLab.text=self.title;
    _subTitleLab.text=self.subTitle;
}

@end
