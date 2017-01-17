//
//  ZYAudioViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAudioViewController.h"
#import "PSTAlertController.h"

@interface ZYAudioViewController ()

@property (nonatomic,strong) UILabel * dailLabel;

@end

@implementation ZYAudioViewController
@synthesize audioSession;

-(instancetype)init{
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self createDefaultSubviews];

        isOnLine = YES;
    }
    return self;
}

-(void)createDefaultSubviews{
    
    _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.image = [UIImage imageNamed:@"dailBG"];
    [self.view addSubview:_bgImageView];
    

    _nameLabel = [[ZYLabel alloc]initWithText:nil font:MiddleFont color:WHITECOLOR];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:_nameLabel];
    
    
    _labelStatus = [[ZYLabel alloc]initWithText:@"语音请求中..." font:LargeFont color:WHITECOLOR];
    _labelStatus.frame = CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 30, ScreenWidth, 30);
    _labelStatus.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:_labelStatus];
    
    
    //免提
    /*
     非ARC 下
     build setting -> Apple LLVM7.1 - Language - Objective C -> Weak References in Manual Retain Release YES。
     */
    WEAKSELF
    _handsFreeBtn = [[ZYButton alloc]initWithTitle:@"免提" font:MiddleFont color:WHITECOLOR selectColor:REDCOLOR];
    _handsFreeBtn.block = ^(NSString * reMark){
        
        [weakSelf handsFreeBtnClick];
    };
    [_bgImageView addSubview:_handsFreeBtn];
    
    
    //静音
    _muteBtn = [[ZYButton alloc]initWithTitle:@"静音" font:MiddleFont color:WHITECOLOR selectColor:REDCOLOR];
    _muteBtn.block = ^(NSString * reMark){
        
        [weakSelf muteBtnClick];
    };
    [_bgImageView addSubview:_muteBtn];
    

    //挂断
    _buttonHangup = [[ZYButton alloc]initWithTitle:@"挂断" font:MiddleFont color:REDCOLOR selectColor:nil];
    _buttonHangup.block = ^(NSString * reMark){
        
        [weakSelf buttonHangupClick];
    };
    [_buttonHangup layerCornerRadius:15.0f borderWidth:1.0f borderColor:REDCOLOR];
    [_bgImageView addSubview:_buttonHangup];
    
    //接受
    _buttonAccept = [[ZYButton alloc]initWithTitle:@"接受" font:MiddleFont color:GREENCOLOR selectColor:nil];
    _buttonAccept.block = ^(NSString * reMark){
        
        [weakSelf buttonAcceptClick];
    };
    [_buttonAccept layerCornerRadius:15.0f borderWidth:1.0f borderColor:GREENCOLOR];
    [_bgImageView addSubview:_buttonAccept];
    
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).with.offset(20);
        make.right.equalTo(_bgImageView).with.offset(-20);
        make.top.equalTo(_bgImageView).with.offset(100);
        make.height.equalTo(@30);
    }];
    
    [_labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(10);
        make.height.equalTo(@30);
    }];
    
    [_handsFreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bgImageView).with.offset(15);
        make.width.equalTo(@45);
        make.top.equalTo(_bgImageView.mas_bottom).with.offset(-60);
        make.height.equalTo(@30);
        
    }];
    
    [_muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_bgImageView).with.offset(-15);
        make.width.equalTo(@45);
        make.top.equalTo(_handsFreeBtn);
        make.height.equalTo(@30);
    }];
    
    [_buttonHangup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_handsFreeBtn).with.offset(20);
        make.right.equalTo(_muteBtn.mas_left).with.offset(-20);
        make.top.equalTo(_handsFreeBtn);
        make.height.equalTo(@30);
    }];
    
    [_buttonAccept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonHangup);
        make.right.equalTo(_buttonHangup);
        make.top.equalTo(_buttonHangup.mas_bottom).with.offset(10);
        make.height.equalTo(_buttonHangup);
    }];
    
}

