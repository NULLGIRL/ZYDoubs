//
//  DontDisturbManager.m
//  PropertyManager
//
//  Created by Momo on 16/8/19.
//  Copyright © 2016年 Doubango Telecom. All rights reserved.
//

#import "DontDisturbManager.h"

@implementation DontDisturbManager
+(DontDisturbManager *)shareManager {
    static DontDisturbManager * _manager;
    if (_manager == nil) {
        _manager = [[DontDisturbManager alloc]init];
        _manager.isDontDisturb = NO;
        _manager.statTime = @"默认 00:00";
        _manager.endTime = @"默认 00:00";
    }
    return _manager;
}

-(BOOL)getDisturbStatusWithUsername:(NSString *)fusername{
    
    //数据库管理者
    MyFMDataBase * database = [MyFMDataBase shareMyFMDataBase];
    NSArray * disturbArr = [database selectDataWithTableName:DontDisturbInfo withDic:@{@"fusername":fusername}];
    NSLog(@"disturbArr === %@   fusername ==== %@",disturbArr,fusername);
    if (disturbArr.count == 0) {
        //没有数据 此时插入数据
        [database insertDataWithTableName:DontDisturbInfo insertDictionary:@{@"fusername":fusername,@"isDontDisturb":@"0",@"statTime":@"上午 00:00",@"endTime":@"上午 00:00"}];
        //勿扰模式单例
        
        self.isDontDisturb = NO;
        self.statTime = @"上午 00:00";
        self.endTime = @"上午 00:00";
        return NO;
    }
    else{
        //有数据
        NSDictionary * dic = disturbArr[0];
        if ([dic[@"isDontDisturb"] intValue] == 0) {
            self.isDontDisturb = NO;
        }
        else{
            self.isDontDisturb = YES;
        }
        self.statTime = dic[@"statTime"];
        self.endTime = dic[@"endTime"];
        
        return YES;
    }
}
@end
