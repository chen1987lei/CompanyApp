//
//  TDSearchBar.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-27.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KSEARCHBAR_HEIGHT 44

//typedef NS_ENUM(NSInteger, searchBarType) {
//    searchBar_default,//默认显示 返回按钮，二维码扫描
//    searchBar_textFiledBegin,//激活 输入框，显示 取消按钮
//    searchBar_searchResult,//搜索结果页，显示 返回按钮
//};

@class TDSearchBar;

@protocol TDSearchBarDelegate<NSObject>
@optional
- (void)searchBarTextDidBeginEditing:(TDSearchBar *)searchBar;

- (void)searchBarTextDidEndEditing:(TDSearchBar *)searchBar;

- (void)searchBarSearchButtonClicked:(TDSearchBar *)searchBar;

- (void)searchBarCancelButtonClicked:(TDSearchBar *) searchBar;

- (BOOL)searchBar:(TDSearchBar *)searchBar textDidChange:(NSString *)searchText;
 
- (void)searchTypeButtonClick:(TDSearchBar*)sender;
@end

/*!
 @class
 @abstract 自定义的SearchBar
 @discussion 只是UI控件没有程序逻辑
*/
@interface TDSearchBar : UIView<UITextFieldDelegate>

@property (nonatomic,assign   ) id<TDSearchBarDelegate> delegate;
@property (nonatomic,readonly ) UITextField             * textField;
@property (nonatomic,readwrite) NSString                * text;
@property (nonatomic,readonly ) UIButton                * cancelButton;
@property (nonatomic,readonly ) UIButton                * searchTypeButton;

/**
 *  设置下拉菜单的三角
 *
 *  @param rect
 */
- (void)setSearchTypeIco:(BOOL)isExpand;

- (void)setSearchTypeButtonFrame:(BOOL)big;
@end
