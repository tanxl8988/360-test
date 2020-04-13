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
@property (nonatomic,assign) BOOL isRecordVideo;
@end

@implementation APKRemotePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [self.url componentsSeparatedByString:@"/"];
    self.title = arr.lastObject;
    
    if (self.type == APKTypeLocalVideo || self.type == APKTypeVideo)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"切换", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickChangeButton)];

    switch (self.type) {
        case APKTypeLocalVideo:
        case APKTypeVideo:
        {
            [self playVideo];
            break;
        }
        case APKTypeLocalImage:
        {
            self.imageView.image = [UIImage imageWithContentsOfFile:self.url];
            break;
        }
        default:
            [self.imageView setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:nil];
            break;
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    // Do any additional setup after loading the view.
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
    [self.player stop];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
//    if (_isRecordVideo == YES)
//        [self.remoteCamera startRecord];

}

-(void)playVideo
{
    self.imageView.hidden = YES;
    
    FNPlayerOption *option = [FNPlayerOption defaultVROption];
    option.liveRTSPStreaming = YES;
    _player = [FNPlayerController launchAsVideoPath:self.url options:option];
    [_player setEnableVideoController:YES];
    [_player setProjectionMode:FN360ModeProjectionPlaneCrop];
    [_player setDisplayMode:FN360ModeDisplayNormal];
    [self.view insertSubview:_player.view atIndex:0];
    [self addChildViewController:_player];
    [_player.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400)];
    _player.view.center = self.view.center;
    _player.rate = 1.0f;
}

-(void)clickChangeButton
{
    NSArray *array = @[NSLocalizedString(@"圆球模式", nil),NSLocalizedString(@"360°VR模式", nil),NSLocalizedString(@"默认", nil)];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < array.count; i++) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
            APKPreviewMode mode = APKDefaultMode;
            switch (i) {
                case 0:{
                    mode = APKBollMode;
                    self.player.projectionMode = FN360ModeProjectionBallFullSphere;
                    break;
                }
                case 1:
                    mode = APK360VRMode;
                    self.player.projectionMode = FN360ModeProjectionSphere;
                    break;
                default:
                    [self.player.view removeFromSuperview];
                    CMTime currentTime = [self.player currentTime];
                    [self playVideo];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    __weak typeof(self) weakSelf = self;
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.player seekToTime:currentTime];
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
