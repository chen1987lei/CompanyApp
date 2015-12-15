//
//  TDSearchPopMessageView.h
//  Tudou
//
//  Created by lihang on 14/12/2.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//
#import <UIKit/UIKit.h>
@class TDSearchPopMessageView;
@class CorrectionData;

@protocol TDSearchPopMessageViewDelegate <NSObject>
- (void)searchPopViewDidSelectMessage:(CorrectionData *)data;
@end

@interface TDSearchPopMessageView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<TDSearchPopMessageViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (atomic, assign, readonly) BOOL dropListIsOpen;

- (void)showList;
- (void)hiddenList;
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
- (void)refreshUI;

@end
