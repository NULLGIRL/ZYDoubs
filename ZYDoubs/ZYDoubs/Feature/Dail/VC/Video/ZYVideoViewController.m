//
//  ZYVideoViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYVideoViewController.h"
#import "PSTAlertController.h"
@interface ZYVideoViewController ()
{
    BOOL sendingVideo;
    BOOL isOnLine;
}

@property (retain, nonatomic) NSTimer* timerQoS;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIView* viewLocalVideo;
@property (strong, nonatomic) iOSGLView * glViewVideoRemote;
@property (strong, nonatomic) UIView* viewTop;
@property (strong, nonatomic) UIImageView *myIconImageView;
@property (strong, nonatomic) ZYLabel *nameL;
@property (strong, nonatomic) ZYLabel *nameLabel;
@property (strong, nonatomic) ZYLabel *labelStatus;
@property (strong, nonatomic) ZYButton *buttonAccept;
@property (strong, nonatomic) ZYButton *buttonHangup;
@property (strong, nonatomic) ZYButton *handsFreeBtn;
@property (strong, nonatomic) ZYButton *muteBtn;


@property (strong, nonatomic) UIView* viewToolbar;
@property (strong, nonatomic) ZYButton *buttonToolBarMute;
@property (strong, nonatomic) ZYButton *buttonToolBarEnd;
@property (strong, nonatomic) ZYButton *buttonToolBarToggle;

@property (strong, nonatomic) PSTAlertController *dismiss;

@end

@implementation ZYVideoViewController
@synthesize videoSession;

-(instancetype)init{
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        
        self->sendingVideo = YES;
        isOnLine = YES;
        
        [self createDefaultSubviews];
    }
    return self;
}


