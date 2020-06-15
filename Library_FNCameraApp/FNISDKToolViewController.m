//
//  FNISDKToolViewController.m
//  Library_FNCameraApp
//
//  Created by DevinLai on 2016/10/13.
//  Copyright © 2016年 Choco Yang. All rights reserved.
//

#import "FNISDKToolViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "APKAlertTool.h"
#import "APKDVRListen.h"


#define TOAST_DURATION 1.0

@interface FNISDKToolViewController () <FNListenerDelegate>
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIView *actionButtonView;
@property (assign) BOOL isOpenVRMode;
@property (nonatomic,retain) NSArray *directionModeArray;
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (nonatomic,retain) MBProgressHUD *HUD2;
@property (assign) BOOL isRecordMode;
@property (weak, nonatomic) IBOutlet UIButton *changeRecordModeButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic,assign) NSInteger connetedNum;

@end

@implementation FNISDKToolViewController {
    NSArray *_cameraSettings;
    NSString *_rootPath;
    
    NSString *thumbPath, *videoDownloadPath, *photoDownloadPath;
}

+ (instancetype)sharedInstance{
    
    static FNISDKToolViewController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[FNISDKToolViewController alloc] init];
    });
    
    return instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    thumbPath = [documentsDirectory stringByAppendingString:@"/thumb.png"];
    videoDownloadPath = [documentsDirectory stringByAppendingString:@"/video.mp4"];
    photoDownloadPath = [documentsDirectory stringByAppendingString:@"/photo.png"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
//    self.actionButtonView.hidden = YES;
    
    for (UIButton *btn in self.actionButtonView.subviews)
        btn.enabled = NO;

    [self.HUD showAnimated:YES];
    
    self.tabBarController.viewControllers[0].tabBarItem.title = NSLocalizedString(@"摄像机", nil);
    self.tabBarController.viewControllers[1].tabBarItem.title = NSLocalizedString(@"相册", nil);
    self.tabBarController.viewControllers[2].tabBarItem.title = NSLocalizedString(@"设置", nil);
    
    self.connetedNum = 0;
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateButtonStatus];
    
    if (self.isRecord) {
        [self.remoteCamera startRecord];
    }
    
    if (self.isConnected) {
        
        [self.remoteCamera stopRecord];
        
        switch (self.previewMode) {
            case APKDefaultMode:
                [self getLivePath];
                break;
            case APK180RoundMode:
                [self setSetting:@"video_fisheye_mode" newValue:@"single_fisheye"];
                break;
            case APKUltraWideMode:
                [self setSetting:@"video_fisheye_mode" newValue:@"normal"];
                break;
            case APKWholeSceneMode:
                [self setSetting:@"video_fisheye_mode" newValue:@"360_all"];
                break;
            case APKBollMode:
                [self getLivePath];
                break;
            case APK360VRMode:
                [self getLivePath];
                break;
            case APK2in1Mode:
                [self setSetting:@"video_fisheye_mode" newValue:@"2in1"];
                break;
            case APK3in1Mode:
                [self setSetting:@"video_fisheye_mode" newValue:@"3in1"];
                break;
            default:
                [self setSetting:@"video_fisheye_mode" newValue:@"4in1"];
                break;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [self.player stop];
    
}

- (IBAction)clickHeightModeButton:(UIButton *)sender {
    
    if (!_isConnected) {
        [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"Wi-Fi未连接", nil)];
        return;
    }
    
    NSArray *array = @[NSLocalizedString(@"圆球模式", nil),NSLocalizedString(@"360°VR模式", nil),NSLocalizedString(@"二分割", nil)];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < array.count; i++) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            //            if (i != 3 && i != 4) [self.HUD showAnimated:YES];
            
            if (i == 0 || i == 1) {
                for (UIButton *btn in self.actionButtonView.subviews)
                    btn.enabled = YES;
            }else
            {
                for (UIButton *btn in self.actionButtonView.subviews)
                    btn.enabled = NO;
            }
            
            [self.remoteCamera stopRecord];
            APKPreviewMode mode = APKDefaultMode;
            switch (i) {
                case 0:{
                    mode = APKBollMode;
                    //                    self.player.projectionMode = FN360ModeProjectionBallFullSphere;
                    //                    [self getLivePath];
                    [self setSetting:@"video_fisheye_mode" newValue:@"full_dewarp"];
                    self.directionModeArray = @[@9,@10,@11];}
                    break;
                case 1:
                    mode = APK360VRMode;
                    //                    self.player.projectionMode = FN360ModeProjectionSphere;
                    [self setSetting:@"video_fisheye_mode" newValue:@"full_dewarp"];
                    self.directionModeArray = @[@1,@2,@3];
                    break;
                case 2:
                    mode = APK2in1Mode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"2in1"];
                    break;
            }
            self.previewMode = mode;
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    return;
    NSArray *arr = @[NSLocalizedString(@"180°圆模式", nil),NSLocalizedString(@"超广角模式", nil),NSLocalizedString(@"全景360", nil),NSLocalizedString(@"圆球模式", nil),NSLocalizedString(@"360°VR模式", nil),NSLocalizedString(@"二分割", nil),NSLocalizedString(@"三分割", nil),NSLocalizedString(@"四分割", nil)];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < arr.count; i++) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:arr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
