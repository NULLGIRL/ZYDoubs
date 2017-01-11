//
//  ZYDoubangoMacros.h
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#ifndef ZYDoubangoMacros_h
#define ZYDoubangoMacros_h


#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"



#undef TAG
#define kTAG @"AppDelegate///: "
#define TAG kTAG

#define kNotifKey									@"key"
#define kNotifKey_IncomingCall						@"icall"
#define kNotifKey_IncomingMsg						@"imsg"
#define kNotifIncomingCall_SessionId				@"sid"
#define kNetworkAlertMsgThreedGNotEnabled			@"只有3G网络可用。请启用3G和再试一次。"
#define kNetworkAlertMsgNotReachable				@"没有网络连接。"
#define kNewMessageAlertText						@"你有一条新消息"
#define kAlertMsgButtonOkText						@"确认"
#define kAlertMsgButtonCancelText					@"取消"


// 语音视频等
#define kColorsDarkBlack [NSArray arrayWithObjects: \
(id)[[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:1] CGColor], \
(id)[[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1] CGColor], \
nil]

#define kColorsLightBlack [NSArray arrayWithObjects: \
(id)[[UIColor colorWithRed:.2f green:.2f blue:.2f alpha:0.7] CGColor], \
(id)[[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:0.7] CGColor], \
(id)[[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7] CGColor], \
nil]

#define kButtonStateAll (UIControlStateSelected | UIControlStateNormal | UIControlStateHighlighted | UIControlStateDisabled | UIControlStateApplication)

#define kCallTimerSuicide	0.0f
#define kQoSTimer           1.0f



#endif /* ZYDoubangoMacros_h */
