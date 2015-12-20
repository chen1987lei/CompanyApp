//
//  RegisterViewController.m
//  Login_Register
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#import "RegisterViewController.h"
#import "TopNavBar.h"
#import "Utils.h"

#import "NAModalSheet.h"

#import "NCUserConfig.h"
#import "NCUserNetManager.h"

#import "NCModelManager.h"
#import "NCInitial.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,TopNavBarDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIButton *_sextextButton;
    UIToolbar *_myToolbar;
}
@property (nonatomic,assign) BOOL          isRead;

@end

static BOOL hasViewLicense = NO;
@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航条
    [self createCustomNavBar];
    
    //创建tableView
    [self createTableView];

//    [self showContentwithCompletionBlock:nil];
}


-(void)showPickerView
{
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.frame = CGRectMake(0, kScreenHeight-200, kScreenWidth, 200);
  
    _myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _pickerView.top, kScreenWidth, 44)];

    UIBarButtonItem *cc = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(sexSelectCancel)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sexSelectDone)];
    NSArray *items = [NSArray arrayWithObjects:cc,space,bb,nil];
    [_myToolbar setItems:items];

    [self.view addSubview:_pickerView];
    [self.view addSubview:_myToolbar];
    
}

-(void)sexSelectCancel
{
    [self dismissPickerView];
}

-(void)sexSelectDone
{
    [self dismissPickerView];
}

-(void)dismissPickerView
{
    [_pickerView removeFromSuperview];
    _pickerView = nil;
    
    [_myToolbar removeFromSuperview];
    _myToolbar = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [self showGuideContent];
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

-(void)showGuideContent
{
    NCBaseModel *model = [NCInitial sharedInstance].reg_certificateData;
//    NCCertificate *regcertobj = [[NCCertificate alloc] init];
    
//    NSString *message = regcertobj.content;
    
//   title subtitle;
    NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:self presentationStyle:NAModalSheetPresentationStyleFadeInCentered];
    sheet.disableBlurredBackground = YES;
    sheet.cornerRadiusWhenCentered = 10.0;
    
//    vc.modalSheet = sheet;
//    vc.messageString = message == nil?@"":message;
//    vc.openURL = [NSURL URLWithString:urlString];
//    vc.completionBlock = completionBlock;
//    vc.hasShowed = YES;
    [sheet presentWithCompletion:nil];
}

/**
 *	@brief	键盘出现
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil] ;

}

/**
 *	@brief	键盘消失
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillHide:(NSNotification *)aNotification

{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil];
    
}


/**
 *	@brief	创建TableView
 */
