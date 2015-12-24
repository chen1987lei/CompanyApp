//
//  NCRecoveryPWDViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/16.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCRecoveryPWDViewController.h"

#import "NCUserNetManager.h"

#import "TDNoneMenuTextField.h"

@interface NCRecoveryPWDViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
   NSInteger _count;
    
    UITextField *_firstpwd;
    UITextField *_secondpwd;
}

@property (nonatomic,strong) UITableView *registerTableView;
@property(nonatomic,strong)UIButton *codeBtn;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)UIButton *loginBtn;
@end


#define APPW [UIScreen mainScreen].bounds.size.width
#define APPH [UIScreen mainScreen].bounds.size.height
@implementation NCRecoveryPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"忘记密码";
    
    //创建tableView
    [self createTableView];
    
}


- (void)createTableView{
    
    float tbwidth = self.view.width;
    _registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, (FSystenVersion >= 7.0)?64.f:44.f, tbwidth, (FSystenVersion >=7.0)?(ISIPHONE5?(568.f - 64.f):(480.f - 64.f)):(ISIPHONE5?(548.f - 44.f):(460.f - 44.f))) style:UITableViewStyleGrouped];
    _registerTableView.allowsSelection = NO;
    _registerTableView.delegate = self;
    _registerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _registerTableView.dataSource = self;
    [self.view addSubview:_registerTableView];
    
    UIView *footview =  [[UIView alloc] initWithFrame:CGRectMake(0, 0,_registerTableView.width , 200)];
    
    UIButton *submitbtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 28, self.view.width-12, 34)];
    [submitbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [submitbtn setTitle:@"确定" forState:UIControlStateNormal];
    [footview addSubview:submitbtn];
    submitbtn.backgroundColor =[UIColor redColor];
    [submitbtn addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _registerTableView.tableFooterView = footview;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


#define offset 15.f
#define textwidth 120.f
#define celltop 10.f

#define txtfieldHeight 20.f
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        //        cell.imageView.image = PNGIMAGE(@"register_email@2x");
        static NSString *cellIdentifier = @"cellIdentifier";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, celltop, 70.f, 20.f) withTitle:@"手机号" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(label.right+offset, celltop, 250, txtfieldHeight)];
        _phoneTF.placeholder= @"请输入注册时使用的手机号";
        [cell addSubview:_phoneTF];
        _phoneTF.font = [UIFont systemFontOfSize:13];
        
        _codeBtn=[UIButton new];
        [_codeBtn setFrame:CGRectMake(0, _phoneTF.top,80, 40)];
        [_codeBtn setBackgroundImage:[UIImage imageNamed:@"colorButton1@2x.png"] forState:UIControlStateNormal];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
        _phoneTF.rightView =_codeBtn;
        
        _phoneTF.rightViewMode=UITextFieldViewModeAlways;
        

        return cell;
    }
    else if (indexPath.row == 1){
        static NSString *cellIdentifier5 = @"cellIdentifier5";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier5];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"验证码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        _codeTF=[[UITextField alloc]initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        _codeTF.placeholder= @"请输入验证码";
        [cell addSubview:_codeTF];
        
        return cell;
    }else if (indexPath.row == 2){
        static NSString *cellIdentifier6 = @"cellIdentifier6";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier6];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"设置密码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请输入密码";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell addSubview:textField];
        _firstpwd = textField;
        _firstpwd.font = [UIFont systemFontOfSize:13];
        return cell;
    }
    else if (indexPath.row == 3){
        static NSString *cellIdentifier7 = @"cellIdentifier7";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier7];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"重复密码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"请重复输入密码";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell addSubview:textField];
        _secondpwd = textField;
        _secondpwd.font = [UIFont systemFontOfSize:13];
        return cell;
    }
  
    return nil;
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

}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)sendCode
{
    NSString *msg;
    if ([self.phoneTF.text isEqualToString:@""]||(self.phoneTF.text==NULL)) {
        msg =@"手机号码不能为空";
    }
    if (msg.length !=0) {
        UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    [self performSelector:@selector(countClick) withObject:nil];
    
    NSString *phonenum = self.phoneTF.text;
    
    [[NCUserNetManager sharedInstance] getValidateCodeWithPhone:phonenum toRegister:NO withComplate:^(NSDictionary *result, NSError *error) {
        //        code = 200;
        //        res =     {
        //            code = 618199;
        //        };
        if ([result[@"code"] integerValue] == 200) {
            
            NSString *regcode = result[@"res"][@"code"];
            
            NSString *msgstr = [NSString stringWithFormat:@"已经发送验证码: %@", regcode];
            [Utils alertTitle:@"提示" message:msgstr delegate:nil cancelBtn:@"好" otherBtnName:nil];
            
        }
        else
        {
            NSString *msg = result[@"msg"];
            if(msg == nil) msg = @"请求失败";
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }
    }];

}



-(void)submitButtonAction
{
    NSString *phoneacc = _phoneTF.text;
    NSString *pwd = _firstpwd.text;
    NSString *secpwd = _secondpwd.text;
    NSString *validatecode = _codeTF.text;
    
    if (phoneacc.length ==0 ||pwd.length ==0 || secpwd.length ==0 || validatecode.length ==0   ) {
        
        NSString *msgstr =@"输入不能为空";
        [Utils alertTitle:@"提示" message:msgstr delegate:nil cancelBtn:@"好" otherBtnName:nil];
        return;
    }
    
    [[NCUserNetManager sharedInstance] recoveryWithAccount:phoneacc andPassword:pwd secondPassword:secpwd andValidateCode:validatecode  withComplate:^(NSDictionary *result, NSError *error) {
        //        code = 200;
        //        res =     {
        //            code = 618199;
        //        };
        if ([result[@"code"] integerValue] == 200) {
            
            NSString *regcode = result[@"res"][@"code"];
            NSString *msgstr = @"修改密码成功";
            [Utils alertTitle:@"提示" message:msgstr delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }
        else
        {
            NSString *msg = result[@"msg"];
            if(msg == nil) msg = @"请求失败";
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }
        
    }];
}

-(void)countClick
{
    _codeBtn.enabled =NO;
    _count = 60;
    [_codeBtn setTitle:@"60秒" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(NSTimer *)timer
{
    if (_count !=1) {
        _count -=1;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",_count] forState:UIControlStateDisabled];
    }
    else
    {
        [timer invalidate];
        _codeBtn.enabled = YES;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
