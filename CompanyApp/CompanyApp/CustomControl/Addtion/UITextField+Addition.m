//
//  UITextField+Addition.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-27.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "UITextField+Addition.h"

@implementation UITextField(TDCategory)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    UIView * leftView = self.leftView;
    return CGRectMake(5, (int)(self.height-leftView.height)/2, leftView.width, leftView.height);
}
#pragma clang diagnostic pop

@end
