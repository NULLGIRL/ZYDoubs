//
//  ZYMainTabBarViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMainTabBarViewController.h"

#import "ZYDailNumViewController.h"  //拨号界面
#import "ZYContactViewController.h"  //联系人界面
#import "ZYMessageViewController.h"  //发信息界面
#import "ZYMineViewController.h"    //设置界面
#import "ZYBarButton.h"

@interface ZYMainTabBarViewController ()

@property (nonatomic,strong) UIButton * btn_Selected;

@property (nonatomic,strong) NSArray * btnImage;

@end

@implementation ZYMainTabBarViewController

#pragma mark - 使用Routable必须实现该方法

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self initWithNibName:nil bundle:nil])) {
//        NSString *string = [params objectForKey:@"id"];

//        if ([string isEqualToString:@"me"]) {
//            [self setSelectedIndex:2];
//        } else if ([string isEqualToString:@"find"]) {
//            [self setSelectedIndex:0];
//        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    
    [self setTabBar];
}

-(void)createSubviews
{
    ZYDailNumViewController * audioVC = [[ZYDailNumViewController alloc]init];
    
    ZYMessageViewController * messageVC = [[ZYMessageViewController alloc]init];
    
    ZYContactViewController * contactVC = [[ZYContactViewController alloc]init];
    
    ZYMineViewController * myVC = [[ZYMineViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    self.viewControllers = @[audioVC,messageVC,contactVC,myVC];
    
}

-(void)setTabBar
{
    NSArray * barButtonTitleArray = @[@"拨号",@"信息",@"联系人",@"设置"];
    self.btnImage = @[@"tab_call",@"tab_message",@"tab_contact",@"tab_Settings"];
    
    float buttonWidth = ScreenWidth / 4;
    
    for (int i = 0; i<barButtonTitleArray.count; i++) {
        ZYBarButton *btn = [ZYBarButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, 49);
        btn.tag = i;
        NSString * btnTitle = barButtonTitleArray[i];
        NSString * imageStr = self.btnImage[i];
        NSString * sImageStr = [NSString stringWithFormat:@"%@_s",imageStr];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:sImageStr] forState:UIControlStateSelected];
        
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(barButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];

        
        if (i == 0) {
            [self barButtonClick:btn];
        }
    }
    
}

-(void)barButtonClick:(UIButton *)button
{
    
    self.selectedIndex = button.tag;
    
    self.btn_Selected.selected = NO;
    self.btn_Selected = button;
    button.selected = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
