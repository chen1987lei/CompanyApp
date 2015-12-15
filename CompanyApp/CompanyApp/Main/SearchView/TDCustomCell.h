//
//  TDCustomCell.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-30.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCellLayer.h"

typedef enum {
    kCellTypeAlbum,//搜索直达的剧集
    kCellTypeItem,//搜索非直达
}CellType;

@interface TDCustomCell : UITableViewCell
{
    SEL _selector;
}
@property (nonatomic, strong) id object;
@property (nonatomic, weak) id delegate;

+ (float) height;

- (void)setDidTapMethod:(SEL)selector;

- (void)refresh;

@end
