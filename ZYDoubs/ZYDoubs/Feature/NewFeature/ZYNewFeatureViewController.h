//
//  ZYNewFeatureViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBaseViewController.h"

#define Key_Window [UIApplication sharedApplication].keyWindow

@interface ZYNewFeatureViewController : ZYBaseViewController

/** 封面图片 */
@property (nonatomic, strong) NSArray *guideImagesArr;
/** 视频地址 */
@property (nonatomic, strong) NSArray *guideMoviePathArr;
/** 最后一个视频播放完毕 */
@property (nonatomic, copy) void (^lastOnePlayFinished)();


/*
 *  是否应该显示版本新特性界面
 */
+ (BOOL)canShowNewFeature;


@end