//            if (i != 3 && i != 4) [self.HUD showAnimated:YES];

            if (i == 3 || i == 4) {
                for (UIButton *btn in self.actionButtonView.subviews)
                    btn.enabled = YES;
            }else
            {
                for (UIButton *btn in self.actionButtonView.subviews)
                    btn.enabled = NO;
            }
 
            APKPreviewMode mode;
            switch (i) {
                case 0:
                    mode = APK180RoundMode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"single_fisheye"];
                    break;
                case 1:
                    mode = APKWholeSceneMode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"normal"];
                    break;
                case 2:
                    mode = APK360VRMode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"360_all"];
                    break;
                case 3:
                    mode = APKBollMode;
                    self.player.projectionMode = FN360ModeProjectionDomeBallUpper;
                    self.directionModeArray = @[@18,@22,@20];
                    break;
                case 4:
                    mode = APK360VRMode;
                    self.player.projectionMode = FN360ModeProjectionSphere;
                    self.directionModeArray = @[@1,@2,@3];
                    break;
                case 5:
                    mode = APK2in1Mode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"2in1"];
                    break;
                case 6:
                    mode = APK3in1Mode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"3in1"];
                    break;
                default:
                    mode = APK4in1Mode;
                    [self setSetting:@"video_fisheye_mode" newValue:@"4in1"];
                    break;
            }
            self.previewMode = mode;
        }];
        
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleApplicationState:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification])
    {
       [self performSelectorInBackground:@selector(connect) withObject:nil];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            if (self.HUD.isHidden == NO && self.isConnected == NO) {
//                [self.HUD hideAnimated:YES];
//                [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"连接失败", nil)];
//            }
//        });
    }
     else
         [self performSelectorInBackground:@selector(disconnect) withObject:nil];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)buttonAction:(id)sender {
    
    if (sender == _playButton) {
        [self performSelectorInBackground:@selector(getLivePath) withObject:nil];
    }
}

- (IBAction)VRButtonClick:(UIButton *)sender {
    
    self.player.displayMode = self.isOpenVRMode ? FN360ModeDisplayNormal : FN360ModeDisplayGlass;
    self.isOpenVRMode = !self.isOpenVRMode;
}

- (IBAction)directionButtonClick:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[NSLocalizedString(@"往上", nil),NSLocalizedString(@"往下", nil),NSLocalizedString(@"往前", nil)];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < arr.count; i++) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:arr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            weakSelf.player.projectionMode = [weakSelf.directionModeArray[i] integerValue];
        }];
        
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)touchButtonClick:(UIButton *)sender {
    
    __weak typeof (self) weakself = self;
    NSArray *arr = @[NSLocalizedString(@"触控", nil),NSLocalizedString(@"动作", nil),NSLocalizedString(@"触控+动作", nil)];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < arr.count; i++) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:arr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            switch (i) {
                case 0:
                    weakself.player.interactiveMode = FN360ModeInteractiveTouch;
                    break;
                case 1:
                    weakself.player.interactiveMode = FN360ModeInteractiveMotion;
                    break;
                default:
                    weakself.player.interactiveMode = FN360ModeInteractiveMotionWithTouch;
                    break;
            }
        }];
        
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)changeRecordButtonClick:(UIButton *)sender {
    
    if (!self.isConnected) {
        [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"Wi-Fi未连接", nil)];
        return;
    }
    
    NSDictionary *dic = [self.remoteCamera stopRecord];
    if ([dic[KEY_ERROR_CODE] integerValue] == 0) {
            
        NSString *mode = self.isRecordMode ? @"photo" : @"video";
        [self setSetting:@"mode" newValue:mode];
        [self.HUD showAnimated:YES];
    }
}


