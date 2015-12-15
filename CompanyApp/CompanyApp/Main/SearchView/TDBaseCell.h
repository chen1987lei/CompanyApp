//
//  TDBaseCell.h
//  Tudou
//
//  Created by CL7RNEC on 15/3/31.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TDCellType) {
    cellTypeBigOne,             //单一大图
    cellTypeHorizontalTwo,      //横向两张图
    cellTypeVerticalThree,      //垂直三张图
    cellTypeOther
};

@protocol TDBaseCellDelegate;

@interface TDBaseCell : UITableViewCell
{
    NSArray *_arrList;
}

@property (nonatomic,strong) NSMutableArray *arrCell;
@property (nonatomic, strong) NSArray *arrList;
@property (nonatomic, weak) id<TDBaseCellDelegate> delegate;

/**
 *  初始化cell
 *
 *  @param style           cell样式
 *  @param reuseIdentifier 唯一标示符，需要和celltype合并在一起传递过来
 *  @param cellType        cell类型
 *
 *  @return id
 */
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
      withCellType:(TDCellType)cellType;
/**
 *  根据不同类型返回不同高度
 *
 *  @param cellType cell类型
 *
 *  @return 高度
 */
+(float)cellHeight:(TDCellType)cellType;

@end

@protocol TDBaseCellDelegate <NSObject>

-(void)viewTouchWithIndexPath:(NSIndexPath*)index;

@end
