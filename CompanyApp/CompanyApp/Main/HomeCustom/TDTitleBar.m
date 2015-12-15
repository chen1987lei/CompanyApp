//
//  TDTitleBar.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-20.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDTitleBar.h"

int sSTATUS_BAR_HEIGHT = 0;     //状态栏，在init方法中调用
int sVIEW_TOP_MARGIN = 0;       //上边的距离
int sSTATUS_BAR_MARGIN_TOP=20;  //非ios7下是20
static NSInteger itemFontSize = 15;

#define topOffset ((sSTATUS_BAR_HEIGHT) + (44 - (TitleBar_Btn_Width) ) / 2.0) //上边距. 排除顶部20

@interface TDTitleBar ()
{
    BOOL isShowLeftTitle;//左侧item显示文字
    UIView *_bottomlineview;
}
@property(nonatomic,strong)NSMutableArray *rightItemArray;
@property(nonatomic,strong)UIView *centerView;
@end

@implementation TDTitleBar

#pragma mark- life cycle
- (id)init
{
    //如果是ios7，则调整状态栏和上边距的值
    if (MY_IOS_VERSION_7) {
        sSTATUS_BAR_HEIGHT=20;
        sVIEW_TOP_MARGIN=10;
        sSTATUS_BAR_MARGIN_TOP=0;
    }
    self.rightItemArray = [NSMutableArray array];
    return [self initWithFrame:CGRectMake(0, 0, screenSize().width, TitleBar_Height)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        
        UIColor *titlebarColor = RGBA(255, 255, 255, 0.96);
        if (MY_IOS_VERSION_7) {
            [self setBlurTintColor:titlebarColor];
        }else{
            self.backgroundColor = titlebarColor;
        }
        
        _titleLabel =  [TDRightImageLabel rightImageLabel:CGRectMake(0, 0, 1, 1) onImage:nil offImage:nil title:nil];//fix 22071
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setRightImageSize:CGSizeMake(14.0, 7)];
        [_titleLabel setPaddingWidth:-4];
        [_titleLabel setOn:NO];
        [_titleLabel setEnableShowImage:NO]; //default disable show image.
        
        _titleLabel.font = [UIFont systemFontOfSize:18]; //16
        _titleLabel.leftTitleLabel.textColor = RGBS(61);
        [self addSubview:_titleLabel];
        
        
        _leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftItem.titleLabel.font = [UIFont systemFontOfSize:itemFontSize];
        [_leftItem addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftItem];
        _leftItem.hidden = YES;
        
        float lineheight = 1.5;
        _bottomlineview = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-lineheight, self.width, lineheight)];
        _bottomlineview.backgroundColor = RGBA(255, 102, 0, 1.0);
        [self addSubview:_bottomlineview];
        
        isShowLeftTitle = NO;
        
        CGFloat leftItemWidth;
        if (_isShowLeftLogo) {
            leftItemWidth = TitleBar_Btn_String_Width;
        }else{
            leftItemWidth = TitleBar_Btn_Width;
        }

        _leftItem.frame = CGRectMake(isShowLeftTitle?5:0, sVIEW_TOP_MARGIN, leftItemWidth, TitleBar_Height);
        
        //add right items
        for (int i = 1; i <= [self.rightItemArray count]; i++) {
            UIButton *rightButton = [self.rightItemArray objectAtSafeIndex:i - 1];
            rightButton.frame = CGRectMake(self.width - (i*TitleBar_Btn_Width), topOffset, TitleBar_Btn_Width, TitleBar_Btn_Width);
            [self addSubview:rightButton];
        }

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, screenSize().width, TitleBar_Height);
	CGFloat leftItemWidth;
    if (_isShowLeftLogo) {
        leftItemWidth = TitleBar_Btn_String_Width;
    }else{
        leftItemWidth = TitleBar_Btn_Width;
    }
    for (int i = 1; i <= [self.rightItemArray count]; i++) {
        UIButton *rightButton = [self.rightItemArray objectAtSafeIndex:i];
        rightButton.frame = CGRectMake(self.width - (i+1)*TitleBar_Btn_Width, topOffset, TitleBar_Btn_Width, TitleBar_Btn_Width);
    }
    
    CGFloat leftMargin = 0;
    
    if (!_leftItem.isHidden) {
        leftMargin = leftItemWidth;
    }else {
        leftMargin = 10;
    }
    

    if(!self.cancelLayout){
        int titleWidth = CGRectGetWidth(self.frame) - leftMargin * 2;
        _titleLabel.frame = CGRectMake(leftMargin + 10, sVIEW_TOP_MARGIN, titleWidth - 20, TitleBar_Height);
        [_titleLabel setNeedsDisplay];
        [_titleLabel refreshRect];//fix 22071
    }
    

}

#pragma mark - method public