- (IBAction)recordButtonClick:(UIButton *)sender {
    
    __weak typeof (self) weakself = self;

    NSDictionary *response = @{};
    if (self.isRecordMode){
        
        NSDictionary *recordResponse = [self.remoteCamera getSetting:@"status"];
        if ([recordResponse[@"param"] isEqualToString:@"idle"]){
            response = [self.remoteCamera startRecord];
            self.isRecord = YES;
            [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"开始录像", nil)];
        }
        else{
            response = [self.remoteCamera stopRecord];
            self.isRecord = NO;
            [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"关闭录像", nil)];
        }
    }else
    {
        response = [self.remoteCamera takePhoto];
        self.recordButton.enabled = NO;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            weakself.recordButton.enabled = YES;
        });
    }
    [self checkErrorStatus:response];
}




- (void) getLivePath {
    NSDictionary *response = [_remoteCamera getLivePath];
    if (response) {
        NSString *path = response[KEY_PARAMETER];
        if (path) {
            [self performSelectorOnMainThread:@selector(playVideoPath:) withObject:path waitUntilDone:NO];
            return;
        }
    }
    [self showToastMessage:@"Cannot Get Live Path"];
}


#pragma mark update Views
- (void) updateButtonStatus {
    [_playButton setHidden:(_player != nil)];    //hide when player is init
}

#pragma mark property
- (FNRemoteCamera *)remoteCamera {
    if (!_remoteCamera) {
        _remoteCamera = [[FNRemoteCamera alloc] init];
        [_remoteCamera setDelegate:self];
    }
    return _remoteCamera;
}


- (void) connect {
    __weak typeof (self)weakSelf = self;
    NSArray *scanList = [[FNRemoteDiscovery shareInstance] scanAllDevice:1000];
    if (scanList.count > 0) {
        for (NSDictionary *device in scanList) {
            NSString *gatewayIp = [device objectForKey:DISCOVERY_KEY_IP];
            if (gatewayIp) {
                NSDictionary *connect = [self.remoteCamera connect:gatewayIp isLiveMode:YES];
                
                /*  */
                if ([connect[KEY_ERROR_CODE] integerValue] == 0) {
//                    [self showToastMessage:[self stringFromDict:connect]];
                    _rootPath = [connect objectForKey:@"root_path"];
                    
                    _cameraSettings = [connect objectForKey:KEY_SETTINGINFOS];
                    [self performSelectorInBackground:@selector(getLivePath) withObject:nil];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSDictionary *response = [weakSelf.remoteCamera getSetting:@"mode"];
                        weakSelf.isRecordMode = [response[@"param"] isEqualToString:@"video"] ? YES : NO;
                        [weakSelf changeRecordButtonState:NO];
                        
                        weakSelf.isConnected = YES;
                        weakSelf.cameraVersion = connect[@"fw_ver"];
                        weakSelf.rootPath = connect[@"root_path"];
                        weakSelf.IP = gatewayIp;
                        weakSelf.SSID = [self.remoteCamera getSetting:@"wifi_ssid"][@"param"];
                        weakSelf.password = [self.remoteCamera getSetting:@"wifi_password"][@"param"];

                        NSDictionary *dic = [weakSelf.remoteCamera getSetting:@"card_status"];
                        weakSelf.isRecord = [dic[@"param"] isEqualToString:@"inserted"] ? YES : NO;
                        weakSelf.connetedNum = 0;
                        
                        [weakSelf.remoteCamera setSetting:@"camera_clock" param:[weakSelf currentTime]];
                    });
                    
                    break;
                }else{
//                    if (_connetedNum <= 3) {
//                        [self connect];
//                        _connetedNum++;
//                    }
                    [self notConnectedWifiHandle];
                }
            }
        }
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.HUD hideAnimated:YES];
            weakSelf.isConnected = NO;
            [weakSelf clearInfo];
            [weakSelf stopPlayLiveStream];
            [APKAlertTool showAlertInViewController:weakSelf message:NSLocalizedString(@"请确认Wi-Fi是否已连接", nil)];
        });
    }
}

