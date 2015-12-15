//
//  TDMultiplyLable.h
//  Tudou
//  只支持单行显示，若字符越界 则显示、、、
//  Created by weiliang on 13-8-15.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface LableTextAndColor : NSObject
@property(nonatomic,strong) UIColor* lableColor;
@property(nonatomic,strong) NSString* lableText;
@property(nonatomic,strong) UIFont* lableFont;
@end
 
@interface TDMultiplyLable : UIView

/*
 textsAndColors数组里存的是LableTextAndColor，调用此接口会自动布局lable
 */
-(void) setMultiplyTexts:(NSArray*)textsAndColors;
 
@end
