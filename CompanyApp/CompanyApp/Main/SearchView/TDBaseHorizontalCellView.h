//
//  TDBaseHorizontalCellView.h
//  Tudou
//  横向卡片
//  Created by CL7RNEC on 15/4/1.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseCellView.h"
//wangpengfei 新布局
#define kHORIZONTAL_MARGIN_RIGHT_X 1.0f
#define kHORIZONTAL_MARGIN_X 10.0f
#define kHORIZONTAL_MARGIN_Y 1.0f
#define kHORIZONTAL_WIDTH ([UIScreen width] - (kHORIZONTAL_MARGIN_X)*2-kHORIZONTAL_MARGIN_RIGHT_X)/2
#define kHORIZONTAL_HEIGHT (kHORIZONTAL_WIDTH*82/145+57)

@interface TDBaseHorizontalCellView : TDBaseCellView

@property (nonatomic,strong) UIImageView *imgConner;

-(void)createView;
@end
