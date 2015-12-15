//
//  NCTabBar.m
//  CompanyApp
//
//  Created by chenlei on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCTabBar.h"
#import <QuartzCore/QuartzCore.h>

#import "Universal.h"

#define kTabBarBorderLineColor RGBS(217)

@interface NCTabBarItem()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *markView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation NCTabBarItem

@end

@interface NCTabBar(){
    CGFloat backgroundWidth;
    CGFloat leftMargin;
    CGFloat itemLayerWidth;
    CGFloat itemTopMargin;
    CGFloat iconBetweenWidth;
}
@property (nonatomic, strong) NSMutableArray *items;//NCTabBarItem 数组
@property (nonatomic, strong) NSMutableArray *markItemArray;//显示小红点的数组
//@property (nonatomic, strong) UIImageView *selectView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

//@interface TDTabBar ()
//@property (nonatomic, strong) NSDate *lastClickDate;
//@end

@implementation NCTabBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _items = [NSMutableArray array];
        _markItemArray = [NSMutableArray array];
        itemTopMargin = 6;
        for (int i = 0; i < 4; i++) {
            NCTabBarItem *item = [[NCTabBarItem alloc] init];
            switch (i) {
                case 0:
                    item.title = @"首页";
//                    item.image = Image(@"ic_tab_home");
//                    item.selectedImage = Image(@"ic_tab_home_select");
                    break;
                case 1:
                    item.title = @"人才库";
//                    item.image = Image(@"ic_tab_rss");
//                    item.selectedImage = Image(@"ic_tab_rss_select");
                    break;
                case 2:
                    item.title = @"消息";
//                    item.image = Image(@"ic_tab_discover");
//                    item.selectedImage = Image(@"ic_tab_discover_select");
                    break;
                case 3:
                    item.title = @"我";
   
                    break;
                default:
                    break;
            }
            [_items addObject:item];
            [_markItemArray addObject:[NSMutableDictionary dictionary]];
        }
        self.userInteractionEnabled = YES;
        [self reload];
    }
    return self;
}

- (void)setBlurTintColor:(UIColor *)blurTintColor{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && _effectView) {
        [_effectView setBackgroundColor:blurTintColor];
    }
}
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    [self reload];
//}

- (void)reload {
    backgroundWidth = CGRectGetWidth(self.frame);
    leftMargin =  MARGIN + (self.width - backgroundWidth) / 2;
    
    [self initBar];
    [self setSelectIndex:_selectIndex];
    
}

-(void)initBar {
    
    //ios8毛玻璃效果
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _effectView.frame = CGRectMake(0, 0, [UIScreen width]+10, self.height);
        _effectView.alpha = 1.0;
        [self addSubview:_effectView];
    }
    
    if (_items && [_items count]>0) {
        itemLayerWidth = backgroundWidth/self.items.count;
        iconBetweenWidth = (backgroundWidth - itemLayerWidth*self.items.count)/(self.items.count-1);
    }
    
    for (int i = 0; i < self.items.count; i++) {
        NCTabBarItem *item = self.items[i];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:item.image];//设置图片图层
        iconView.layer.cornerRadius = 0.5;
        
        iconView.frame = CGRectMake((itemLayerWidth+iconBetweenWidth) * i + (itemLayerWidth-item.image.size.width)/2.0,
                                    4,
                                    item.image.size.width,
                                    item.image.size.height);
        item.iconView = iconView;
        
        [self addSubview:item.iconView];
        
        UILabel *infoLab = [[UILabel alloc] init];
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.textAlignment = NSTextAlignmentCenter;
        infoLab.font = [UIFont systemFontOfSize:11];
        infoLab.textColor = RGBS(127);
        infoLab.text = item.title;
        
        infoLab.frame = CGRectMake((itemLayerWidth+iconBetweenWidth) * i ,
                                   iconView.bottom,
                                   itemLayerWidth,
                                   12);
        item.titleLabel = infoLab;
        
        [self addSubview:item.titleLabel];
        
        UIImage* maskImage = nil;
        if (i == kSubcribeIndex || i == kMyIndex || i == kDicoveryIndex) {//只允许订阅、发现、我的存在红点
            maskImage = Image(@"home_firstLauchIco.png");
        }
        
        UIImageView *markView = [[UIImageView alloc] initWithImage:maskImage];//设置图片图层
        //        markView.layer.cornerRadius = 0.5;
        markView.layer.opacity = 1;
        markView.backgroundColor = [UIColor clearColor];
        markView.frame = CGRectMake(iconView.right ,
                                    ((i == kSubcribeIndex || i == kMyIndex || i == kDicoveryIndex) ? itemTopMargin : 2),
                                    maskImage.size.width,
                                    maskImage.size.height
                                    );
        markView.hidden = YES;
        item.markView = markView;
        
        [self addSubview:item.markView];
    }
    //4.0需要，给tabbar顶端增加一条灰线。采用了增加frame border 1像素的方式实现
    self.layer.borderColor = kTabBarBorderLineColor.CGColor;
    self.layer.borderWidth = 0.5f;
    CGRect orginFrame = self.frame;
    self.frame = CGRectMake(orginFrame.origin.x - 1, orginFrame.origin.y, orginFrame.size.width + 2, orginFrame.size.height + 1);
}
- (NSString *)getMarkKeyForIndex:(NSInteger)index{
    switch (index) {
//        case 0:
//            return kMarkCenterTabOne;
//            break;
//        case 1:
//            return kMarkCenterTabTwo;
//            break;
//        case 2:
//            return kMarkCenterTabThree;
//            break;
//        case 3:
//            return kMarkCenterTabFour;
//            break;
//        case 4:
//            return kMarkCenterTabFive;
//            break;
            
        default:
            return nil;
            break;
    }
}

