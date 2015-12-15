//
//  TDView.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-30.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDView : UIView

@property(nonatomic,weak) id drawDelegate;

@property(nonatomic,assign) SEL drawMethod; //- (void)drawRect:(CGRect)rect

@property(nonatomic,assign) SEL layoutMethod;

@property(nonatomic,weak) id moveToWindowDelegate;
@property(nonatomic,assign) SEL willMoveToWindowMethod;
@property(nonatomic,assign) SEL didMoveToWindowMethod;

@end
