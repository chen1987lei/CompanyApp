//
//  TDSearchBar.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-27.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDSearchBar.h"
#import "TDBlurView.h"
#import "TDTitleBar.h"

@interface TDSearchBar ()
{
    UIImageView*        searchTypeIco;
}
@end
@implementation TDSearchBar
#define kSearchTypeButtonSize  CGSizeMake(50,31)
#define kCancelButtonSize      CGSizeMake(40,31)
#define kMarginWidth 9
@dynamic text;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
 
        //毛玻璃效果
        TDBlurView* mao = [[TDBlurView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), TitleBar_Height + 3)];
        
        if (MY_IOS_VERSION_7) {
            sSTATUS_BAR_HEIGHT=20;
            sVIEW_TOP_MARGIN=10;
            sSTATUS_BAR_MARGIN_TOP=0;
            [mao setBlurTintColor:RGBS(253)];
        }else{
            mao.backgroundColor = RGBS(253);
        }
        [self addSubview:mao];
 
        self.clipsToBounds = YES;
 
        _searchTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchTypeButton.backgroundColor = [UIColor clearColor];
        _searchTypeButton.frame = CGRectMake(0, 0, kSearchTypeButtonSize.width, kSearchTypeButtonSize.height);
        [_searchTypeButton addTarget:self action:@selector(searchTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchTypeButton setTitleColor:RGBS(60) forState:UIControlStateNormal];
        _searchTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 15);
        _searchTypeButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_searchTypeButton setTitle:@"视频" forState:UIControlStateNormal];
        [self addSubview:_searchTypeButton];
 
        UIImage* ico = Image(@"searchdropbox_sanjiao");
        searchTypeIco = [[UIImageView alloc] initWithFrame:CGRectMake(kSearchTypeButtonSize.width - ico.size.width - 6, (kSearchTypeButtonSize.height - ico.size.height)/2, ico.size.width,  ico.size.height)];
        searchTypeIco.image = ico;
        searchTypeIco.backgroundColor = [UIColor clearColor];
        [_searchTypeButton addSubview:searchTypeIco];
        
//        UIButton * searchIcon = [[UIButton alloc] initWithFrame:CGRectMake(_searchTypeButton.width + kMarginWidth, 0, Image(@"search_icon").size.width, Image(@"search_icon").size.height)];
//        [searchIcon setImage:Image(@"search_icon") forState:UIControlStateNormal];
//        searchIcon.userInteractionEnabled = NO;
 
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kMarginWidth, (int)(frame.size.height - kCancelButtonSize.height)/2+sVIEW_TOP_MARGIN, frame.size.width - kCancelButtonSize.width - kMarginWidth, kCancelButtonSize.height)];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textField.delegate = self;
        _textField.autocorrectionType=UITextAutocorrectionTypeNo;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.enablesReturnKeyAutomatically = YES;

        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = _searchTypeButton;
        _textField.leftView.width += 0;
        _textField.backgroundColor = RGBS(235);
        _textField.layer.cornerRadius = 2;
        _textField.font = [UIFont systemFontOfSize:14.f];
 
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _cancelButton.frame = CGRectMake(self.width - kCancelButtonSize.width, (int)(self.height - kCancelButtonSize.height)/2+sVIEW_TOP_MARGIN, kCancelButtonSize.width, kCancelButtonSize.height);
        [_cancelButton setTitleColor:RGBS(86) forState:UIControlStateNormal];
        [_cancelButton setTitle:LocalizedString(@"取消") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.showsTouchWhenHighlighted = NO;
        [self addSubview:_cancelButton];
        [self addSubview:_textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:_textField];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text
{
    _textField.text = text;
}

- (NSString *)text
{
    return _textField.text;
}
- (void)setSearchTypeIco:(BOOL)isExpand
{
    if (isExpand) {
        searchTypeIco.image = Image(@"searchdropbox_sanjiao_up");
    }
    else
    {
        searchTypeIco.image = Image(@"searchdropbox_sanjiao");
    }
}

- (void)setSearchTypeButtonFrame:(BOOL)big
{
    UIImage* ico = Image(@"searchdropbox_sanjiao");
    if (big) {
        searchTypeIco.frame = CGRectMake(kSearchTypeButtonSize.width + 8 - ico.size.width - 6, (kSearchTypeButtonSize.height - ico.size.height)/2, ico.size.width,  ico.size.height);
        _searchTypeButton.width = kSearchTypeButtonSize.width + 8;
    }else{
        searchTypeIco.frame = CGRectMake(kSearchTypeButtonSize.width - ico.size.width - 6, (kSearchTypeButtonSize.height - ico.size.height)/2, ico.size.width,  ico.size.height);
        _searchTypeButton.width = kSearchTypeButtonSize.width;
    }
}

- (void)searchTypeButtonClick:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTypeButtonClick:)]) {
        [self.delegate searchTypeButtonClick:self];
    }
}

#pragma mark button 点击事件
- (void)cancelButtonClicked:(UIButton *)sender
{
    [_textField resignFirstResponder];
    if([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}
 
- (void)textDidChanged:(NSNotification *)sender
{
    if([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
       [self.delegate searchBar:self textDidChange:_textField.text];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

@end