- (void)loadConfig{
}
- (void)setShowMark:(BOOL)show atIndex:(NSInteger)index {
    NCTabBarItem *item = self.items[index];
    item.markView.hidden = !show;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show forKey:[self getMarkKeyForIndex:index]];
    [userDefaults synchronize];
}

- (void)setShowMark:(BOOL)show atIndex:(NSInteger)index forKey:(NSString *)key
{
    NCTabBarItem *item = self.items[index];
    NSMutableDictionary *showDic = [self.markItemArray objectAtSafeIndex:index];
    if (!showDic) {
        showDic = [NSMutableDictionary dictionary];
    }
    
    [showDic setObject:@(show) forKey:key];
    [self.markItemArray replaceObjectAtIndex:index withObject:showDic];
    
    NSArray *showValues = [showDic allValues];
    BOOL shouldHidden = YES;
    
    for (NSInteger i = 0; i < [showValues count]; i++) {
        shouldHidden = shouldHidden && ([[showValues objectAtIndex:i] isEqual: @(NO)]);
    }
    
    item.markView.hidden = shouldHidden;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:item.markView.hidden forKey:[self getMarkKeyForIndex:index]];
    [userDefaults synchronize];
}

- (void)setSelectIndex:(NSInteger)index {
    if (index >= 0) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
        //		self.selectView.frame = CGRectMake(leftMargin + itemLayerWidth * index, 0, itemLayerWidth, TAB_BAR_HEIGHT);
        NCTabBarItem *selectIndexItem = self.items[self.selectIndex];
        selectIndexItem.iconView.image = selectIndexItem.image;
        selectIndexItem.titleLabel.textColor = RGBS(127);
        
        NCTabBarItem *indexItem = self.items[index];
        indexItem.iconView.image = indexItem.selectedImage;
        indexItem.iconView.layer.opacity = 1.0f;
        indexItem.titleLabel.textColor = RGB(255, 102, 0);
        
        [CATransaction commit];
    }
    _selectIndex = index;
}

#pragma mark lazyload
//- (UIImageView *)selectView
//{
//    if (!_selectView) { // 设置默认选中阴影
//        _selectView = [[UIImageView alloc] initWithImage:Image(@"tab_clicked.png")];
////		UIImage *image = Image(@"tab_clicked.png");
////		_selectLayer.contents = (__bridge id)image.CGImage;
//        //_selectLayer.backgroundColor = [UIColor TDOrange].CGColor;
//        //_selectLayer.shadowColor = [UIColor blackColor].CGColor;
//        //_selectLayer.shadowOffset = CGSizeMake(0, -1);
//
//        //_selectLayer.cornerRadius = 5.0f;
//    }
//    return _selectView;
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    if (self.lastClickDate) {
    //        NSTimeInterval laststamp = [self.lastClickDate timeIntervalSince1970];
    //        NSTimeInterval nowstamp = [[NSDate date] timeIntervalSince1970];
    //        if ((nowstamp - laststamp)<0.1) {
    //            return;
    //        }
    //    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x > leftMargin && (point.x < leftMargin + backgroundWidth - MARGIN)) {
        NSInteger index = (point.x - leftMargin) / (itemLayerWidth + iconBetweenWidth);
        [self userSelectIndex:index];
        
    }
}

- (void)userSelectIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSelectIndex:)]) {
        BOOL mayI = [self.delegate willSelectIndex:index];
        if (!mayI) {
            return;
        }
    }
    _lastSelected = self.selectIndex;
    [self setSelectIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [self.delegate didSelectIndex:index];
        //            self.lastClickDate = [NSDate date];
    }
    /**
     *  点击下载的时候不删除小圆点
     */
    if (_lastSelected != index && index != kMyIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[self getMarkKeyForIndex:index] object:[self getMarkKeyForIndex:index]];
    }
}

#pragma mark- notification


@end