-(void)createDefaultSubviews{

    _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bgImageView];
    
    //本地视频图像
    _viewLocalVideo = [[UIView alloc]init];
    _viewLocalVideo.layer.borderWidth = 1.f;
    _viewLocalVideo.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:_viewLocalVideo];
    _viewLocalVideo.hidden = YES;
    
    
    //viewTop
    _viewTop = [[UIView alloc]init];
    _viewTop.backgroundColor = [UIColor clearColor];
    _viewTop.frame = self.view.bounds;
    [self.view addSubview:_viewTop];
    
    
    _myIconImageView = [[UIImageView alloc]init];
    _myIconImageView.backgroundColor = [UIColor greenColor];
    _myIconImageView.layer.cornerRadius = 45.0f;
    _myIconImageView.clipsToBounds = YES;
    [self.viewTop addSubview:_myIconImageView];
    
    
    _nameL = [[ZYLabel alloc]initWithText:@"" color:WHITECOLOR];
    _nameL.textAlignment = NSTextAlignmentCenter;
    [self.myIconImageView addSubview:_nameL];
    
    
    _nameLabel = [[ZYLabel alloc]initWithText:@"" font:MiddleFont color:WHITECOLOR];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.viewTop addSubview:_nameLabel];
    
    
    _labelStatus = [[ZYLabel alloc]initWithText:@"语音请求中..." font:LargeFont color:WHITECOLOR];
    _labelStatus.textAlignment = NSTextAlignmentCenter;
    [self.viewTop addSubview:_labelStatus];
    
    //免提
    _handsFreeBtn = [[ZYButton alloc]initWithTitle:@"免提" font:MiddleFont color:WHITECOLOR selectColor:REDCOLOR];
    _handsFreeBtn.block = ^(NSString * reMake){
        [self btnClick:@"免提"];
    };
    [self.viewTop addSubview:_handsFreeBtn];
    
    
    //静音
    _muteBtn = [[ZYButton alloc]initWithTitle:@"静音" font:MiddleFont color:WHITECOLOR selectColor:REDCOLOR];
    _muteBtn.block = ^(NSString * reMake){
        [self btnClick:@"静音"];
    };
    [self.viewTop addSubview:_muteBtn];
    
    
    //挂断
    _buttonHangup = [[ZYButton alloc]initWithTitle:@"挂断" font:MiddleFont color:REDCOLOR selectColor:nil];
    _buttonHangup.block = ^(NSString * reMake){
        [self btnClick:@"挂断"];
    };
    [_buttonHangup layerCornerRadius:15 borderWidth:1.0f borderColor:REDCOLOR];
    [self.viewTop addSubview:_buttonHangup];
    
    //接受
    _buttonAccept = [[ZYButton alloc]initWithTitle:@"接受" font:MiddleFont color:GREENCOLOR selectColor:nil];
    _buttonAccept.block = ^(NSString * reMake){
        [self btnClick:@"接受"];
    };
    [_buttonAccept layerCornerRadius:15 borderWidth:1.0f borderColor:GREENCOLOR];
    [self.viewTop addSubview:self.buttonAccept];
    
    

    _viewToolbar = [[UIView alloc]init];
    _viewToolbar.hidden = YES;
    [self.view addSubview:_viewToolbar];
    
    //前置后置
    _buttonToolBarToggle = [[ZYButton alloc]initWithTitle:@"后置" font:MiddleFont color:WHITECOLOR selectColor:REDCOLOR];
    _buttonToolBarToggle.block = ^(NSString * reMake){
        [self btnClick:@"后置"];
    };
    [self.viewToolbar addSubview:_buttonToolBarToggle];
    
    //视频中挂断
    _buttonToolBarEnd = [[ZYButton alloc]initWithTitle:@"挂断" font:MiddleFont color:REDCOLOR selectColor:nil];
    _buttonToolBarEnd.block = ^(NSString * reMake){
        [self btnClick:@"挂断"];
    };
    [_buttonToolBarEnd layerCornerRadius:15.0f borderWidth:1.0f borderColor:REDCOLOR];
    [self.viewToolbar addSubview:_buttonToolBarEnd];
    
    //静音
    _buttonToolBarMute = [[ZYButton alloc]initWithTitle:@"静音" font:MiddleFont color:WHITECOLOR selectColor:REDCOLOR];
    _buttonToolBarMute.block = ^(NSString * reMake){
        [self btnClick:@"静音"];
    };
    [self.viewToolbar addSubview:_buttonToolBarMute];
    
    _buttonToolBarEnd.backgroundColor =
    _buttonToolBarMute.backgroundColor =
    _buttonToolBarToggle.backgroundColor =
    [UIColor clearColor];
    
    // GLView
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glViewVideoRemote = [[[iOSGLView alloc] initWithFrame:screenBounds] autorelease];
    [self.view insertSubview:self.glViewVideoRemote atIndex:0];
    
    
    [_viewLocalVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.view).with.offset(20);
        make.height.equalTo(@64);
        make.width.equalTo(@86);
    }];
    
    [_viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [_myIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewTop);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
        make.top.equalTo(self.viewTop).with.offset(100);
    }];
    
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_myIconImageView);
        make.left.equalTo(_myIconImageView);
        make.top.equalTo(_myIconImageView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTop);
        make.right.equalTo(self.viewTop);
        make.top.equalTo(_myIconImageView.mas_bottom).with.offset(20);
        make.height.equalTo(@30);
    }];
    
    [_labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTop);
        make.right.equalTo(self.viewTop);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(30);
        make.height.equalTo(@30);
    }];
    
    [_handsFreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTop).with.offset(15);
        make.width.equalTo(@45);
        make.top.equalTo(self.viewTop.mas_bottom).with.offset(-60);
        make.height.equalTo(@30);
    }];
    
    [_muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewTop).with.offset(-15);
        make.width.equalTo(@45);
        make.top.equalTo(self.viewTop.mas_bottom).with.offset(-60);
        make.height.equalTo(@30);
    }];
    
    [_buttonHangup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_handsFreeBtn.mas_right).with.offset(20);
        make.right.equalTo(_muteBtn.mas_left).with.offset(-20);
        make.top.equalTo(_muteBtn);
        make.height.equalTo(@30);
    }];

    [_buttonAccept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonHangup);
        make.right.equalTo(_buttonHangup);
        make.bottom.equalTo(_buttonHangup.mas_top).with.offset(-20);
        make.height.equalTo(@30);
    }];
    
    [_viewToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTop);
        make.right.equalTo(self.viewTop);
        make.top.equalTo(self.viewTop.mas_bottom).with.offset(-60);
        make.height.equalTo(@44);
    }];
    
    [_buttonToolBarToggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewToolbar).with.offset(15);
        make.width.equalTo(@30);
        make.top.equalTo(_viewToolbar);
        make.height.equalTo(@30);
    }];
    
    [_buttonToolBarMute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_viewToolbar).with.offset(-15);
        make.width.equalTo(@30);
        make.top.equalTo(_viewToolbar);
        make.height.equalTo(@30);
    }];
    
    //    _buttonToolBarEnd.frame = CGRectMake(60,0, ScreenWidth - 120,30);
    [_buttonToolBarEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonToolBarToggle.mas_right).with.offset(15);
        make.right.equalTo(_buttonToolBarMute.mas_left).with.offset(-15);
        make.top.equalTo(_viewToolbar);
        make.height.equalTo(@30);
    }];
    
}

