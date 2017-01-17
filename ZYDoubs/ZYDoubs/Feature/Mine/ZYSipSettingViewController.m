//
//  ZYSipSettingViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/12.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYSipSettingViewController.h"

@interface ZYSipSettingViewController ()

@property (nonatomic,strong) ZYTextField * sipnumTextField;
@property (nonatomic,strong) ZYTextField * passwordField;
@property (nonatomic,strong) ZYTextField * realmTextField;
@property (nonatomic,strong) ZYTextField * portTextField;
@property (nonatomic,strong) ZYTextField * transTextField;


@end

@implementation ZYSipSettingViewController

#pragma mark - 使用Routable必须实现该方法

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self initWithNibName:nil bundle:nil])) {
        NSString *string = [params objectForKey:@"id"];
        NSLog(@"ZYSipSettingViewController - %@",string);

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    
}

- (void) createSubviews{
    
    NSArray * textFields = @[self.sipnumTextField,
                           self.passwordField,
                           self.realmTextField,
                           self.portTextField,
                           self.transTextField
                           ];
    
    for (int i = 0 ; i < textFields.count ; i ++) {
        
        ZYTextField * textField = textFields[i];
        [self.view addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.top.equalTo(self.view).with.offset(i * 60 + 50);
            make.height.equalTo(@30);
        }];
    }
    
    ZYButton * commitBtn = [[ZYButton alloc]initWithTitle:@"确认" font:MiddleFont];
    commitBtn.block = ^(NSString * reMark){
        [self.view endEditing:YES];
        [self sipRegister];
    };
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(400);
        make.height.equalTo(@30);
    }];
}


-(void)sipRegister{
    
    if ([ZYTools isNullOrEmpty:self.sipnumTextField.text]) {
        
        [CNUIHelper toast:@"请输入sip账号"];
        return;
        
    }
    
    if ([ZYTools isNullOrEmpty:self.passwordField.text]) {
        
        [CNUIHelper toast:@"请输入sip密码"];
        return;
        
    }
    
    if ([ZYTools isNullOrEmpty:self.realmTextField.text]) {
        
        [CNUIHelper toast:@"请输入realm"];
        return;
    }
    
    if ([ZYTools isNullOrEmpty:self.portTextField.text]) {
        
        [CNUIHelper toast:@"请输入端口号"];
        return;
    }
    
    if ([ZYTools isNullOrEmpty:self.transTextField.text]) {
        
        [CNUIHelper toast:@"请输入传输协议（tcp/udp）"];
        return;
    }
    
    if (![ZYTools connectedToNetwork]) {
        
        [CNUIHelper toast:@"没有网络"];
        return;
    }
    
    
    if ([[NgnEngine sharedInstance] start]) {
        NSString * kPublicIdentity = [NSString stringWithFormat:@"sip:%@@%@",self.sipnumTextField.text,self.realmTextField.text];
        
        [[NgnEngine sharedInstance].configurationService setStringWithKey:IDENTITY_IMPI andValue:self.sipnumTextField.text];
        [[NgnEngine sharedInstance].configurationService setStringWithKey:IDENTITY_IMPU andValue:kPublicIdentity];
        [[NgnEngine sharedInstance].configurationService setStringWithKey:IDENTITY_DISPLAY_NAME andValue:@"昵称"];
        [[NgnEngine sharedInstance].configurationService setStringWithKey:IDENTITY_PASSWORD andValue:self.passwordField.text];
        [[NgnEngine sharedInstance].configurationService setStringWithKey:NETWORK_REALM andValue:self.realmTextField.text];
        [[NgnEngine sharedInstance].configurationService setStringWithKey:NETWORK_PCSCF_HOST andValue:self.realmTextField.text];
        
        int intPort = [self.portTextField.text intValue];
        [[NgnEngine sharedInstance].configurationService setIntWithKey:NETWORK_PCSCF_PORT andValue:intPort];
        [[NgnEngine sharedInstance].configurationService setBoolWithKey:NETWORK_USE_EARLY_IMS andValue:YES];
        [[NgnEngine sharedInstance].configurationService setBoolWithKey:NETWORK_USE_3G andValue:YES];
        
        [[NgnEngine sharedInstance].historyService load];
        [[NgnEngine sharedInstance].sipService registerIdentity];
        
        SYLog(@" 配置   %@ \n%@\n %@\n",self.sipnumTextField.text,self.passwordField.text,kPublicIdentity);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
-(ZYTextField *)sipnumTextField{
    if (!_sipnumTextField) {
        _sipnumTextField = [[ZYTextField alloc]initWithPlaceText:@"请输入sip账号（eg:1001）" font:MiddleFont tag:100];
        _sipnumTextField.text = @"2000001848";
    }
    return _sipnumTextField;
}

-(ZYTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[ZYTextField alloc]initWithPlaceText:@"请输入密码" font:MiddleFont tag:101];
        _passwordField.text = @"c1a7dfb9a0c14b36be1178e0e9420082";
    }
    return _passwordField;
}

-(ZYTextField *)realmTextField{
    if (!_realmTextField) {
        _realmTextField = [[ZYTextField alloc]initWithPlaceText:@"请输入realm" font:MiddleFont tag:102];
        _realmTextField.text = @"192.168.1.77";
    }
    return _realmTextField;
}

-(ZYTextField *)portTextField{
    if (!_portTextField) {
        _portTextField = [[ZYTextField alloc]initWithPlaceText:@"请输入port" font:MiddleFont tag:103];
        _portTextField.text = @"35162";
    }
    return _portTextField;
}

-(ZYTextField *)transTextField{
    if (!_transTextField) {
        _transTextField = [[ZYTextField alloc]initWithPlaceText:@"请输入传输协议(tcp或udp)" font:MiddleFont tag:104];
        _transTextField.text = @"tcp";
    }
    return _transTextField;
}


@end
