//
//  TDBaseBigCellView.m
//  Tudou
//  大卡片
//  Created by CL7RNEC on 15/4/1.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseBigCellView.h"

#define kIMAGE_CORNER_WIDTH  32
#define kIMAGE_CORNER_HEIGHT 17
#define kIMAGE_BOTTOM_HEIGHT 163

@interface TDBaseBigCellView()

@end

@implementation TDBaseBigCellView
#pragma mark - life cycle
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView{
    WS(weakSelf)
    //大图
    _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kBIG_WIDTH, kBIG_HEIGHT-kBIG_MARGIN_Y)];
    _imgView.backgroundColor=[UIColor clearColor];
    [self addSubview:_imgView];
    //默认图
    self.defaultImg=Image(@"choutibanner");
    //角标
    _imgConner=[[UIImageView alloc] init];
    [self addSubview:_imgConner];
    _imgConner.backgroundColor=[UIColor clearColor];
    [_imgConner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kIMAGE_CORNER_WIDTH));
        make.height.equalTo(@(kIMAGE_CORNER_HEIGHT));
        make.top.equalTo(@0);
        make.right.equalTo(@0);
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
    _imgBottom.image=Image(@"yaofeng_toutu");
    _imgBottom.backgroundColor=[UIColor clearColor];
    _imgBottom.hidden=YES;
    //腰封副标题
    _bottomSubTitleLab=[[UILabel alloc] init];
    [self addSubview:_bottomSubTitleLab];
    [_bottomSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.left.equalTo(@10);
        make.bottom.equalTo(weakSelf.imgView).offset(-10);
    }];
    _bottomSubTitleLab.backgroundColor=[UIColor clearColor];
    _bottomSubTitleLab.textColor=RGBS(204);
    _bottomSubTitleLab.textAlignment=NSTextAlignmentLeft;
    _bottomSubTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?14:12];
    _bottomSubTitleLab.hidden=YES;
    //腰封标题
    _bottomTitleLab=[[UILabel alloc] init];
    [self addSubview:_bottomTitleLab];
    [_bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.left.equalTo(weakSelf.bottomSubTitleLab);
        make.baseline.equalTo(weakSelf.bottomSubTitleLab.mas_top).offset(-8);
    }];
    _bottomTitleLab.backgroundColor=[UIColor clearColor];
    _bottomTitleLab.textColor=RGBS(255);
    _bottomTitleLab.textAlignment=NSTextAlignmentLeft;
    _bottomTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?17:15];
    _bottomTitleLab.hidden=YES;
}

- (void)refreshCellView{
    _imgBottom.hidden=YES;
    _bottomTitleLab.hidden=YES;
    _bottomSubTitleLab.hidden=YES;
    WS(weakSelf)
    
//    [_imgView td_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:self.defaultImg diskCachePath:CachePath_HomePage completed:^(UIImage *image, NSError *error, TDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            [weakSelf animationWithImage];
//            weakSelf.imgView.image = image;
//            weakSelf.bottomTitleLab.text=self.imgBottomTitle;
//            weakSelf.bottomSubTitleLab.text=self.imgBottomSubTitle;
//            weakSelf.imgBottom.hidden=NO;
//            weakSelf.bottomTitleLab.hidden=NO;
//            weakSelf.bottomSubTitleLab.hidden=NO;
//        }
//    }];
//    [_imgConner td_setImageWithURL:[NSURL URLWithString:self.imgCornerUrl] diskCachePath:CachePath_HomePage];

}

@end