//挂断
- (void) buttonHangupClick{
    
    //挂断
    if(audioSession && [audioSession isConnected]) {
        SYLog(@"videoSession 存在  连接");
        [audioSession hangUpCall];
        // releases session
        [NgnAVSession releaseSession:&audioSession];
        // starts timer suicide
        [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                         target:self
                                       selector:@selector(timerSuicideTick:)
                                       userInfo:nil
                                        repeats:NO];
        
    }
    else if (audioSession && ![audioSession isConnected]){
        SYLog(@"videoSession 存在  但未连接");
        [audioSession hangUpCall];
        [NgnAVSession releaseSession:&audioSession];
        [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                         target:self
                                       selector:@selector(timerSuicideTick:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else{
        SYLog(@"videoSession 为空  挂断不起作用");
        [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                         target:self
                                       selector:@selector(timerSuicideTick:)
                                       userInfo:nil
                                        repeats:NO];
    }
    
}
//接受
- (void) buttonAcceptClick{
    if(audioSession){
        [audioSession acceptCall];
    }
}

//免提
- (void)handsFreeBtnClick{
    
    [audioSession setSpeakerEnabled:![audioSession isSpeakerEnabled]];
    if([[NgnEngine sharedInstance].soundService setSpeakerEnabled:[audioSession isSpeakerEnabled]]){
        self.handsFreeBtn.selected = [audioSession isSpeakerEnabled];
    }
}

//静音
- (void)muteBtnClick{
    
    //    self.muteBtn.selected = !self.muteBtn.selected;
    
    if([audioSession setMute:![audioSession isMuted]]){
        self.muteBtn.selected = [audioSession isMuted];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onInviteEvent:) name:kNgnInviteEventArgs_Name object:nil];
    //监听占线
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LineISBusy) name:@"LineISBusy" object:nil];

}
-(void)LineISBusy{
    NSLog(@"占线");
    
    _dismiss = [PSTAlertController presentDismissableAlertWithTitle:@"⚠️\n" message:@"对方已占线，请稍后尝试！" controller:self];
    [_dismiss addDidDismissBlock:^(PSTAlertAction * _Nonnull action) {
        [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                         target:self
                                       selector:@selector(timerSuicideTick:)
                                       userInfo:nil
                                        repeats:NO];
    }];
}

-(void)LineISBusyView{
    
    [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:NO];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(audioSession){
        [audioSession setSpeakerEnabled:YES];
        self.nameLabel.text = audioSession.displayName;
        [[NgnEngine sharedInstance].soundService setSpeakerEnabled:YES];
    }
   
    isOnLine = YES;
    
    //默认打开免提
    self.handsFreeBtn.selected = YES;
    self.muteBtn.selected = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NgnAVSession releaseSession: &audioSession];
    
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    SYLog(@"语音通话界面 内存警告");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [_labelStatus release];
    [_buttonHangup release];
    [_buttonAccept release];
    [super dealloc];
}

#pragma mark - 关闭页面

-(void)timerSuicideTick:(NSTimer*)timer{
    [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:NO];
}