-(void)notConnectedWifiHandle
{
    __weak typeof (self) weakself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.HUD hideAnimated:YES];
        weakself.isConnected = NO;
        [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"连接失败", nil)];
        [weakself clearInfo];
        [weakself.player stop];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFIISCLOSE" object:nil];
    });
}

- (NSString *)currentTime{
    
    //获取手机当前时间
    NSDate *date = [[NSDate alloc] init];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    return currentTime;
}


-(void)changeRecordButtonState:(BOOL)isClickChangeRecordButton
{
    __weak typeof (self) weakself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString *changeRecordModeButtonImage = weakself.isRecordMode ? @"切换录像模式" : @"切换录像模式2";
        NSString *recordButtonImage = weakself.isRecordMode ? @"椭圆 1 录像" : @"椭圆 1 拍照";
        [weakself.changeRecordModeButton setImage:[UIImage imageNamed:changeRecordModeButtonImage] forState:UIControlStateNormal];
        [weakself.recordButton setImage:[UIImage imageNamed:recordButtonImage] forState:UIControlStateNormal];
        [weakself performSelectorInBackground:@selector(getLivePath) withObject:nil];
    });
}

- (void) disconnect {
    
    exit(0);
    return;
    
    [_remoteCamera disconnect];
    [_remoteCamera setDelegate:nil];
    _remoteCamera = nil;
//    [self performSelectorOnMainThread:@selector(onDisconnected) withObject:nil waitUntilDone:NO];
}


- (void) setSetting:(NSString*) key newValue:(NSString*) value {
    
    __weak typeof (self) weakself = self;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *response = [weakself.remoteCamera setSetting:key param:value];
        NSLog(@"setSetting: %@", response);
        if ([weakself checkErrorStatus:response]) {
            
            if ([key isEqualToString:@"video_fisheye_mode"]) {
                [weakself performSelectorInBackground:@selector(getLivePath) withObject:nil];
            }else if ([key isEqualToString:@"mode"]){
                
                weakself.isRecordMode = !weakself.isRecordMode;
                [weakself changeRecordButtonState:YES];
                if (weakself.isRecord) {
                    [weakself.remoteCamera startRecord];
                }
            }
            
            if (weakself.isRecord == YES) {
                [weakself.remoteCamera startRecord];
            }
            
//            [_actionTableView updateModelKey:key withNewValue:value];
//            [self showToastMessage:[self stringFromDict:response]];
        }
    });
}


- (void) sessionHolder {
    [_remoteCamera sessionHolder];
}


#pragma mark FNListenerDelegate
- (void)onDisconnected {
    
    self.isConnected = NO;
    [self clearInfo];
    [self stopPlayLiveStream];
    [self showToastMessage:@"onDisconnected"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFIISCLOSE" object:nil];
    [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"Wi-Fi未连接", nil) handler:^(UIAlertAction *action) {
        nil;
    }];
    
}

- (void)onCameraUnstableAndReconnectSuccess {
    [self showToastMessage:@"onCameraUnstableAndReconnectSuccess"];
}

- (void)onNotification:(FNNotification)notificationId otherInfo:(NSDictionary *)otherInfo {
    NSLog(@"onNotification notificationId: %d, otherInfo: %@", notificationId, otherInfo);
    [self showToastMessage:[NSString stringWithFormat:@"notification : %d\ninfo =  %@", notificationId, [self stringFromDict:otherInfo]]];
    switch (notificationId) {
        case NOTIFICATION_HEARTBEAT:
        case NOTIFICATION_QUERY_SESSION_HOLDER:
            [self performSelectorInBackground:@selector(sessionHolder) withObject:nil];
            break;
            
        case NOTIFICATION_VF_STOP:
            [self stopPlayLiveStream];
            [self updateButtonStatus];
            break;
            
        case NOTIFICATION_VF_STOP_WITH_ACTION_COMPLETE:
            [self stopPlayLiveStream];
            [self updateButtonStatus];
            [_remoteCamera actionComplete:notificationId];
            break;
            
        default:
            break;
    }
}



