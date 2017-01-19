//
//  DontDisturbManager.h
//  PropertyManager
//
//  Created by Momo on 16/8/19.
//  Copyright © 2016年 Doubango Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DontDisturbManager : NSObject

/** 是否设置勿扰模式 YES：是 NO：不是*/
@property (nonatomic,assign) BOOL isDontDisturb;
/** 开始时间*/
@property (nonatomic,strong) NSString * statTime;
/** 结束时间*/
@property (nonatomic,strong) NSString * endTime;

//创建用户管理单例
+ (DontDisturbManager *)shareManager;
/** 查询用户的勿扰模式状态 YES:数据库有数据 NO:数据库无数据*/
-(BOOL)getDisturbStatusWithUsername:(NSString *)fusername;

/** 关闭勿扰模式*/
//- (void) closeDisturbWithUsername:(NSString *)fusername;

@end
