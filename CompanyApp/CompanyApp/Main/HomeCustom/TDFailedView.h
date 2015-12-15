//
//  TDFailedView.h
//  Tudou
//
//  Created by zhang jiangshan on 13-1-9.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TDFailedView_None = 0,
    TDFailedView_NOWifi = 1,
    TDFailedView_NetWorkError = 2,
    TDFailedView_UploadNoData = 3,
    TDFailedView_HistoryNoData = 4,
    TDFailedView_NoLogin = 5,
    TDFailedView_NoFav = 6,
    TDFailedView_NoFavVideo = 7,
    TDFailedView_NoDownload = 8,
    TDFailedView_NoData = 9,
    TDFailedView_ErrorWithoutImage = 10
}TDFailedViewType;

@interface TDFailedView : UIView

@property(nonatomic,assign) TDFailedViewType type;
@property(nonatomic,weak) id delegate;
@property(nonatomic,copy) NSString *noDataDes;

@end
