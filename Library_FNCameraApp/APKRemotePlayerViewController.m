//
//  APKRemotePlayerViewController.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "APKRemotePlayerViewController.h"


@interface APKRemotePlayerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *currentTImeL;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *allTImeL;
@property (nonatomic,assign) BOOL isRecordVideo;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPlayEnd;
@end

@implementation APKRemotePlayerViewController

-(void)dealloc
{
    _remoteCamera = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [self.url componentsSeparatedByString:@"/"];
    self.title = arr.lastObject;
    
    if (self.type == APKTypeLocalVideo || self.type == APKTypeVideo)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"切换", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickChangeButton)];

    switch (self.type) {
        case APKTypeLocalVideo:
        case APKTypeLocalEvent:
        case APKTypeLocalParking:
        case APKTypeVideo:
        {
            [self playVideo];
            break;
        }
        case APKTypeLocalImage:
        {
            self.imageView.image = [UIImage imageWithContentsOfFile:self.url];
            [self removePlayerFuctionUI];
            break;
        }
        case APKTypeImage:
            [self.imageView setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:nil];
            [self removePlayerFuctionUI];
            break;
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    // Do any additional setup after loading the view.
}

-(void)removePlayerFuctionUI
{
    [_currentTImeL removeFromSuperview];
    [_allTImeL removeFromSuperview];
    [_timeSlider removeFromSuperview];
    [_playBtn removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.type == APKTypeVideo) {
        [self.remoteCamera stopRecord];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [_player stop];
    [self stopPlayLiveStream];

    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
//    if (_isRecordVideo == YES)
//        [self.remoteCamera startRecord];

}

- (void) stopPlayLiveStream {
    
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        [_player removeFromParentViewController];
        _player = nil;
    }
}

-(void)playVideo
{
    [self stopPlayLiveStream];
    
    self.imageView.hidden = YES;
    
    FNPlayerOption *option = [FNPlayerOption defaultVROption];
    option.liveRTSPStreaming = YES;
    _player = [FNPlayerController launchAsVideoPath:self.url options:option];
    [_player setEnableVideoController:NO];
//    [_player setProjectionMode:FN360ModeProjectionPlaneCrop];
    [_player setDisplayMode:FN360ModeDisplayNormal];
    [self.view insertSubview:_player.view atIndex:0];
//    [self.view bringSubviewToFront:_player.view];
    [self addChildViewController:_player];
    [_player.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400)];
    _player.view.center = self.view.center;
    _player.rate = 1.0f;
    
    _isPlaying = YES;
    
    int allTimeValue = CMTimeGetSeconds(self.player.duration);
    NSString *allTime = [self formatTimeWithSeconds:allTimeValue];
    self.allTImeL.text = allTime;
    self.timeSlider.maximumValue = allTimeValue;
    
    __weak typeof(self) weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        int currrntTimeValue = CMTimeGetSeconds(time);
        weakSelf.timeSlider.value = currrntTimeValue;
        NSString *currentTime = [weakSelf formatTimeWithSeconds:currrntTimeValue];
        weakSelf.currentTImeL.text = currentTime;
        
        if ([weakSelf.currentTImeL.text isEqualToString:weakSelf.allTImeL.text]) {
            [weakSelf.playBtn setBackgroundImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
            weakSelf.isPlaying = NO;
         }
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_player.view addGestureRecognizer:tap];
}

-(void)singleTap
{
    _currentTImeL.hidden = _currentTImeL.isHidden == YES ? NO : YES;
    _allTImeL.hidden = _allTImeL.isHidden == YES? NO : YES;
    _timeSlider.hidden = _timeSlider.isHidden == YES ? NO : YES;
    _playBtn.hidden = _playBtn.isHidden == YES ? NO :YES;
}

-(IBAction)progressSliderValueChangedEnd:(UISlider *)sender {
    
       double currentTime = sender.value;
       CMTimeScale scale = self.player.currentTime.timescale;
       CMTime time = CMTimeMake(scale * currentTime, scale);
    
       [_player seekToTime:time];
       self.currentTImeL.text = [self formatTimeWithSeconds:sender.value];
    _isPlaying = YES;
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];

}

- (NSString *)formatTimeWithSeconds:(double)seconds{
    
    int wholeMinutes = (int)trunc(seconds / 60);
    int wholdSeconds = (int)trunc(seconds) - wholeMinutes * 60;
    NSString *formatTime = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, wholdSeconds];
    return formatTime;
}

- (IBAction)playBtnCliked:(UIButton *)sender {
    
    _isPlaying = !_isPlaying;
    if (_isPlaying == YES) {
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        if ([self.currentTImeL.text isEqualToString:self.allTImeL.text]) {
            CMTimeScale scale = _player.currentTime.timescale;
            [_player seekToTime:CMTimeMake(0, scale)];
            return;
        }
        [_player play];
    }else{
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [_player pause];
    }
}


-(void)clickChangeButton
{
    __weak typeof(self) weakSelf = self;
    NSArray *array = @[NSLocalizedString(@"圆球模式", nil),NSLocalizedString(@"360°VR模式", nil),NSLocalizedString(@"一般模式", nil)];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < array.count; i++) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
            APKPreviewMode mode = APKDefaultMode;
            switch (i) {
                case 0:{
                    mode = APKBollMode;
                    weakSelf.player.projectionMode = FN360ModeProjectionBallFullSphere;
                    break;
                }
                case 1:
                    mode = APK360VRMode;
                    weakSelf.player.projectionMode = FN360ModeProjectionSphere;
                    break;
                default:
                    [weakSelf.player.view removeFromSuperview];
                    CMTime currentTime = [weakSelf.player currentTime];
                    [weakSelf playVideo];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        if (currentTime.value != 0) {
                            [weakSelf.player seekToTime:currentTime];
                    }
                    });
                    break;
            }
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
