//
//  NCLibraryHomeView.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCLibraryHomeView.h"

#define MENUHEIHT 40
@implementation NCLibraryHomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
if (self) {
// Initialization code
//        [self commInit];
}
return self;
}

#pragma mark UI初始化
-(void)commInit{
    NSMutableArray *tmp = [NSMutableArray new];
    for (NSString *title in _menuItemArray) {
        NSDictionary *dict = @{NOMALKEY: @"normal.png",
                               HEIGHTKEY:@"helight.png",
                               TITLEKEY: title,
                               TITLEWIDTH:[NSNumber numberWithFloat:100]
                               };
        [tmp addObject:dict];
    }
    NSArray *vButtonItemArray = tmp;
    
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, MENUHEIHT) ButtonItems:vButtonItemArray];
        mMenuHriZontal.delegate = self;
    }
    
    //初始化滑动列表
    if (mScrollPageView == nil) {
        mScrollPageView = [[NCLibraryScrollView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
        mScrollPageView.delegate = self;
    }
    [mScrollPageView setContentOfTables:vButtonItemArray.count];
    //默认选中第一个button
    [mMenuHriZontal clickButtonAtIndex:_baseChIndex];
    //-------
    [self addSubview:mScrollPageView];
    [self addSubview:mMenuHriZontal];
}

-(void)loadData:(NSArray *)newslist
{
    [mScrollPageView loadListData:newslist];
    
}

#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"第%d个Button点击了",aIndex);
    [mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"CurrentPage:%d",aPage);
    _baseChIndex = aPage;
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //    if (aPage == 3) {
    //刷新当页数据
    [mScrollPageView freshContentTableAtIndex:aPage];
    //    }
    
    if ([_actiondelegate respondsToSelector:@selector(homeViewDidChangeChannel:)]) {
        [_actiondelegate homeViewDidChangeChannel:aPage];
    }
}

-(void)didClickNewsModel:(TDHomeModel *)model
{
    if ([_actiondelegate respondsToSelector:@selector(homeViewDidClickNews:)]) {
        [_actiondelegate homeViewDidClickNews:model];
    }
    
}

@end
