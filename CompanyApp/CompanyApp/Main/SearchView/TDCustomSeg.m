//
//  TDCustomSeg.m
//  Tudou
//
//  Created by 李 福庆 on 13-6-28.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDCustomSeg.h"
#define kItemTagOffset 1000
@interface TDCustomSeg()
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemSpace;
@property (nonatomic, assign) CGFloat layerHeight;

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *itemBtns;

@property (nonatomic, strong) UIButton *selectedItem;
@property (nonatomic, strong) UIImageView *selectView;

@property (nonatomic, assign) NSUInteger selectIndex;
@end

@implementation TDCustomSeg

- (id)initWithItemArray:(NSArray *)itemArray{
    _itemWidth = 90;
    _itemHeight = 40;
    _layerHeight = 3;
    _itemSpace = 25;
    CGRect rect = CGRectMake(0, 0, [itemArray count] * _itemWidth + ([itemArray count] - 1) * _itemSpace, _itemHeight);
    self = [super initWithFrame:rect];
    if (self) {
        
        _itemArray = [NSMutableArray arrayWithArray:itemArray];
        _itemBtns = [NSMutableArray array];
        
        [self initButtons];
        
    }
    return self;
}

- (id)initWithItemArray:(NSArray *)itemArray
              withFrame:(CGRect)frame{
    _itemWidth = frame.size.width;
    _itemHeight = frame.size.height;
    _layerHeight = 3;
    _itemSpace = 25;
    CGRect rect = CGRectMake(0, 0, [itemArray count] * _itemWidth + ([itemArray count] - 1) * _itemSpace, _itemHeight);
    self = [super initWithFrame:rect];
    if (self) {
        
        _itemArray = [NSMutableArray arrayWithArray:itemArray];
        _itemBtns = [NSMutableArray array];

        [self initButtons];
        
    }
    return self;
}

- (void)setItemTitle:(NSString *)title ForIndex:(NSUInteger)index{
    if (index < [_itemBtns count]) {
        UIButton *item = _itemBtns[index];
        [item setTitle:title forState:UIControlStateNormal];
    }
}

- (void)didSelectIndex:(NSInteger)index{
    _selectIndex = index;
    [self layout];
}

- (void)initButtons{
    
    if (![[self subviews] containsObject:self.selectView]) {
        [self addSubview:self.selectView];
    }
    
    for (int i = 0; i < [_itemArray count]; i++) {
        NSString *item = _itemArray[i];
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.tag = kItemTagOffset + i;
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [itemBtn setTitleColor:RGBS(60) forState:UIControlStateNormal];
        [itemBtn setTitle:item forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_itemBtns addObject:itemBtn];
    }
    
    for (int i = 0; i < [_itemBtns count]; i++) {
        UIButton *aBtn = _itemBtns[i];
        if (![[self subviews] containsObject:aBtn]) {
            [self addSubview:aBtn];            
        }
    }
}

- (void)layout {
    for (int i = 0; i < [_itemBtns count]; i++) {
        UIButton *aBtn = _itemBtns[i];
        aBtn.frame = CGRectMake(i * (_itemWidth + _itemSpace), (self.height - _itemHeight ) / 2, _itemWidth, _itemHeight);
    }
    UIButton *btn = _itemBtns[_selectIndex];
    self.frame = CGRectMake(self.left, self.top, ((UIButton *)[_itemBtns lastObject]).right, _itemHeight);
    self.selectView.frame = CGRectMake(btn.left, (btn.height - _layerHeight) / 1 - 1, btn.width, _layerHeight);
    [self itemTouch:btn];
}

- (void)setSelectedItem:(UIButton *)selectedItem{
    
    __weak typeof(self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.selectView.frame = CGRectMake(selectedItem.left, (selectedItem.height - _layerHeight) / 1 - 1, selectedItem.width, _layerHeight);
    }];
    
	if (_selectedItem) {
        //未选择的
        [_selectedItem setTitleColor:RGBS(60) forState:UIControlStateNormal];
        
	}
    //被选择的
    [selectedItem setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
    
	_selectedItem = selectedItem;

}

- (void)setSelectViewHide:(BOOL)hide{
    _selectView.hidden=hide;
}

- (UIImageView *)selectView{
    if (!_selectView) { // 设置默认选中阴影
        _selectView = [[UIImageView alloc] initWithImage:nil];
        _selectView.backgroundColor = [UIColor TDOrange];
//        _selectView.layer.cornerRadius = 12;
        _selectView.userInteractionEnabled = YES;
    }
    return _selectView;
}

- (void)itemTouch:(UIButton *)sender{
    if (sender == _selectedItem) {
        return;
    }
    [self setSelectedItem:sender];
    if([self.delegate respondsToSelector:@selector(clickButtonAtIndex:)])
    {
        [self.delegate clickButtonAtIndex:(sender.tag - kItemTagOffset)];
    }
}
- (void)setItemWidth:(CGFloat)width
{
    _itemWidth = width;
    CGRect rect = CGRectMake(0, 0, [_itemArray count] * _itemWidth + ([_itemArray count] - 1) * _itemSpace, _itemHeight);
    self.frame = rect;
 
    _itemBtns = [NSMutableArray array];
    [self initButtons];
}
@end
