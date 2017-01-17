//
//  ZYAudioViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBaseViewController.h"

@class PSTAlertController;

@interface ZYAudioViewController : ZYBaseViewController
{
    //是否在线
    BOOL isOnLine;
    
    NgnAVSession* audioSession;
}

/**
    语音session
 */
@property (nonatomic,strong) NgnAVSession * audioSession;

/**
    背景图片
 */
@property (nonatomic,strong) UIImageView * bgImageView;

/**
    对方昵称显示
 */
@property (nonatomic,strong) ZYLabel * nameLabel;

/**
    对方账号显示
 */
@property (nonatomic,strong) ZYLabel * sipnumLabel;

/**
    通话状态显示
 */
@property (nonatomic,strong) ZYLabel * labelStatus;

/**
    免提按钮
 */
@property (nonatomic,strong) ZYButton * handsFreeBtn;

/**
    静音按钮
 */
@property (nonatomic,strong) ZYButton * muteBtn;

/**
    拒绝/挂断按钮
 */
@property (nonatomic,strong) ZYButton *buttonHangup;

/**
    接受按钮
 */
@property (nonatomic,strong) ZYButton *buttonAccept;

/**  
    提示对方是否在线、占线等
 */
@property (strong, nonatomic) PSTAlertController *dismiss;

@end
