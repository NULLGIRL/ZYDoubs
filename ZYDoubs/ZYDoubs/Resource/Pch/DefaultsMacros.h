//
//  DefaultsMacros.h
//  ZYDoubs
//
//  Created by Momo on 17/1/17.
//  Copyright © 2017年 Momo. All rights reserved.
//

#ifndef DefaultsMacros_h
#define DefaultsMacros_h

#define MyUserDefaults [NSUserDefaults standardUserDefaults]

// ************************ 勿扰模式 *****************************//
//是否打开勿扰模式
#define isOpenDnd [DontDisturbManager shareManager].isDontDisturb
//勿扰模式的开始时间
#define DNDStartTime [DontDisturbManager shareManager].statTime
//勿扰模式的结束时间
#define DNDEndTime [DontDisturbManager shareManager].endTime


// ************************ 消息设置 *****************************//
#define AllSoundOpen [MyUserDefaults boolForKey:@"news_AllSoundOpen"]
#define NewsSoundOpen [MyUserDefaults boolForKey:@"news_NewsSoundOpen"]
#define OrdersSoundOpen [MyUserDefaults boolForKey:@"news_OrdersSoundOpen"]

#define AllShakeOpen  [MyUserDefaults boolForKey:@"news_AllShakeOpen"]
#define NewsShakeOpen [MyUserDefaults boolForKey:@"news_NewsShakeOpen"]
#define OrdersShakeOpen  [MyUserDefaults boolForKey:@"news_OrdersShakeOpen"]

#define SetBoolDefaults(ret,key) [MyUserDefaults setBool:ret forKey:key]

#define BoolFromKey(key) [MyUserDefaults boolForKey:key]



#endif /* DefaultsMacros_h */
