//
//  NCUserLicenseView.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCUserLicenseView.h"

@interface NCUserLicenseView ()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UITextView *_contentView;
    
    UIButton *_readButton;
    UILabel *_readLabel;
    UIImageView *_readImageView;
}
@end
@implementation NCUserLicenseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)initSubviews
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom+5, self.width, 20)];
    
    float contentheight = self.height - 50 -50;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, _subtitleLabel.bottom+5, self.width, contentheight)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.bottom+5, kScreenWidth, 50)];
    UILabel *label1 = [Utils labelWithFrame:CGRectMake(35.f, 0.f, 70.f, 21.f) withTitle:@"阅读并同意相关服务协议" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
    [footerView addSubview:label1];
    
    UIButton *servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    servicesBtn.frame = CGRectMake(110.f, 0.f, 40.f, 21.f);
//    [servicesBtn setTitle:@"服务协议" forState:UIControlStateNormal];
    [servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    servicesBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [servicesBtn addTarget:self action:@selector(servicebuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:servicesBtn];
}

-(void)servicebuttonClicked
{
    
}

-(void)showTitle:(NSString *)title subTitle:(NSString *)substr
      andContent:(NSString *)content;
{
    
}
@end
