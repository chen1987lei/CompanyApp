//
//  TDPosterSearchBarView.m
//  Tudou
//
//  Created by CL7RNEC on 15/4/3.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDPosterSearchBarView.h"

@interface TDPosterSearchBarView()

@property (nonatomic,strong) UIImageView *imgText;
@property (nonatomic,strong) UILabel *labText;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *iconUrl;

@end


@implementation TDPosterSearchBarView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.opaque=YES;
        self.layer.shadowColor=RGBA(0, 0, 0, 0.3).CGColor;
        self.layer.shadowOffset=CGSizeMake(0, 0);
        self.layer.shadowRadius=1;
        self.layer.shadowOpacity = YES;
        UIView *view=[[UIView alloc] initWithFrame:self.bounds];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 2;
        view.backgroundColor = RGBS(255);
        view.layer.borderColor=RGBS(255).CGColor;
        view.layer.borderWidth=1;
        [self addSubview:view];
        [self createText];
    }
    return self;
}

-(void)createText{
    WS(weakSelf)
    if (!_imgText) {
        _imgText=[[UIImageView alloc] init];
        [self addSubview:_imgText];
        [_imgText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@14);
            make.height.equalTo(@14);
            make.left.equalTo(@10);
            make.centerY.equalTo(weakSelf);
        }];
    }
    if (!_labText) {
        _labText=[[UILabel alloc] init];
        [self addSubview:_labText];
        [_labText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.imgText);
            make.left.equalTo(weakSelf.imgText.mas_right).offset(8);
        }];
        _labText.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?15:14];
        _labText.textColor=RGBS(128);
    }
}

-(void)refreshSearchBarWithText:(NSString *)text withIconUrl:(NSString *)iconUrl{
    _text=text;
    _iconUrl=iconUrl;
    _imgText.image=Image(@"ic_home_search");
    _labText.text=_text;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_delegate&&[_delegate respondsToSelector:@selector(searchBarDidClick)]) {
        [_delegate searchBarDidClick];
    }
}

@end
