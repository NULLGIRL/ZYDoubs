//
//  ZYSipSettingViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/12.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYSipSettingViewController.h"

@interface ZYSipSettingViewController ()

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
    
    NSArray * placeArr = @[@"请输入sip账号（eg:1001）",
                           @"请输入密码",
                           @"请输入realm",
                           @"请输入port",
                           @"请输入传输协议(tcp或udp)"
                           ];
    
    for (int i = 0 ; i < placeArr.count ; i ++) {
        NSInteger textFieldTag = 100 + i;
        ZYTextField * textField = [[ZYTextField alloc]initWithPlaceText:placeArr[i] font:MiddleFont tag:textFieldTag];
        [self.view addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.top.equalTo(self.view).with.offset(i * 60 + 50);
            make.height.equalTo(@30);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
