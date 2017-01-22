//
//  ZYBaseViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBaseViewController.h"

@interface ZYBaseViewController ()

@end

@implementation ZYBaseViewController

-(void)loadView
{   // textField上移 导航栏不上移
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark - 检查网络
// 检查网络是否通畅
- (BOOL)checkNetWork{
    
    if (![ZYTools connectedToNetwork]) {
        if ([NSThread isMainThread])
        {
            [SVProgressHUD showWithStatus:@"网络异常,请检查网络连接" maskType:SVProgressHUDMaskTypeGradient];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotReachable" object:nil];
            [self dismissAction];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [SVProgressHUD showWithStatus:@"网络异常,请检查网络连接" maskType:SVProgressHUDMaskTypeGradient];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotReachable" object:nil];
                [self dismissAction];
                
            });
        }
        
        return NO;
    }
    return YES;
}

- (void)dismissAction {
    [self performSelector:@selector(disappear) withObject:nil afterDelay:1.5f];
}

- (void)disappear {
    [SVProgressHUD dismiss];
}

-(void)createSVProgressMessage:(NSString *)str withMethod:(SEL)method{

    [SVProgressHUD showWithStatus:str];
    
    [self dismisswithMethod:method];
}

//设置导航栏标题黑色字体（单行）
-(void)setBlackTitle:(NSString *)title withVC:(UIViewController*)vc{

    ZYLabel * titleLabel = [[ZYLabel alloc] initWithText:title font:LargeFont color:mainTextColor];
    titleLabel.center = CGPointMake(ScreenWidth/2, 32);
    [titleLabel sizeToFit];
    vc.navigationItem.titleView = titleLabel;
}

//设置导航栏标题黑色字体（双行）
-(void)setBlackTitle:(NSString *)title smallTitle:(NSString *)smallTitle withVC:(UIViewController*)vc{
    
    UIView * titleview = [[UIView alloc]init];
    titleview.center = CGPointMake(ScreenWidth/2, 32);
    titleview.bounds = CGRectMake(0, 0, 200, 44);
    
    ZYLabel * titleLabel = [[ZYLabel alloc] initWithText:title font:LargeFont color:mainTextColor];
    [titleview addSubview:titleLabel];
    
    ZYLabel * smallTitleLabel = [[ZYLabel alloc] initWithText:smallTitle font:MiddleFont color:mainTextColor];
    [titleview addSubview:smallTitleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleview);
        make.right.equalTo(titleview);
        make.top.equalTo(titleview);
        make.height.equalTo(@25);
    }];
    
    [smallTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleview);
        make.right.equalTo(titleview);
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.equalTo(@19);
    }];
    vc.navigationItem.titleView = titleview;
}

// 创建导航栏左边的图标
- (void)createLeftImage:(NSString *)imageName withVC:(UIViewController*)vc{
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    img.image = [UIImage imageNamed:imageName];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:img];
    vc.navigationItem.leftBarButtonItem = leftItem;
    
}

/** 创建导航栏左边的按钮 （图片+文字）*/
- (void)createLeftBarButtonItemWithTitle:(NSString *)title withVC:(UIViewController*)vc{
    ZYButton * leftBtn = [[ZYButton alloc] initWithTitle:title font:LargeFont withImage:@"backArrow"];
    leftBtn.block = ^(NSString * reMark){
        [self backAction];
    };
    [leftBtn sizeToFit];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    vc.navigationItem.leftBarButtonItem = leftItem;
}

/** 创建导航栏左边的按钮 (文字+图片）*/
- (void)createLeftBarButtonItemWithImage:(NSString *)imageName WithTitle:(NSString *)title withMethod:(SEL)method withVC:(UIViewController*)vc{
    
    
    ZYButton * leftBtn = [[ZYButton alloc] initWithTitle:title font:LargeFont withImage:@"backArrow"];
    leftBtn.block = ^(NSString * reMark){
        if (method) {
            [self performSelector:method];
        }
    };
    [leftBtn sizeToFit];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    vc.navigationItem.leftBarButtonItem = leftItem;
 
}

/** 创建导航栏右边的按钮 （图片+文字）*/
- (void)createRightBarButtonItemWithImage:(NSString *)imageName WithTitle:(NSString *)title withMethod:(SEL)method withVC:(UIViewController*)vc{
    
    ZYButton * rightBtn = [[ZYButton alloc] initWithTitle:title font:LargeFont withImage:imageName];
    rightBtn.block = ^(NSString * reMark){
        if (method) {
            [self performSelector:method];
        }
    };
    [rightBtn sizeToFit];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    vc.navigationItem.rightBarButtonItem = rightBtnItem;

}

// alertView
-(void)createAlertWithMessage:(NSString *)message{
    
    [self.view endEditing:YES];
    if (iOSVersion >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



- (void)backAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)dismisswithMethod:(SEL)method{
    [self performSelector:method withObject:nil afterDelay:1.5f];
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
