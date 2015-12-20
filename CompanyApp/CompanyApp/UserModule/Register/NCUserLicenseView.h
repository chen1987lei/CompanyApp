//
//  NCUserLicenseView.h
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCUserLicenseView : UIView
{
    
}

-(instancetype)initWithFrame:(CGRect)frame;
-(void)showTitle:(NSString *)title subTitle:(NSString *)substr andContent:(NSString *)content;
@end
