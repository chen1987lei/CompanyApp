//
//  TDBaseBigCellView.h
//  Tudou
//
//  Created by CL7RNEC on 15/4/1.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseCellView.h"

#define kBIG_MARGIN_X 10.0f
#define kBIG_MARGIN_Y 1.0f
#define kBIG_WIDTH ([UIScreen width] - kBIG_MARGIN_X*2)
#define kBIG_HEIGHT ((kBIG_WIDTH*7/15)+kBIG_MARGIN_Y)

@interface TDBaseBigCellView : TDBaseCellView

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *imgBottom;
@property (nonatomic,strong) UIImageView *imgConner;
@property (nonatomic,strong) UILabel *bottomTitleLab;
@property (nonatomic,strong) UILabel *bottomSubTitleLab;

@end