- (void)addRightItemWithButton:(UIButton *)button
{
    [self.rightItemArray addObject:button];
}
- (void)addRightItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = [self.rightItemArray count];
    [button addTarget:self action:@selector(onRightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    button.hidden = YES;
    
    button.frame = CGRectMake(self.width - ([self.rightItemArray count] + 1)*TitleBar_Btn_Width, topOffset, TitleBar_Btn_Width, TitleBar_Btn_Width);
    
    [self addSubview:button];
    
    [self.rightItemArray addObject:button];
}

- (void)setRightItemImage:(UIImage *)image selectedImage:(UIImage *)selectedImage atIndex:(NSInteger)index
{
    UIButton *button = [self.rightItemArray objectAtSafeIndex:index];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
        button.frame = CGRectMake(self.width - (index+1)*TitleBar_Btn_Width, topOffset, TitleBar_Btn_Width, TitleBar_Btn_Width);
        [self.rightItemArray addObject:button];
        [self addSubview:button];
    }
    button.hidden = NO;
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onRightItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)getRightItemWithIndex:(NSInteger)index
{
    return [self.rightItemArray objectAtSafeIndex:index];
}

- (void) showTitleRightImage:(BOOL)show {
    
    [_titleLabel setEnableShowImage:show];
}

#pragma mark- action method

- (void)onRightItemClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(titleBar:didClickRightItemAtIndex:)]) {
        [self.delegate titleBar:self didClickRightItemAtIndex:button.tag];
    }
}

- (void)onRightTitleClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(titleBardidClickRightTitle:)]) {
        [self.delegate titleBardidClickRightTitle:self];
    }
}

- (void)clickLeft
{
    if([_delegate respondsToSelector:_leftSelector])
    {
        SuppressPerformSelectorLeakWarning([_delegate performSelector:_leftSelector withObject:_leftItem]);
    }
}

#pragma mark- others

- (void)configButton:(UIButton *)button title:(NSString *)title{
    button.hidden = NO;
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)configButton:(UIButton *)button image:(UIImage *)image hightLight:(UIImage *)highLightImage{
    button.hidden = NO;
    [button setImage:image forState:UIControlStateNormal];
    if (highLightImage) {
        [button setImage:highLightImage forState:UIControlStateHighlighted];
    }
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self && self.shouldIgnoreAction) return nil;
    else return hitView;
}

#pragma mark- setter

- (void)setLeftTitle:(NSString *)title withSelector:(SEL)selector{
    isShowLeftTitle = YES;
    [self configButton:_leftItem title:title];
    [self setLeftSelector:selector];
}
- (void)setRightTitle:(NSString *)title{
    UIButton *rightButton = [self.rightItemArray objectAtSafeIndex:0];
    if (!rightButton) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:itemFontSize];
        [rightButton setTitleColor:RGBS(61) forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(self.width - TitleBar_Btn_Width-10, topOffset, TitleBar_Btn_Width, TitleBar_Btn_Width);
        [self.rightItemArray addObject:rightButton];
        [self addSubview:rightButton];
    }
    rightButton.hidden = NO;
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onRightTitleClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLeft:(UIImage *)image highLight:(UIImage *)highlightImage withSelector:(SEL)selector{
    [self configButton:_leftItem image:image hightLight:highlightImage];
    [self setLeftSelector:selector];
}

- (void)setLeftSelector:(SEL)selector
{
    _leftSelector = selector;
    _leftItem.userInteractionEnabled = !(selector == nil);
}


-(void)setBottomLineViewHidden:(BOOL)ishidden
{
    _bottomlineview.hidden = ishidden;
}

- (void)setTitle:(NSString *) title;
{
    _titleLabel.title = title;
}
- (void)setLeftItemTitle:(NSString*)title {
    _leftItem.hidden = NO;
    [_leftItem setTitle:title forState:UIControlStateNormal];
    _leftItem.titleLabel.font = [UIFont systemFontOfSize:19.0];
    _leftItem.userInteractionEnabled = NO;
    _leftItem.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)setLeftItemContent:(id)item
{
    _leftItem.hidden = NO;
    if([item isKindOfClass:[NSString class]])
    {
        [_leftItem setTitle:item forState:UIControlStateNormal];
    }
    else if([item isKindOfClass:[UIImage class]])
    {
        [_leftItem setImage:item forState:UIControlStateNormal];
    }
}

-(void)setTitleBarColor:(UIColor *)color{
    if (MY_IOS_VERSION_7) {
        [self setBlurTintColor:color];
    }else{
        self.backgroundColor = color;
    }
}

-(void)setTitleBarTudouColor
{
    if (MY_IOS_VERSION_7) {
        [self setBlurTintColor:kBlurTintColoriOS7];
    }else{
        self.backgroundColor = kBlurTintColor;
    }
    _titleLabel.leftTitleLabel.textColor = [UIColor whiteColor];
    
}

-(void)setTitleColor:(UIColor *)color{
    _titleLabel.leftTitleLabel.textColor = color;
}

-(void)setLeftLogView:(UIView *)logView
{
    _leftLogView = logView;
    [self addSubview:logView];
    logView.left = 10;
    logView.top = (44-logView.height)/2 + (MY_IOS_VERSION_7?20:0);
}
-(void)setCenterView:(UIView *)centerView;
{
    [self addSubview:centerView];
    _centerView = centerView;
    centerView.top = (44-centerView.height)/2 + (MY_IOS_VERSION_7?20:0);
}
-(void)setRightView:(UIView *)rightView;
{
    [self addSubview:rightView];
    rightView.right = self.width - 10;
    rightView.top = (44-rightView.height)/2 + (MY_IOS_VERSION_7?20:0);
}

@end