- (void)createTableView{

    float tbwidth = self.view.width;
    _registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, (FSystenVersion >= 7.0)?64.f:44.f, tbwidth, (FSystenVersion >=7.0)?(ISIPHONE5?(568.f - 64.f):(480.f - 64.f)):(ISIPHONE5?(548.f - 44.f):(460.f - 44.f))) style:UITableViewStyleGrouped];
    _registerTableView.allowsSelection = NO;
    _registerTableView.delegate = self;
    _registerTableView.dataSource = self;
    [self.view addSubview:_registerTableView];
    
    UIView *footview =  [[UIView alloc] initWithFrame:CGRectMake(0, 0,_registerTableView.width , 200)];
    
    UIButton *submitbtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 28, self.view.width-12, 34)];
    [submitbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [submitbtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [footview addSubview:submitbtn];
    [submitbtn addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _registerTableView.tableFooterView = footview;
}


-(void)registerButtonAction
{
    NSString *account = [(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text];
    NSString *sexval = _sextextButton.titleLabel.text;

    
    NSString *certcard = [(UITextField *)[self.view viewWithTag:Tag_CertCardTextField] text];
    NSString *mobile = [(UITextField *)[self.view viewWithTag:Tag_MobileNumberTextField] text];
    NSString *validatecode = [(UITextField *)[self.view viewWithTag:Tag_ValidateCodeTextField] text];
    NSString *firstpwd = [(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text];
    NSString *secondpwd = [(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text];
    NSString *recommadText = [(UITextField *)[self.view viewWithTag:Tag_RecommadTextField] text];
    
    NCUserConfig *user = [[NCUserConfig alloc] init];
    user.userName = account;
    user.sexValue = [sexval isEqualToString:@"男"]?@1:@2;
    user.certCard = certcard;
    user.mobilenumber = mobile;
    user.validatecode = validatecode;
    user.tmppasswd = firstpwd;
    user.secondpwd = secondpwd;
    user.invitecode = recommadText;
    
    
    [[NCUserNetManager sharedInstance] registerWithUser:user withComplate:^(NSDictionary *result, NSError *error) {
//        code = 200;
//        res =     {
//            uid = 7;
//            uuid = 3cc7c775bd5b6ff9cdb4228628686c66;
        //注册成功，提示
        NSString *resultstr = @"注册失败";;
        if ([result[@"code"] integerValue] == 200) {
            resultstr = @"注册成功";
        }
        
        [Utils alertTitle:@"提示" message:resultstr delegate:nil cancelBtn:@"好" otherBtnName:nil];
    }];
    
}


/**
 *	@brief	创建自定义导航条
 */
- (void)createCustomNavBar
{
    _topNavBar = [[TopNavBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, (FSystenVersion >= 7.0)?64.f:44.f)
                                      bgImageName:(FSystenVersion >= 7.0)?@"backgroundNavbar_ios7@2x":@"backgroundNavbar_ios6@2x"
                                       labelTitle:@"注册"
                                         labFrame:CGRectMake(90.f,(FSystenVersion >= 7.0)?27.f:7.f , 140.f, 30.f)
                                         leftBool:YES
                                     leftBtnFrame:CGRectMake(12.f, (FSystenVersion >= 7.0)?27.f:7.f, 30.f, 30.f)
                                 leftBtnImageName:@"button_back_bg@2x.png"
                                        rightBool:NO
                                    rightBtnFrame:CGRectZero
                                rightBtnImageName:nil];
    _topNavBar.delegate = self;
    [self.view addSubview:_topNavBar];
    
}

#pragma mark - TopNavBarDelegate Method
/**
 *	@brief	TopNavBarDelegate Method
 *
 *	@param 	index 	barItemButton 的索引值
 */
- (void)itemButtonClicked:(int)index
{
    switch (index) {
        case 0:
        {
            [Utils alertTitle:@"提示" message:@"您点击了返回按钮" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

//Tag_AccountTextField  = 100,    //用户名
//Tag_SexTextField,  //性别
//Tag_CertCardTextField,  // 身份证号
//Tag_MobileNumberTextField, //手机号码
//Tag_ValidateCodeTextField, // 验证码
//Tag_TempPasswordTextField, // 设置密码
//Tag_ConfirmPasswordTextField, //确认登录密码
//Tag_RecommadTextField,        //企业邀请码

#define offset 15.f
#define textwidth 120.f
#define celltop 10.f

#define txtfieldHeight 20.f
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
//        cell.imageView.image = PNGIMAGE(@"register_email@2x");
        static NSString *cellIdentifier = @"cellIdentifier";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, celltop, 70.f, 20.f) withTitle:@"姓   名" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.tag = Tag_AccountTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入姓名";
        textField.keyboardType = UIKeyboardTypeDefault;
        [cell addSubview:textField];
        
        return cell;
    }else if (indexPath.row == 1){
        static NSString *cellIdentifier2 = @"cellIdentifier2";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"性   别" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        label.userInteractionEnabled = NO;
        [cell addSubview:label];
        
        
        UIButton *sexButton = [[UIButton alloc] initWithFrame:CGRectMake(label.right+offset , celltop, textwidth, txtfieldHeight)];
        [sexButton addTarget:self action:@selector(showPickerView)  forControlEvents:UIControlEventTouchUpInside];
        sexButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//        sexButton.tag = Tag_SexTextField;
        [sexButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sexButton setTitle:@"男" forState:UIControlStateNormal];
        _sextextButton = sexButton;
        [cell addSubview:sexButton];
        return cell;
    }else if (indexPath.row == 2){
        static NSString *cellIdentifier3 = @"cellIdentifier3";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"身份证号" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.tag = Tag_CertCardTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入身份证号";
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [cell addSubview:textField];
        
        return cell;
    }else if (indexPath.row ==3){
        static NSString *cellIdentifier4 = @"cellIdentifier4";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"手机号码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth , txtfieldHeight)];
        textField.tag = Tag_MobileNumberTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入手机号";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:textField];
        
        UIButton *sendcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendcodeBtn.backgroundColor = [UIColor blueColor];
        [sendcodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendcodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        sendcodeBtn.frame = CGRectMake(textField.right+offset , celltop, 100.f, 21.f);

        [sendcodeBtn addTarget:self action:@selector(sendCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
        [cell addSubview:sendcodeBtn];
        return cell;
        
    }else if (indexPath.row == 4){
        static NSString *cellIdentifier5 = @"cellIdentifier5";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier5];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"验证码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.tag = Tag_ValidateCodeTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入手机验证码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:textField];
         return cell;
    }else if (indexPath.row == 5){
        static NSString *cellIdentifier6 = @"cellIdentifier6";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier6];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"设置密码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.tag = Tag_TempPasswordTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入密码";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell addSubview:textField];
        
        return cell;
    }
    else if (indexPath.row == 6){
        static NSString *cellIdentifier7 = @"cellIdentifier7";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier7];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"重复密码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.tag = Tag_ConfirmPasswordTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请重复输入密码";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell addSubview:textField];
        return cell;
    }
    else if (indexPath.row == 7){
        static NSString *cellIdentifier8 = @"cellIdentifier8";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier8];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"企业邀请码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.tag = Tag_RecommadTextField;
        textField.font = [UIFont systemFontOfSize:12];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入企业邀请码";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell addSubview:textField];
        return cell;
    }
    return nil;
}

-(void)sendCodeButtonClicked
{
 
    NSString *mobile = [(UITextField *)[self.view viewWithTag:Tag_MobileNumberTextField] text];
    [[NCUserNetManager sharedInstance] getValidateCodeWithPhone:mobile toRegister:YES withComplate:^(NSDictionary *result, NSError *error) {
//        code = 200;
//        res =     {
//            code = 618199;
//        };
        if ([result[@"code"] integerValue] == 200) {
            
            NSString *regcode = result[@"res"][@"code"];
            
            NSString *msgstr = [NSString stringWithFormat:@"已经发送验证码: %@", regcode];
            [Utils alertTitle:@"提示" message:msgstr delegate:nil cancelBtn:@"好" otherBtnName:nil];
            
        }
    }];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 36;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - UIButtonClicked Method
- (void)buttonClicked:(id)sender{
  /*
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case Tag_isReadButton:
        {
            //是否阅读协议
            if (_isRead) {
                
                [btn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
                _isRead = NO;
            }else{
                
                [btn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
                
                _isRead = YES;
            }
        }
            break;
        case Tag_servicesButton:
        {
            //服务协议
            [Utils alertTitle:@"提示" message:@"您点击了服务协议" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
            break;
        case Tag_privacyButton:
        {
            //隐私协议
            [Utils alertTitle:@"提示" message:@"您点击了隐私协议" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
            break;
            
        default:
            break;
    }
    */
}
#pragma mark - sourceBtnClicked Method
- (void)sourceBtnClicked:(id)sender{
    
    [Utils alertTitle:@"提示" message:@"来源接口方法入口" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
}

#pragma mark - RegisterBtnClicked Method
- (void)registerBtnClicked:(id)sender{
    
    
    if (!_isRead) {
        [Utils alertTitle:@"提示" message:@"请勾选阅读协议选项框" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
    }else{
        
        if ([self checkValidityTextField]) {
            
            [Utils alertTitle:@"提示" message:@"资料填写完整可以进行注册请求" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
        }
    }
}

/**
 *	@brief	验证文本框是否为空
 */
#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField
{
    /*
    if ([(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户名不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }

    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户密码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户确认密码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    */
    return YES;
    
}

#pragma mark - UITextFieldDelegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == Tag_RecommadTextField) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:nil] ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    /*
    switch (textField.tag) {
            
        case Tag_EmailTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if (![Utils isValidateEmail:textField.text]) {
                    
                    [Utils alertTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_TempPasswordTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if ([[textField text] length] < 6) {
                    
                    [Utils alertTitle:@"提示" message:@"用户密码小于6位！" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_ConfirmPasswordTextField:
        {
            if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] !=0 && ([textField text]!= nil && [[textField text] length]!= 0)) {
                
                if (![[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:[textField text]]) {
                    [Utils alertTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_RecommadTextField:
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.view.frame = CGRectMake(0.f, (FSystenVersion >= 7.0)?0.f:20.f, self.view.frame.size.width, self.view.frame.size.height);
                
            }completion:nil];
        }
            break;
            
        default:
            break;
    }
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    //邮箱
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    //用户名
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    //确认密码
    [[self.view viewWithTag:Tag_ConfirmPasswordTextField] resignFirstResponder];
    //推荐人
    [[self.view viewWithTag:Tag_RecommadTextField] resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIPickerViewDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return 2;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row ==0) {
        return @"女";
    }
    else
    {
      return @"男";
    }
//    NSDictionary *dict = [self.arrChannel objectAtSafeIndex:row];
    
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:dict[@"title"]
//                                                              attributes:@{NSForegroundColorAttributeName:RGB(70, 70, 70)}
//                               ];
//    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *sexstr = nil;
    if (row ==0) {
        sexstr = @"女";
    }
    else
    {
        sexstr = @"男";
    }
    
    [_sextextButton setTitle:sexstr forState:UIControlStateNormal];
}
@end
