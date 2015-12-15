//
//  TDSearchTitleView.h
//  Tudou
//
//  Created by zhangjiwang on 13-12-20.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TdSearchTitleDelegate <NSObject>

@optional
/*****
@param index 当前的刷新页面page
@param offset 当前titleview点中的第几个tab
@param dsstance 当前titleview的contentoffset
@param should 当前值为YES model层接收到数据改变modelindex，否则不改变
****/
- (void)tdSearchTitleClicked:(NSNumber *)index
                 OffSetIndex:(NSNumber *)offset
              OffsetDistance:(NSNumber *)distance
           shouldModifyIndex:(NSNumber *)should;

@end

@interface TDSearchTitleView : UIScrollView

@property (nonatomic,weak)id <TdSearchTitleDelegate> searchDelegate;
-(void)createTitleWithNumber:(NSInteger)count
                    PageSize:(NSInteger)pagesize
                        desc:(BOOL)descendOrder
                    CurIndex:(NSInteger)curIndex
                   CurOffset:(CGFloat)curOffset
                       Items:(NSArray*)items;

@end