- (void) btnClick:(NSString *)remark{
    if ([remark isEqualToString:@"免提"]) {
        
        [self handsFreeBtnClick:_handsFreeBtn];
    }
    else if ([remark isEqualToString:@"静音"]) {
        
        [self muteBtnClick:_muteBtn];
    }
    else if ([remark isEqualToString:@"挂断"]) {
        [self buttonHangupClick];
    }
    else if ([remark isEqualToString:@"接受"]) {
        [self buttonAcceptClick];
    }
    else if ([remark isEqualToString:@"后置"]) {
        [self btnToggleClick];
    }
    
}

#pragma mark - 按钮事件
// 切换摄像头
-(void)btnToggleClick{
    if(videoSession){
        self.buttonToolBarToggle.selected = !self.buttonToolBarToggle.selected;
        [videoSession toggleCamera];
    }
}

//挂断
- (void) buttonHangupClick{
    if(videoSession) {
        SYLog(@"videoSession 存在");
        [videoSession hangUpCall];
        // releases session
        [NgnAVSession releaseSession:&videoSession];
        // starts timer suicide
        [NSTimer scheduledTimerWithTimeInterval:kCallTimerSuicide
                                         target:self
                                       selector:@selector(timerSuicideTick:)
                                       userInfo:nil
                                        repeats:NO];
        
    }
    else {
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
    if(videoSession){
        [videoSession acceptCall];
    }
}

//免提
- (void)handsFreeBtnClick:(UIButton *)sender {
    
    [videoSession setSpeakerEnabled:![videoSession isSpeakerEnabled]];
    if([[NgnEngine sharedInstance].soundService setSpeakerEnabled:[videoSession isSpeakerEnabled]]){
        sender.selected = [videoSession isSpeakerEnabled];
    }
    
}

//静音
- (void)muteBtnClick:(UIButton *)sender{
    
    self.muteBtn.selected = !self.muteBtn.selected;
    [videoSession setMute:self.muteBtn.selected];
    self.muteBtn.selected = [videoSession isMuted];
}

// 视频中静音
-(void)toolbarMuteClick{
    self.buttonToolBarMute.selected = !self.buttonToolBarMute.selected;
    [videoSession setMute:![videoSession isMuted]];
    self.buttonToolBarMute.selected = [videoSession isMuted];
    [self showBottomView:self.viewToolbar shouldRefresh:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // listen to the events
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onInviteEvent:) name:kNgnInviteEventArgs_Name object:nil];
    
    //监听占线
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LineISBusy) name:@"LineISBusy" object:nil];
    
}

