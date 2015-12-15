//
//  TDFailedView.m
//  Tudou
//
//  Created by zhang jiangshan on 13-1-9.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDFailedView.h"

@interface TDFailedView()
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UILabel * label;
@property(nonatomic,strong) UIButton * refreshButton;
@property(nonatomic,strong) UIView * contentView;
@end

@implementation TDFailedView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];

        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        self.contentView.tag = 336;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        self.imageView  = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width,20)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = RGBS(135);
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];

        
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.refreshButton.frame = CGRectMake(0, 0, 95, 35);
        self.refreshButton.hidden = YES;
        [self.refreshButton addTarget:self.delegate action:@selector(failedViewClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.refreshButton setTitle:@"重试一下" forState:UIControlStateNormal];
        [self.refreshButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.refreshButton setTitleColor:RGBS(102) forState:UIControlStateNormal];
        [self.refreshButton setBackgroundColor:[UIColor whiteColor]];
        self.refreshButton.layer.borderColor = RGBS(204).CGColor;
        self.refreshButton.layer.borderWidth=is_iphone6Plus()?0.6:0.5;
        self.refreshButton.layer.cornerRadius=1.5;
        [self.contentView addSubview:self.refreshButton];
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setType:(TDFailedViewType)type
{
    _type = type;
    BOOL hasFreshButton = NO;
    
    UIImage *failedImage = Image(@"wifi");
    
    NSString *failedText = @"";
    
    NSString *buttonText = @"";
    //失败图片和lable的间隔
    float space1 = 0;
    //lable和按钮的间隔
    float space2 = 0;
    
    switch (type) {
        case TDFailedView_NOWifi:
            failedImage = Image(@"wifi");
            space1 = 14;
            space2 = 15;
            hasFreshButton = YES;
            failedText = @"网络不给力,检查一下吧";
            buttonText = @"点击重试";
            break;
        case TDFailedView_NetWorkError:
            failedImage = Image(@"empty");
            space1 = 14;
            space2 = 15;
            hasFreshButton = YES;
            failedText = @"抱歉,刚才走神啦";
            buttonText = @"重新加载";
            break;
        case TDFailedView_NoData:
            failedImage = Image(@"empty");
            failedText = self.noDataDes ? self.noDataDes:@"抱歉,暂无数据";
            break;
        case TDFailedView_UploadNoData:
            failedImage = Image(@"Upload");
            space1 = 14;
            hasFreshButton = NO;
            failedText = @"这里空空的,来点自己的";
            break;
        case TDFailedView_HistoryNoData:
            failedImage = Image(@"viewing-history");
            space1 = 14;
            hasFreshButton = NO;
            failedText = @"没有发现你的足迹";
            break;
        case TDFailedView_NoLogin:
            failedImage = Image(@"news");
            space1 = 14;
            space2 = 15;
            hasFreshButton = YES;
            failedText = @"登录才能查看哦";
            buttonText = @"登录";
            break;
        case TDFailedView_NoFav:
            failedImage = Image(@"collect");
            break;
        case TDFailedView_NoFavVideo:
            failedImage = Image(@"no_video");
            break;
        case TDFailedView_NoDownload:
            failedImage = Image(@"cache");
            break;
        case TDFailedView_ErrorWithoutImage:
            failedImage = nil;
            space2 = 17;
            hasFreshButton = YES;
            failedText = self.noDataDes ? self.noDataDes:@"抱歉,刚才走神啦";
            buttonText = @"重新加载";
            self.label.textColor = RGBS(187);
            [self.refreshButton setBackgroundColor:[UIColor clearColor]];
            self.refreshButton.layer.borderColor = RGB(255, 102, 0).CGColor;
            [self.refreshButton setTitleColor:RGB(255, 102, 0) forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    self.imageView.image = failedImage;
    self.imageView.top = 0;
    self.imageView.size = failedImage.size;
    self.imageView.centerX = self.contentView.centerX;
    
    self.label.top = self.imageView.bottom + space1;
    if ([failedText length] > 0) {
        self.label.text = failedText;
        self.label.hidden = NO;
    }else{
        self.label.hidden = YES;
    }
    
    if (hasFreshButton) {
        self.refreshButton.hidden = NO;
        [self.refreshButton setTitle:buttonText forState:UIControlStateNormal];
        self.refreshButton.top = self.label.bottom + space2;
        self.contentView.height = self.refreshButton.bottom;
    }else {
        self.refreshButton.hidden = YES;
        self.contentView.height = self.label.bottom;
    }
    
    self.refreshButton.centerX = self.contentView.centerX;
    
    self.contentView.top = (self.height-self.contentView.height)/2;
    
    switch (type) {
        case TDFailedView_NOWifi:
            self.contentView.top = (self.height-self.contentView.height)/2 - 15;
            break;
        case TDFailedView_NetWorkError:
            self.contentView.top = (self.height-self.contentView.height)/2 - 15;
            break;
        case TDFailedView_NoData:
             self.contentView.top = (self.height-self.contentView.height)/2 - 15;
            break;
        case TDFailedView_UploadNoData:
            self.contentView.top = 0.146*self.height; //0.253*self.height;
            break;
        case TDFailedView_HistoryNoData:
            self.contentView.top = 0.315*self.height;
            break;
        case TDFailedView_NoLogin:
            self.contentView.top = 0.228*self.height;
            break;
        case TDFailedView_NoFav:
            self.contentView.top = 0.146*self.height;
            break;
        case TDFailedView_NoFavVideo:
            self.contentView.top = 0.146*self.height;
            break;
        case TDFailedView_NoDownload:
            self.contentView.top = 0.126*self.height;
            break;
            
        default:
            break;
    }
    
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.contentView.frame = frame;
    self.label.frame = CGRectMake(0,0,frame.size.width,20);
    
    if (self.type != TDFailedView_None) {
        self.type = _type;
    }
}


-(void)setNoDataDes:(NSString *)noDataDes
{
    _noDataDes = noDataDes;
    if (self.type == TDFailedView_NoData || self.type == TDFailedView_ErrorWithoutImage) {
        self.type = _type;
    }
}
-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}
@end
