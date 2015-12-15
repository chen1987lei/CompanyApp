//
//  TDSearchSegmentView.h
//  Tudou
//
//  Created by weiliang on 14-3-14.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDView.h"
@protocol TDSearchSegmentViewDelegate<NSObject>
- (void)clickButtonAtIndex:(NSUInteger)index;
@end

@interface TDSearchSegmentView : TDView
{
    NSMutableArray* buttonsArray;
    NSInteger currentSelect;
}
@property(nonatomic,weak) id delegate;
- (void)setTitleArray:(NSArray*)array;
/**
 *  设置选中按钮
 *
 *  @param
 */
- (void)setCurrentSelect:(NSInteger)selectTag;
@end