-(void)LineISBusy{
    NSLog(@"占线");
    
    
    _dismiss = [PSTAlertController presentDismissableAlertWithTitle:@"⚠️\n" message:@"对方已占线,请稍后尝试" controller:self];
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
    if(videoSession){
        if([videoSession isConnected]){
            [videoSession setSpeakerEnabled:YES];
            [videoSession setRemoteVideoDisplay:self.glViewVideoRemote];
            [videoSession setLocalVideoDisplay:self.viewLocalVideo];
        }
    }
    [self updateVideoOrientation];
    [self updateRemoteDeviceInfo];
    
    isOnLine = YES;
    self.handsFreeBtn.selected = YES;
    self.muteBtn.selected = NO;
    self.buttonToolBarToggle.selected = NO;
    self.buttonToolBarMute.selected = NO;
    
    self.nameLabel.text = videoSession.displayName;
    self.nameL.text = [ZYTools subStringFromString:videoSession.displayName isFrom:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(videoSession && [videoSession isConnected]){
        [videoSession setRemoteVideoDisplay:nil];
        [videoSession setLocalVideoDisplay:nil];
    }
    [NgnAVSession releaseSession: &videoSession];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [NgnCamera setPreview:nil];
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self updateVideoOrientation];
    
    if(!self.viewToolbar.hidden){
        [self showBottomView:self.viewToolbar shouldRefresh:YES];
    }
    
    [self sendDeviceInfo];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    SYLog(@"视频通话界面 内存警告");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
    
    
    [self.viewToolbar release];
    [self.nameLabel release];
    [self.labelStatus release];
    
    [self.viewTop release];
    [self.buttonToolBarMute release];
    [self.buttonToolBarEnd release];
    [self.buttonToolBarToggle release];
    
    [self.buttonAccept release];
    [self.buttonHangup release];
    
    [self.glViewVideoRemote release];
    
    [self .timerQoS release];
    
    [super dealloc];
}



-(void) showBottomView: (UIView*)view_ shouldRefresh:(BOOL)refresh{
    if(!view_.superview){
        [self.view addSubview:view_];
        refresh = YES;
    }
    
    if(refresh){
        CGRect frame = CGRectMake(0.f, self.view.frame.size.height - view_.frame.size.height,
                                  self.view.frame.size.width, view_.frame.size.height);
        
        frame = CGRectMake(0, ScreenHeight - 60, ScreenWidth, 80);
        view_.frame = frame;
        
        view_.backgroundColor = [UIColor clearColor];
        
        
        if(view_ == self.viewToolbar){
            // update content
            
            self.buttonToolBarMute.selected = [videoSession isMuted];
            
        }
        
    }
    view_.hidden = NO;
}

-(void) hideBottomView:(UIView*)view_{
    view_.hidden = YES;
}

-(void) updateViewAndState{
    if(videoSession){
        switch (videoSession.state) {
            case INVITE_STATE_INPROGRESS:
            {
                self.viewTop.hidden = NO;
                self.bgImageView.hidden = NO;
                self.labelStatus.text = @"视频请求中...";
                self.viewLocalVideo.hidden = YES;
                
                
                [self hideBottomView:self.viewToolbar];
                
                self.buttonAccept.hidden = YES;
                self.buttonHangup.hidden = NO;
                
                CGRect rect = self.buttonHangup.frame;
                rect.origin.y = self.buttonHangup.frame.origin.y;
                self.buttonHangup.frame = rect;
                
                [self.buttonHangup setTitle:@"结束" forState:UIControlStateNormal];
                break;
            }
            case INVITE_STATE_INCOMING:
            {
                
                
                self.viewTop.hidden = NO;
                self.bgImageView.hidden = NO;
                self.viewLocalVideo.hidden = YES;
                self.labelStatus.text = @"视频来电...";
                
                [self hideBottomView:self.viewToolbar];
                
                
                self.buttonHangup.hidden = NO;
                [self.buttonHangup setTitle:@"挂断" forState:UIControlStateNormal];
                
                
                self.buttonAccept.hidden = NO;
                [self.buttonAccept setTitle:@"接受" forState:UIControlStateNormal];
                
                // 勿扰模式
//                BOOL isOpen = isOpenDnd;
//                BOOL res = [ZYSipTools isBetweenTime];
//                if (isOpen && res) {
//                    
//                    SYLog(@"开启勿扰模式 且 在时间范围内 不打扰");
//                    [ZYSipTools stopRing];
//                    
//                }
//                else{
//                    SYLog(@"没开启勿扰模式");
//                    [ZYSipTools playRing];
//                    
//                }
                
                break;
            }
            case INVITE_STATE_REMOTE_RINGING:
            {
                self.viewTop.hidden = NO;
                self.bgImageView.hidden = NO;
                self.viewLocalVideo.hidden = YES;
                self.labelStatus.text = @"正在视频通话...";
                
                [self btnToggleClick];
                [self btnToggleClick];
                
                [self hideBottomView:self.viewToolbar];
                
                
                self.buttonAccept.hidden = YES;
                self.buttonHangup.hidden = NO;
                [self.buttonHangup setTitle:@"结束" forState:UIControlStateNormal];
                
                
                [videoSession setSpeakerEnabled:YES];
                [[[NgnEngine sharedInstance] getSoundService] stopRingTone];
                [[[NgnEngine sharedInstance] getSoundService] stopRingBackTone];
                
                if(sendingVideo){
                    [videoSession setLocalVideoDisplay:_viewLocalVideo];
                }
                
                break;
            }
            case INVITE_STATE_INCALL:
            {
                self.viewTop.hidden = YES;
                self.bgImageView.hidden = YES;
                self.viewLocalVideo.hidden = NO;
                self.labelStatus.text = @"正在视频通话...";
                
                [self showBottomView:self.viewToolbar shouldRefresh:NO];
                
                [[NgnEngine sharedInstance].soundService setSpeakerEnabled:[videoSession isSpeakerEnabled]];
                
                [[[NgnEngine sharedInstance] getSoundService] stopRingTone];
                [[[NgnEngine sharedInstance] getSoundService] stopRingBackTone];
                break;
            }
            case INVITE_STATE_TERMINATED:
            case INVITE_STATE_TERMINATING:
            {
                self.viewTop.hidden = NO;
                self.bgImageView.hidden = NO;
                self.labelStatus.text = @"视频结束中...";
                self.viewLocalVideo.hidden = YES;
                
                
                [self hideBottomView:self.viewToolbar];
                
                [[NgnEngine sharedInstance].soundService stopRingBackTone];
                [[NgnEngine sharedInstance].soundService stopRingTone];
                break;
            }
            default:
                break;
        }
    }
}

