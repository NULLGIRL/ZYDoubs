//
//  ZYAudioViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAudioViewController.h"

@interface ZYAudioViewController ()

@end

@implementation ZYAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubviews];

}

-(void)createSubviews{
    
    NSArray * titleArr = @[@"1",@"2",@"3",
                           @"4",@"5",@"6",
                           @"7",@"8",@"9",
                           @"语音",@"0",@"视频"];
    
    CGFloat btnWidth = ScreenWidth / 3.0;
    for (int i = 0; i < titleArr.count; i ++) {
        ZYButton * btn = [[ZYButton alloc]initWithTitle:titleArr[i]];
        btn.block = ^(NSString * reMark){
            NSLog(@"点击了 %@",reMark);
        };
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor yellowColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(i%3*btnWidth);
            make.top.equalTo(self.view).with.offset(i/3*100 + 150);
            make.width.equalTo(@(btnWidth));
            make.height.equalTo(@80);
        }];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"拨号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
