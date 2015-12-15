//
//  TDBaseVerticalCellView.h
//  Tudou
//  竖向卡片
//  Created by CL7RNEC on 15/4/1.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseCellView.h"
//wangpengfei 新布局
#define kVERTICAL_MARGIN_RIGHT_X 1.0f
#define kVERTICAL_MARGIN_X 10.0f
#define kVERTICAL_MARGIN_Y 1.0f
#define kVERTICAL_WIDTH ([UIScreen width] - (kVERTICAL_MARGIN_X)*2-1)/3
#define kVERTICAL_HEIGHT ((kVERTICAL_WIDTH)*140/93+57)

@interface TDBaseVerticalCellView : TDBaseCellView

@property (nonatomic,strong) UIImageView *imgConner;

@end