-(void) closeView{
    [[NgnEngine sharedInstance].soundService stopRingBackTone];
    [[NgnEngine sharedInstance].soundService stopRingTone];
    [NgnCamera setPreview:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) updateVideoOrientation{
    if(videoSession){
        if(![videoSession isConnected]){
            [NgnCamera setPreview:self.glViewVideoRemote];
        }
#if 0 // @deprecated
        switch ([UIDevice currentDevice].orientation) {
            case UIInterfaceOrientationPortrait:
                [videoSession setOrientation:AVCaptureVideoOrientationPortrait];
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                [videoSession setOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
                break;
            case UIInterfaceOrientationLandscapeLeft:
                [videoSession setOrientation:AVCaptureVideoOrientationLandscapeLeft];
                break;
            case UIInterfaceOrientationLandscapeRight:
                [videoSession setOrientation:AVCaptureVideoOrientationLandscapeRight];
                break;
        }
#endif
    }
#if 0 // @deprecated
    if(glViewVideoRemote){
        [glViewVideoRemote setOrientation:[UIDevice currentDevice].orientation];
    }
#endif
}

-(void) updateRemoteDeviceInfo{
    BOOL deviceOrientPortrait = [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown;
    switch(videoSession.remoteDeviceInfo.orientation)
    {
        case NgnDeviceInfo_Orientation_Portrait:
            [self.glViewVideoRemote setContentMode:UIViewContentModeScaleAspectFill];
            if(!deviceOrientPortrait){
#if 0
#endif
            }
            break;
        case NgnDeviceInfo_Orientation_Landscape:
            [self.glViewVideoRemote setContentMode:UIViewContentModeCenter];
            if(deviceOrientPortrait){
#if 0
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(90));
                landscapeTransform = CGAffineTransformTranslate(landscapeTransform, +90.0, +90.0);
                [self.view setTransform:landscapeTransform];
#endif
            }
            break;
    }
}

-(void) sendDeviceInfo{
    if([[NgnEngine sharedInstance].configurationService getBoolWithKey:GENERAL_SEND_DEVICE_INFO]){
        if(videoSession){
            NSString* content = nil;
            switch ([[UIDevice currentDevice] orientation]) {
                case UIDeviceOrientationPortrait:
                case UIDeviceOrientationPortraitUpsideDown:
                    content = @"orientation:portrait\r\nlang:fr-FR\r\n";
                    break;
                default:
                    content = @"orientation:landscape\r\nlang:fr-FR\r\n";
                    break;
            }
            [videoSession sendInfoWithContentString:content contentType:kContentDoubangoDeviceInfo];
        }
    }
}


-(void) onInviteEvent:(NSNotification*)notification {
    
    NgnInviteEventArgs* eargs = [notification object];
    
    if(!videoSession || videoSession.id != eargs.sessionId){
        return;
    }
    
    if (!eargs.otherIsOnLine) {
        self.labelStatus.text = @"对方不在线...";
        
        isOnLine = NO;
        _dismiss = [PSTAlertController presentDismissableAlertWithTitle:@"⚠️\n" message:@"对方不在线，请稍后尝试！" controller:self];
        
    }
    
    if (eargs.otherNotAnswer) {
        self.labelStatus.text = @"对方没有接听...";
        NSLog(@"!!!!对方没有接听");
    }
    
    
    switch (eargs.otherInCallstate) {
        case OTHER_DEFAULT:{
            
            break;
        }
            
        case OTHER_ANSWER_NOT:{
            //"对方没有接听";
            break;
        }
            
        case OTHER_ANSWER_OR_REJECT:{
            //"对方接听或拒绝";
            
            break;
        }
            
        case OTHER_REJECT:{
            //"对方拒接";
            
        }
    }
    
    
    
    switch (eargs.eventType) {
        case INVITE_EVENT_INPROGRESS:
        case INVITE_EVENT_INCOMING:
        case INVITE_EVENT_RINGING:
        default:
        {
            // updates status info
            [self updateViewAndState];
            
            // video session
            [NgnCamera setPreview:self.glViewVideoRemote];
            if(sendingVideo){
                [videoSession setRemoteVideoDisplay:nil];
                [videoSession setLocalVideoDisplay:_viewLocalVideo];
                
            }
            
            break;
        }
            
        case INVITE_EVENT_CONNECTED:
            
            [self btnToggleClick];
            [self btnToggleClick];
            [videoSession setSpeakerEnabled:YES];
            
        case INVITE_EVENT_EARLY_MEDIA:
            
            
        case INVITE_EVENT_MEDIA_UPDATED:
        {
            // updates status info 1
            [self updateViewAndState];
            
            // video session
            [self updateVideoOrientation];
            
            [NgnCamera setPreview:nil];
            [videoSession setRemoteVideoDisplay:self.glViewVideoRemote];
            
            [self updateRemoteDeviceInfo];
            [self sendDeviceInfo];
            // starts QoS timer
            if (self.timerQoS == nil) {
                self.timerQoS = [NSTimer scheduledTimerWithTimeInterval:kQoSTimer
                                                                 target:self
                                                               selector:@selector(timerQoSTick:)
                                                               userInfo:nil
                                                                repeats:YES];
            }
            sendingVideo = YES;
            [videoSession setLocalVideoDisplay:_viewLocalVideo];
            break;
        }
            
        case INVITE_EVENT_REMOTE_DEVICE_INFO_CHANGED:
        {
            [self updateRemoteDeviceInfo];
            break;
        }
            
        case INVITE_EVENT_TERMINATED:
        case INVITE_EVENT_TERMWAIT:
        {
            // stops QoS timer
            if (self.timerQoS) {
                [self.timerQoS invalidate];
                self.timerQoS = nil;
            }
            
            // updates status info
            [self updateViewAndState];
            
            // video session
            if(videoSession){
                [videoSession setRemoteVideoDisplay:nil];
                [videoSession setLocalVideoDisplay:nil];
            }
            //            [self.glViewVideoRemote stopAnimation];
            [NgnCamera setPreview:self.glViewVideoRemote];
            
            // releases session
            [NgnAVSession releaseSession:&videoSession];
            
            
            if (!isOnLine) {
                [_dismiss addDidDismissBlock:^(PSTAlertAction * _Nonnull action) {
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

-(void)timerInCallTick:(NSTimer*)timer{
    // to be implemented for the call time display
}

-(void)timerQoSTick:(NSTimer*)timer{
    if (videoSession && videoSession.connected) {
        NgnQoS* ngnQoS = [videoSession videoQoS];
        if (ngnQoS) {
        }
    }
}

-(void)timerSuicideTick:(NSTimer*)timer{
    [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:NO];
}

@end
