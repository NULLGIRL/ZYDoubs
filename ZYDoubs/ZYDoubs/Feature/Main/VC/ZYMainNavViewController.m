//
//  ZYMainNavViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMainNavViewController.h"

@interface ZYMainNavViewController ()

@end

@implementation ZYMainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.hidden = NO;
    
    self.navigationBar.translucent = NO;
    
    //黑底白字
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.navigationBar.barTintColor = MainColor;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