-(void) closeView{
    [[NgnEngine sharedInstance].soundService stopRingBackTone];
    [[NgnEngine sharedInstance].soundService stopRingTone];
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - 通知
-(void) onInviteEvent:(NSNotification*)notification {
    
    NgnInviteEventArgs* eargs = [notification object];
    
    if(!audioSession || audioSession.id != eargs.sessionId){
    }
    
    if (!eargs.otherIsOnLine) {
        self.labelStatus.text = @"对方不在线...";
        isOnLine = NO;
        self.dismiss = [PSTAlertController presentDismissableAlertWithTitle:@"⚠️\n" message:@"对方不在线，请稍后尝试！" controller:self];
    }
    
    if (eargs.otherNotAnswer) {
        self.labelStatus.text = @"无人接听...";
    }
    
    
    switch (eargs.otherInCallstate) {
        case OTHER_DEFAULT:{
            break;
        }
            
        case OTHER_ANSWER_NOT:{
            self.labelStatus.text = @"无人接听...";
            NSLog(@"~~~~~对方没有接听");
            break;
        }
            
        case OTHER_ANSWER_OR_REJECT:{
            self.labelStatus.text = @"对方接听或拒绝...";
            NSLog(@"~~~~~对方接听或拒绝");
            
            break;
        }
            
        case OTHER_REJECT:{
            self.labelStatus.text = @"对方已挂断...";
            break;
        }
    }
    
    
    
    
    switch (eargs.eventType) {
        case INVITE_EVENT_INPROGRESS:
        case INVITE_EVENT_INCOMING:
        case INVITE_EVENT_RINGING:
        case INVITE_EVENT_LOCAL_HOLD_OK:
        case INVITE_EVENT_REMOTE_HOLD:
        default:
        {
            // updates view and state
            [self updateViewAndState];
            break;
        }
            
            // transilient events
        case INVITE_EVENT_MEDIA_UPDATING:
        {
            [audioSession setSpeakerEnabled:YES];
            self.labelStatus.text = @"语音来电..";
            break;
        }
            
        case INVITE_EVENT_MEDIA_UPDATED:
        {
            self.labelStatus.text = @"语音结束中..";
            break;
        }
            
        case INVITE_EVENT_TERMINATED:
        case INVITE_EVENT_TERMWAIT:
        {
            // updates view and state
            [self updateViewAndState];
            // releases session
            [NgnAVSession releaseSession: &audioSession];
            // starts timer suicide
            
            
            if (!isOnLine) {
                [self.dismiss addDidDismissBlock:^(PSTAlertAction * _Nonnull action) {
                    [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                                     target:self
                                                   selector:@selector(timerSuicideTick:)
                                                   userInfo:nil
                                                    repeats:NO];
                }];
                
            }
            else{
                [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                                 target:self
                                               selector:@selector(timerSuicideTick:)
                                               userInfo:nil
                                                repeats:NO];
            }
            
            break;
        }
            
            
    }
    
    
}

#pragma mark - 状态更新
-(void) updateViewAndState{
    
    if(audioSession){
        switch (audioSession.state) {
            case INVITE_STATE_INPROGRESS:
            {
                self.labelStatus.text = @"语音请求中...";
                
                self.buttonAccept.hidden = YES;
                self.buttonHangup.hidden = NO;
                
                [self.buttonHangup setTitle:@"结束" forState:kButtonStateAll];
                break;
            }
            case INVITE_STATE_INCOMING:
            {
                self.labelStatus.text = @"语音来电...";
                
                
                [self.buttonHangup setTitle:@"挂断" forState:kButtonStateAll];
                self.buttonHangup.hidden = NO;
                
                
                [self.buttonAccept setTitle:@"接受" forState:kButtonStateAll];
                self.buttonAccept.hidden = NO;
                
                [self.buttonHangup setTitle:@"挂断" forState:UIControlStateNormal];
                
                self.buttonAccept.hidden = NO;
                
                
                // 勿扰模式
//                BOOL isOpen = isOpenDnd;
//                BOOL res = [PMSipTools isBetweenTime];
//                if (isOpen && res) {
//                    
//                    SYLog(@"开启勿扰模式 且 在时间范围内 不打扰");
//                    [PMSipTools stopRing];
//                    
//                }
//                else{
//                    SYLog(@"没开启勿扰模式");
//                    [PMSipTools playRing];
//                    
//                }
                
                
                break;
            }
            case INVITE_STATE_REMOTE_RINGING:
            {
                self.labelStatus.text = @"正在语音通话...";
                
                self.buttonAccept.hidden = YES;
                
                [self.buttonHangup setTitle:@"结束" forState:kButtonStateAll];
                self.buttonHangup.hidden = NO;
                
                [audioSession setSpeakerEnabled:YES];
                [[[NgnEngine sharedInstance] getSoundService] stopRingTone];
                [[[NgnEngine sharedInstance] getSoundService] stopRingBackTone];
                break;
            }
            case INVITE_STATE_INCALL:
            {
                self.labelStatus.text = @"正在语音通话...";
                
                self.buttonAccept.hidden = YES;
                self.buttonHangup.hidden = NO;
                
                [[NgnEngine sharedInstance].soundService setSpeakerEnabled:[audioSession isSpeakerEnabled]];
                [[NgnEngine sharedInstance].soundService stopRingBackTone];
                [[NgnEngine sharedInstance].soundService stopRingTone];
                
                break;
            }
            case INVITE_STATE_TERMINATED:
            case INVITE_STATE_TERMINATING:
            {
                self.labelStatus.text = @"语音结束中...";
                
                self.buttonAccept.hidden = YES;
                self.buttonHangup.hidden = YES;
                
                [[NgnEngine sharedInstance].soundService stopRingBackTone];
                [[NgnEngine sharedInstance].soundService stopRingTone];
                break;
            }
                
                
                
            default:
                break;
                
                
        }
        
        
    }
}





@end
