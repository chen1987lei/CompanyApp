//
//  RegisterViewController.h
//  Login_Register
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopNavBar;

enum TAG_REGISTER_TEXTFIELD{
    
    Tag_AccountTextField  = 100,    //用户名
      Tag_SexTextField,  //性别
      Tag_CertCardTextField,  // 身份证号
      Tag_MobileNumberTextField, //手机号码
      Tag_ValidateCodeTextField, // 验证码
      Tag_TempPasswordTextField, // 设置密码
      Tag_ConfirmPasswordTextField, //确认登录密码
      Tag_RecommadTextField,        //企业邀请码
};
@interface RegisterViewController : UIViewController<UIPickerViewDelegate>


@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic,strong) UITableView *registerTableView;

@property (nonatomic,strong) TopNavBar    *topNavBar;

@end
