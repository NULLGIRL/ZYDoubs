//
//  ZYDailNumViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/16.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYDailNumViewController.h"
#import "ZYCallViewController.h"

@interface ZYDailNumViewController ()
@property (nonatomic,strong) ZYLabel * dailLabel;
@end

@implementation ZYDailNumViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ZYTools colorFromHexRGB:@"f1efef"];
    
    [self createSubviews];
    
}

-(void)createSubviews{
    
    self.dailLabel = [[ZYLabel alloc]initWithText:@"" font:[UIFont boldSystemFontOfSize:35]];
    self.dailLabel.userInteractionEnabled = YES;
    self.dailLabel.frame = CGRectMake(0, 0, ScreenWidth, 100);
    self.dailLabel.backgroundColor = WHITECOLOR;
    [self.view addSubview:self.dailLabel];
    
    ZYButton * plusBtn = [[ZYButton alloc] initWithTitle:@"" font:nil withImage:@"Plus2" selectImage:nil];
    plusBtn.reMark = @"增加";
    plusBtn.block = ^(NSString * reMark){
        [self btnClickBtn:reMark];
    };
    [self.dailLabel addSubview:plusBtn];
    
    ZYButton * deleteBtn = [[ZYButton alloc] initWithTitle:@"" font:nil withImage:@"Delete" selectImage:nil];
    deleteBtn.reMark = @"<-";
    deleteBtn.block = ^(NSString * reMark){
        [self btnClickBtn:reMark];
    };
    [self.dailLabel addSubview:deleteBtn];
    
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dailLabel).with.offset(20);
        make.width.equalTo(@30);
        make.top.equalTo(self.dailLabel).with.offset(25);
        make.height.equalTo(@40);
    }];

    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dailLabel).with.offset(-20);
        make.width.equalTo(@50);
        make.top.equalTo(plusBtn);
        make.height.equalTo(plusBtn);
    }];

    
    NSArray * numArr = @[@"1",@"2",@"3",
                           @"4",@"5",@"6",
                           @"7",@"8",@"9",
                           @"*",@"0",@"#"
                           ];
    
    CGFloat btnWidth = 80;
    CGFloat btnLeft = (ScreenWidth - 3 * btnWidth) / 4.0;
    
    for (int i = 0; i < numArr.count; i ++) {
        ZYButton * btn = [[ZYButton alloc]initWithTitle:numArr[i] font:[UIFont systemFontOfSize:35]];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_num"] forState:UIControlStateNormal];
        btn.block = ^(NSString * reMark){
        
            [self btnClickBtn:reMark];
        };
        [self.view addSubview:btn];
        
        
        if (i != 9) {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
        }
        else{
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(i%3*(btnWidth + btnLeft) + btnLeft);
            make.top.equalTo(self.dailLabel.mas_bottom).with.offset(i/3*(btnWidth + 10) + 20);
            make.width.equalTo(@(btnWidth));
            make.height.equalTo(@(btnWidth));
        }];
    }
    
    NSArray * dailArr = @[@"语音通话",@"视频通话"];
    NSArray * imageArr = @[@"phonecall",@"vedio"];
    NSArray * colorArr = @[[ZYTools colorFromHexRGB:@"448aca"],[ZYTools colorFromHexRGB:@"8fd06c"]];
    
    CGFloat dailWidth = 130;
    CGFloat dailLeft = (ScreenWidth - 2 * dailWidth) / 3.0;
    CGFloat btnBottomY = numArr.count / 3 * (btnWidth + 10) + 20 + btnWidth;
    for (int i = 0; i < dailArr.count; i ++) {
        
        ZYButton * btn = [[ZYButton alloc]initWithTitle:dailArr[i] font:LargeFont withImage:imageArr[i] selectImage:nil];
        [btn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        UIColor * color = colorArr[i];
        btn.backgroundColor = color;
        [btn layerCornerRadius:8.0f borderWidth:1.0f borderColor:color];
        btn.block = ^(NSString * reMark){
            
            [self btnClickBtn:reMark];
        };
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(i*(dailWidth + dailLeft) + dailLeft);
            make.top.equalTo(self.dailLabel).with.offset(btnBottomY + 30);
            make.width.equalTo(@(dailWidth));
            make.height.equalTo(@50);
        }];
     
    }
}

-(void)btnClickBtn:(NSString *)remark{
    
    NSString * text = self.dailLabel.text;
    if ([remark isEqualToString:@"语音通话"]) {
        
        if (![[NgnEngine sharedInstance].sipService isRegistered]) {
            [CNUIHelper toast:@"sip未注册，请先去设置页面注册sip"];
            return;
        }
        
        [ZYCallViewController makeAudioCallWithRemoteParty:text];
        
    }
    else if ([remark isEqualToString:@"视频通话"]){
        if (![[NgnEngine sharedInstance].sipService isRegistered]) {
            [CNUIHelper toast:@"sip未注册，请先去设置页面注册sip"];
            return;
        }
        [ZYCallViewController makeAudioVideoCallWithRemoteParty:text];
        
    }
    else if ([remark isEqualToString:@"<-"]){
        
        if (text.length != 0) {
            self.dailLabel.text = [text substringToIndex:self.dailLabel.text.length - 1];
        }
        else{
            self.dailLabel.text = @"";
        }
    }
    else if ([remark isEqualToString:@"增加"]){
        
        
    }
    else{
        
        self.dailLabel.text = [text stringByAppendingString:remark];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBlackTitle:@"拨号" smallTitle:@"Call" withVC:self.tabBarController];
    [self createRightBarButtonItemWithImage:@"Menu" WithTitle:@"" withMethod:@selector(MoreBtnClick) withVC:self.tabBarController];
}

-(void)MoreBtnClick{
    NSLog(@"菜单列表");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
