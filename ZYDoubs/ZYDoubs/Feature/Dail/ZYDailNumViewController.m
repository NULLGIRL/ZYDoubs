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
@property (nonatomic,strong) UILabel * dailLabel;
@end

@implementation ZYDailNumViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubviews];
    
}

-(void)createSubviews{
    
    [self.view addSubview:self.dailLabel];
    [self.dailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-80);
        make.top.equalTo(self.view).with.offset(20);
        make.height.equalTo(@60);
    }];
    
    NSArray * titleArr = @[@"1",@"2",@"3",
                           @"4",@"5",@"6",
                           @"7",@"8",@"9",
                           @"语音",@"0",@"视频",
                           @"<-"];
    
    CGFloat btnWidth = ScreenWidth / 3.0;
    for (int i = 0; i < titleArr.count; i ++) {
        ZYButton * btn = [[ZYButton alloc]initWithTitle:titleArr[i] font:MiddleFont];
        btn.block = ^(NSString * reMark){
        
            [self btnClickBtn:reMark];
        };
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor yellowColor];
        
        if (i == titleArr.count - 1) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view).with.offset(-10);
                make.top.equalTo(self.view).with.offset(20);
                make.width.equalTo(@(60));
                make.height.equalTo(@60);
            }];
            
        }
        else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(i%3*btnWidth);
                make.top.equalTo(self.view).with.offset(i/3*100 + 150);
                make.width.equalTo(@(btnWidth));
                make.height.equalTo(@80);
            }];
            
        }
        
    }
}

-(void)btnClickBtn:(NSString *)remark{
    
    NSString * text = self.dailLabel.text;
    if ([remark isEqualToString:@"语音"]) {
        
        [ZYCallViewController makeAudioCallWithRemoteParty:text];
        
    }
    else if ([remark isEqualToString:@"视频"]){
        
    }
    else if ([remark isEqualToString:@"<-"]){
        
        if (text.length != 0) {
            self.dailLabel.text = [text substringToIndex:self.dailLabel.text.length - 1];
        }
        else{
            self.dailLabel.text = @"";
        }
    }
    else{
        
        self.dailLabel.text = [text stringByAppendingString:remark];
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


#pragma mark - 懒加载
-(UILabel *)dailLabel{
    if (!_dailLabel) {
        _dailLabel = [[UILabel alloc]init];
        _dailLabel.backgroundColor = [UIColor yellowColor];
        _dailLabel.text = @"";
        _dailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dailLabel;
}



@end
