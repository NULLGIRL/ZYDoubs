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

@property (nonatomic,strong) UIView * headView;

@property (nonatomic,strong) UILabel * sipnumLabel;

@property (nonatomic,strong) UILabel * statusLabel;


@end

@implementation ZYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cellTitleArr = @[@"sip账号",@"消息设置",@"技术支持"];
    self.tableView.tableHeaderView = self.headView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.navigationItem.title = @"设置";
    [self setBlackTitle:@"设置" smallTitle:@"Setting" withVC:self.tabBarController];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"ZYMineTableviewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.cellTitleArr[indexPath.row];
    
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
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        _headView.backgroundColor = BGColor;
        
        [_headView addSubview:self.sipnumLabel];
        [_headView addSubview:self.statusLabel];
        
        [self.sipnumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_headView);
            make.height.equalTo(@30);
        }];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headView);
            make.top.equalTo(self.sipnumLabel.mas_bottom);
            make.height.equalTo(@30);
        }];
        
    }
    return _headView;
}

-(UILabel *)sipnumLabel{
    if (!_sipnumLabel) {
        _sipnumLabel = [[UILabel alloc]init];
        _sipnumLabel.text = @"sip账号:";
    }
    return _sipnumLabel;
}

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [UIColor redColor];
    }
    
    return _statusLabel;
}

@end