#pragma mark
- (void) playVideoPath:(NSString*) path {
    
    [self stopPlayLiveStream];
    FNPlayerOption *option = [FNPlayerOption defaultVROption];
    option.liveRTSPStreaming = YES;
    _player = [FNPlayerController launchAsVideoPath:path options:option];
    [_player setEnableVideoController:YES];
//    [_player setProjectionMode:FN360ModeProjectionPlaneCrop];
    [_player setDisplayMode:FN360ModeDisplayNormal];
    [_playerView insertSubview:_player.view atIndex:0];
    [self addChildViewController:_player];
    [_player.view setFrame:_playerView.bounds];
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [self updateButtonStatus];
    [self.HUD hideAnimated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOnError) name:FNPlayerFailedToPlayToEndTimeErrorKey object:nil];

    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (weakSelf.player.rate != 1) {
            NSDictionary *response = [weakSelf.remoteCamera getLivePath];
                NSString *path = response[KEY_PARAMETER];
            [weakSelf playVideoPath:path];
        }
    });
    
    
    self.playPath = path;
    
    switch (self.previewMode) {
        case APKBollMode:
            self.player.projectionMode = FN360ModeProjectionBallFullSphere;
            self.player.displayMode = !self.isOpenVRMode ? FN360ModeDisplayNormal : FN360ModeDisplayGlass;
            break;
        case APK360VRMode:
            self.player.projectionMode = FN360ModeProjectionSphere;
            self.player.displayMode = !self.isOpenVRMode ? FN360ModeDisplayNormal : FN360ModeDisplayGlass;
            break;
        default:
            break;
    }
    
    if (self.isRecord) {
        [self.remoteCamera startRecord];
    }
}

-(void)playOnError
{
    [self stopPlayLiveStream];
    NSDictionary *response = [self.remoteCamera getLivePath];
    NSString *path = response[KEY_PARAMETER];
    [self playVideoPath:path];
}

- (void) stopPlayLiveStream {
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        [_player removeFromParentViewController];
        [_player removeObserver:self forKeyPath:@"rate"];
        _player = nil;
    }
    [self updateButtonStatus];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    if ([keyPath isEqualToString:@"rate"]) {
        [self updateButtonStatus];
        if ([change[NSKeyValueChangeNewKey] floatValue] == 0.0) {
            [self stopPlayLiveStream];
        }
    }
}

- (void) clearInfo {
    _cameraSettings = nil;
    _rootPath = nil;
}




- (NSString *) stringFromDict:(NSDictionary*) source {
    return [NSString stringWithFormat:@"%@", source];
}

- (BOOL) checkErrorStatus:(NSDictionary*) response {
    
    __weak typeof (self) weakself = self;

    if ([response[KEY_ERROR_CODE] integerValue] != 0) {
        //        [self showToastMessage:NSLocalizedString(@"设置失败", nil)];
        NSString *alertStr = [response[KEY_ERROR_CODE] integerValue] == -30 ? NSLocalizedString(@"", nil) : NSLocalizedString(@"操作失败", nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            [APKAlertTool showAlertInView:weakself.view andText:alertStr];
            if([response[@"type"] isEqualToString:@"video_fisheye_mode"]) {
                [weakself getLivePath];
                weakself.previewMode = APKDefaultMode;
            }
        });
        return NO;
    }
    return YES;
}

- (void) showToastMessage:(NSString*) message {
    if (!message) {
        return;
    }
//    [self performSelectorOnMainThread:@selector(_showToastMessage:) withObject:message waitUntilDone:NO];
}

- (void) _showToastMessage:(NSString*) message {
    [self.view makeToast:message duration:2.0 position:CSToastPositionCenter image:nil];
}

-(MBProgressHUD *)HUD
{
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
    }

    return _HUD;
}


@end
