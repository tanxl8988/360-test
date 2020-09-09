//
//  APKFileViewController.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/3/18.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "APKFileViewController.h"
#import "APKFileView.h"
#import "FNISDKToolViewController.h"
#import "APKFileListViewController.h"
#import "APKAlertTool.h"

@import Library_FNCamera;

#define Kwidth [[UIScreen mainScreen] bounds].size.width
@interface APKFileViewController ()<UIScrollViewDelegate,APKFlodersViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,retain) APKFileView *fileView;
@property (nonatomic, strong) FNRemoteCamera *remoteCamera;
@end

@implementation APKFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 2, CGRectGetHeight(self.scView.frame));
    self.scView.pagingEnabled = YES;
    
    self.tabBarItem.title = NSLocalizedString(@"相册", nil);
    
    APKFileView *fileView = [[NSBundle mainBundle] loadNibNamed:@"APKFileView" owner:nil options:nil].firstObject;
    for (int i = 0; i < 2; i++) {
        
        fileView = [[NSBundle mainBundle] loadNibNamed:@"APKFileView" owner:nil options:nil].firstObject;
        fileView.frame = CGRectMake(Kwidth * i, 0, Kwidth, CGRectGetHeight(self.scView.frame));
        fileView.delegate = self;
        fileView.videoButton.tag = i == 0 ? 100 : 104;
        fileView.eventButton.tag = i == 0 ? 101 : 105;
        fileView.parkingButton.tag = i == 0 ? 102 : 106;
        fileView.imageButton.tag = i == 0 ? 103 : 107;
        [self.scView addSubview:fileView];
        
        fileView.videoL.text = NSLocalizedString(@"视频", nil);
        fileView.eventL.text = NSLocalizedString(@"事件", nil);
        fileView.parkingL.text = NSLocalizedString(@"停车监控", nil);
        fileView.imageL.text = NSLocalizedString(@"照片", nil);
    }
    
    [self.segment setTitle:NSLocalizedString(@"摄像机文件", nil) forSegmentAtIndex:0];
    [self.segment setTitle:NSLocalizedString(@"本地文件", nil) forSegmentAtIndex:1];
    self.segment.selectedSegmentIndex = 0;

    [self.segment addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view.
}


-(void)changeSeg:(UISegmentedControl *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
       self.scView.contentOffset = sender.selectedSegmentIndex == 0 ? CGPointMake(0, 0) : CGPointMake(Kwidth, 0);
    } completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.segment.selectedSegmentIndex = scrollView.contentOffset.x == 0 ? 0 : 1;
}

-(void)didSelectedFileButton:(UIButton *)button
{
    switch (button.tag) {
        case 100:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"video"];
            break;
        case 101:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"event"];
            break;
        case 102:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"parking"];
            break;
        case 103:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"image"];
            break;
        case 104:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"localVideo"];
            break;
        case 105:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"localEvent"];
            break;
        case 106:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"localParking"];
            break;
        default:
            [self performSegueWithIdentifier:@"fileSegue" sender:@"localImage"];
            break;
    }
}

- (IBAction)clickHeightModeButton:(UIButton *)sender {
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    FNISDKToolViewController *previewVC = self.tabBarController.viewControllers.firstObject;
    
    if (!previewVC.isConnected && ([sender isEqualToString:@"video"] || [sender isEqualToString:@"image"])) {
        [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"Wi-Fi未连接", nil)];
        return;
    }
    
    UINavigationController *navi = segue.destinationViewController;
    APKFileListViewController *VC = navi.viewControllers.firstObject;
    VC.remoteCamera = previewVC.remoteCamera;
    VC.player = previewVC.player;
    VC.previewVC = previewVC;
    VC.rootPath = previewVC.rootPath;
    APKSourceType type;
    if ([sender isEqualToString:@"video"])
        type = APKTypeVideo;
    else if ([sender isEqualToString:@"image"])
        type = APKTypeImage;
    else if ([sender isEqualToString:@"event"])
        type = APKTypeEvent;
    else if ([sender isEqualToString:@"parking"])
        type = APKTypeParking;
    else if ([sender isEqualToString:@"localVideo"])
        type = APKTypeLocalVideo;
    else if ([sender isEqualToString:@"localEvent"])
        type = APKTypeLocalEvent;
    else if ([sender isEqualToString:@"localParking"])
        type = APKTypeLocalParking;
    else
        type = APKTypeLocalImage;
        
    VC.type = type;
    VC.IP = previewVC.IP;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
