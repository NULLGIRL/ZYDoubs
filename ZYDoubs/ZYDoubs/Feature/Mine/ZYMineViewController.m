//
//  ZYMineViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMineViewController.h"

@interface ZYMineViewController ()


@property (nonatomic,strong) NSArray * cellTitleArr;

@property (nonatomic,strong) UIImageView * headView;

@property (nonatomic,strong) UIImageView * iconImage;

@property (nonatomic,strong) ZYLabel * sipnumLabel;

@property (nonatomic,strong) ZYLabel * statusLabel;


@end

@implementation ZYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cellTitleArr = @[@"信息设置",@"切换账号",@"技术支持",@"意见反馈",@"退出"];
    self.tableView.tableHeaderView = self.headView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.navigationItem.title = @"设置";
//    [self setBlackTitle:@"设置" smallTitle:@"Setting" withVC:self.tabBarController];
//    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    self.tabBarController.navigationController.navigationBar.hidden = YES;
    
    NSString * impi = [[NgnEngine sharedInstance].configurationService getStringWithKey:IDENTITY_IMPI];
    if (![ZYTools isNullOrEmpty:impi]) {
        self.sipnumLabel.text = [NSString stringWithFormat:@"sip账号:%@",impi];
        
        if ([[NgnEngine sharedInstance].sipService isRegistered]) {
            self.statusLabel.textColor = [UIColor greenColor];
            self.statusLabel.text = @"已注册";
        }
        else{
            self.statusLabel.textColor = [UIColor redColor];
            self.statusLabel.text = @"未注册";
        }
    }
  
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    self.tabBarController.navigationController.navigationBar.hidden = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"ZYMineTableviewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    ZYLabel * label = [[ZYLabel alloc] initWithText:self.cellTitleArr[indexPath.row] font:LargeFont color:mainTextColor];
    label.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [cell.contentView addSubview:label];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLogInfo(@"选中");
    
    if (indexPath.row == 0) {
        NSLog(@"设置sip账号");
        [[Routable sharedRouter] open:ZYSIPSETTING_VIEWCONTROLLER];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 懒加载
-(UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 272)];
        _headView.userInteractionEnabled = YES;
        _headView.image = [UIImage imageNamed:@"setting-bj"];
        
        [_headView addSubview:self.iconImage];
        [_headView addSubview:self.sipnumLabel];
        [_headView addSubview:self.statusLabel];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headView);
            make.top.equalTo(_headView).with.offset(50);
            make.height.equalTo(@100);
            make.width.equalTo(@100);
        }];
        
        
        [self.sipnumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).with.offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@(ScreenWidth));
        }];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sipnumLabel.mas_bottom).with.offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@(ScreenWidth));
        }];
        
        self.iconImage.layer.cornerRadius = 50.0f;
        
    }
    return _headView;
}

-(ZYLabel *)sipnumLabel{
    if (!_sipnumLabel) {
        _sipnumLabel = [[ZYLabel alloc]initWithText:@"sip账号:" font:LargeFont color:mainTextColor];
    }
    return _sipnumLabel;
}

-(ZYLabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[ZYLabel alloc]initWithText:@"注册状态：未登陆" font:MiddleFont color:mainTextColor];
        _statusLabel.textColor = [UIColor redColor];
    }
    
    return _statusLabel;
}

-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.clipsToBounds = YES;
        _iconImage.backgroundColor = [UIColor greenColor];
    }
    return _iconImage;
}

@end
