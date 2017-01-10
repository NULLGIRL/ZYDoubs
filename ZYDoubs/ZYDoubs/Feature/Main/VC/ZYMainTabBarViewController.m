//
//  ZYMainTabBarViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMainTabBarViewController.h"

#import "ZYAudioViewController.h"
#import "ZYVideoViewController.h"
#import "ZYMessageViewController.h"
#import "ZYMineViewController.h"
#import "ZYBarButton.h"

@interface ZYMainTabBarViewController ()

@property (nonatomic,strong) UIButton * btn_Selected;

@property (nonatomic,strong) NSArray * btnImage;

@property (nonatomic,strong) NSArray * btnSelectImage;


@end

@implementation ZYMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    
    [self setTabBar];
}

-(void)createSubviews
{
    ZYAudioViewController * audioVC = [[ZYAudioViewController alloc]init];
    
    ZYVideoViewController * videoVC = [[ZYVideoViewController alloc]init];
    
    ZYMessageViewController * messageVC = [[ZYMessageViewController alloc]init];
    
    ZYMineViewController * myVC = [[ZYMineViewController alloc]init];
    
    self.viewControllers = @[audioVC,videoVC,messageVC,myVC];
    
}

-(void)setTabBar
{
    NSArray * barButtonTitleArray = @[@"语音",@"视频",@"信息",@"设置"];
    self.btnImage = @[@"home",@"order",@"my",@"my"];
    self.btnSelectImage = @[@"selectedhome",@"selectedOrder",@"selectedMy",@"my"];
    
    float buttonWidth = ScreenWidth / 4;
    
    for (int i = 0; i<barButtonTitleArray.count; i++) {
        ZYBarButton *btn = [ZYBarButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, 49);
        btn.tag = i;
        NSString * btnTitle = barButtonTitleArray[i];
        [btn setImage:[UIImage imageNamed:self.btnImage[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.btnSelectImage[i]] forState:UIControlStateSelected];
        
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(barButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
        
        [btn setBackgroundColor:[UIColor colorWithRed:0.0 green:180/255.0 blue:199/255.0 alpha:0.8]];
        
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
