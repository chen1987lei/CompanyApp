//
//  TDBaseCellView.h
//  Tudou
//
//  Created by CL7RNEC on 15/3/31.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TDImageBottomAlingment)
{
    imageBottomAlingmentRight = 0,  //0是默认的
    imageBottomAlingmentLeft = 1
};

@interface TDBaseCellView : UIView

@property (nonatomic,strong) UIImage *defaultImg;       //默认图
@property (nonatomic,copy) NSString *imgUrl;            //图片地址
@property (nonatomic,copy) NSString *title;             //标题
@property (nonatomic,copy) NSString *subTitle;          //副标题
@property (nonatomic,copy) NSString *imgBottomTitle;    //图片腰封标题
@property (nonatomic,copy) NSString *imgBottomSubTitle; //图片腰封副标题
@property (nonatomic,assign) TDImageBottomAlingment bottomAlingment;    //腰封文字对齐方式
@property (nonatomic,copy) NSString *imgCornerUrl;      //角标图片地址
@property (nonatomic,assign) BOOL isCornerHidden;       //是否显示角标
@property (nonatomic,assign) BOOL isMarkHidden;         //是否显示打分

/**
 *  刷新view
 */
- (void)refreshCellView;

-(void)animationWithImage;

@end
