//
//  TDPlayerActivity.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-14.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class
 @abstract 土豆logo的加载等待图表
*/
@interface TDPlayerActivity : UIView
{
}
@property(nonatomic,assign) BOOL hidesWhenStopped;
@property(nonatomic,strong) CALayer *bgLayer;
@property(nonatomic,strong) CALayer *rotateLayer;
- (id)init;
- (void)startAnimating;

- (void)stopAnimating;
- (BOOL)isAnimating;

@end
