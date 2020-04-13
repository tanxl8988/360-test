//
//  ViewController.m
//  Library_FNCameraApp
//
//  Created by 楊凱丞 on 2015/12/7.
//  Copyright © 2015年 Choco Yang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Toast.h"
#import "downLoadView.h"
@import Library_FNCamera;
@import FNPlayerKit;

#if DEBUG
#define FNLog(s, ...) NSLog(@"%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define FNLog(s, ...)
#endif

#define Duration 0.6 //Show Toast time

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, FNListenerDelegate, downLoadViewDelegate, UIAlertViewDelegate> {
    FNRemoteCamera *_fnRemoteCamera;
    NSMutableArray *_list;
//    id playerStream;
    FNPlayerController *_playerController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *ControlBarView;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;

@property (nonatomic)downLoadView *downAlertView;
@property (nonatomic)id<downLoadViewDelegate> delegate;

@property (strong, nonatomic)NSTimer *BlockTimer;

@property (strong, nonatomic) UIActivityIndicatorView *ActivityIndicatorView;
@property (strong, nonatomic) UIImageView *playerImageView;
@property (strong, nonatomic) UIAlertView *listAlertView;
@property (strong, nonatomic) UIAlertView *optionAlertView;
@property (strong, nonatomic) UIView *BlockView;

@property (strong, nonatomic) NSArray *listArray;

@property (strong, nonatomic) NSString *root_path;
@property (strong, nonatomic) NSString *thumbimageURLPath;
@property (strong, nonatomic) NSString *thumbresouceUrlPath;
@property (strong, nonatomic) NSString *imageURLPath;
@property (strong, nonatomic) NSString *resouceUrlPath;

@property (nonatomic)         BOOL isDownLoading;
@property (nonatomic)         int  list_Tag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createIndcator];
    
    _list = [[NSMutableArray alloc] init];
    [self updateList:nil];
    
    [self initialFNRemoteCameraObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [self.BlockTimer invalidate];
    self.BlockTimer = nil;
}

- (IBAction)refreshAction:(id)sender {
    if (_playerController) {
        [self playerPlay];
    }
}

- (void)updateList:(NSDictionary *)settings {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_list removeAllObjects];
        [_list addObject:@"connect"];
        [_list addObject:@"disconnect"];
        [_list addObject:@"startRecord"];
        [_list addObject:@"getRecordTime"];
        [_list addObject:@"stopRecord"];
        [_list addObject:@"takePhoto"];
        [_list addObject:@"stopTakePhoto"];
        [_list addObject:@"getFileList"];
        if (settings) {
            for (NSString *key in [settings allKeys]) {
                [_list addObject:[NSString stringWithFormat:@"setting (%@)", key]];
            }
        }
        [_tableView reloadData];
    });
}

- (NSString *)dicToJSONString:(id)dic {
    return [NSString stringWithFormat:@"%@", dic];
}

- (void)getMessages:(NSString *)ShowMessage duration:(NSTimeInterval)duration position:(NSString *)position showLog:(BOOL)showLog{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (showLog)
            FNLog(@"response: %@", ShowMessage);
        [self.view makeToast:ShowMessage duration:duration position:position];
    });
}

- (void)disconnected{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateList:nil];
        if (self.listAlertView) {
            [self.listAlertView dismissWithClickedButtonIndex:0 animated:YES];
            self.playerImageView = nil;
        }
        if (self.downAlertView) {
            [self.downAlertView removeFromSuperview];
            self.downAlertView = nil;
        }
        [self playerRemove:YES];
        _root_path = nil;
        self.listArray = nil;
    });
}
- (void)getFileListPath:(NSString *)FolderPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIndcater];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *getFileList = [_fnRemoteCamera getFileList:FolderPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideIndcater];
                [self getMessages:[self dicToJSONString:getFileList] duration:Duration position:@"center" showLog:YES];
                self.listArray = [getFileList objectForKey:KEY_PARAMETER];
                if (self.listArray) {
                    self.listAlertView = [[UIAlertView alloc] initWithTitle:FolderPath message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    for (NSDictionary *file in self.listArray) {
                        id name = [file objectForKey:VALUE_FILE_NAME];
                        if (name)
                            [self.listAlertView addButtonWithTitle:name];
                    }
                    [self.listAlertView setAlertViewStyle:UIAlertViewStyleDefault];
                    [self.listAlertView show];
                }
            });
        });
    });
}
#pragma mark - Notification
- (void)onNotification:(FNNotification)notificationId otherInfo:(NSDictionary *)otherInfo {
    FNLog(@"onNotification: id: %d, %@", notificationId, [self dicToJSONString:otherInfo]);
    [self getMessages:[NSString stringWithFormat:@"id: %d, %@", notificationId, [self dicToJSONString:otherInfo]] duration:Duration position:@"center" showLog:NO];
    switch (notificationId) {
        case NOTIFICATION_HEARTBEAT:
        case NOTIFICATION_QUERY_SESSION_HOLDER: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [_fnRemoteCamera sessionHolder];
            });
            break;
        }
        case NOTIFICATION_VF_STOP: {
            [self playerInit];
            break;
        }
        default:
            break;
    }
}
- (void)onFileDownload:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath sizeNow:(long long)sizeNow sizeAll:(long long)sizeAll fileInfo:(NSDictionary *)fileInfo status:(FNDataTransferStatus)status{
    NSString *statustext;
    switch (status) {
        case DOWNLOADED:
            self.isDownLoading = NO;
            statustext = @"DOWNLOAD_DOWNLOADED";
            [self.downAlertView.downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
            [self getMessages:@"download success" duration:0.2 position:@"center" showLog:NO];
            self.downAlertView.labelDownLoading.text = [NSString stringWithFormat:@"%lld/%lld", sizeNow,sizeAll];
            self.downAlertView.progressBar.progress = (float) sizeNow / sizeAll;
            FNLog(@"File Download Complete: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld", userInfo, srcPath, sizeNow, sizeAll);
            break;
            
        case DOWNLOADING:
            self.isDownLoading = YES;
            statustext = @"DOWNLOAD_DOWNLOADING";
            [self.downAlertView.downloadBtn setTitle:@"Stop" forState:UIControlStateNormal];
            self.downAlertView.labelDownLoading.text = [NSString stringWithFormat:@"%lld/%lld", sizeNow,sizeAll];
            self.downAlertView.progressBar.progress = (float) sizeNow / sizeAll;
            FNLog(@"File Downloading..: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld", userInfo, srcPath, sizeNow, sizeAll);
            break;
            
        case DOWNLOAD_STOP:
            self.isDownLoading = NO;
            statustext = @"DOWNLOAD_STOP";
            [self.downAlertView.downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
            self.downAlertView.labelDownLoading.text = [NSString stringWithFormat:@"%lld/%lld", sizeNow,sizeAll];
            self.downAlertView.progressBar.progress = (float) sizeNow / sizeAll;
            FNLog(@"File Download blocked: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld", userInfo, srcPath, sizeNow, sizeAll);
            break;
            
        default:
            self.isDownLoading = NO;
            statustext = @"DOWNLOAD_ERROR";
            [self.downAlertView.downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
            self.downAlertView.labelDownLoading.text = [NSString stringWithFormat:@"%lld/%lld", sizeNow,sizeAll];
            self.downAlertView.progressBar.progress = (float) sizeNow / sizeAll;
            FNLog(@"File Download error: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld, status: %d", userInfo, srcPath, sizeNow, sizeAll, status);
            break;
            
    }
    self.downAlertView.labelFileDownLoadingStatus.text = statustext;
}

-(void)onThumbDownload:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath sizeNow:(long long)sizeNow sizeAll:(long long)sizeAll fileInfo:(NSDictionary *)fileInfo isIdr:(BOOL)isIdr status:(FNDataTransferStatus)status{
    switch (status) {
        case DOWNLOADED: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (isIdr) {
                    [FNImageDecoder imageDecoderFromIDRSource:self.thumbimageURLPath saveTo:self.thumbimageURLPath deleteSource:NO];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.downAlertView.imageThumbmail.image = [UIImage imageWithContentsOfFile:self.thumbimageURLPath];
                });
            });
            FNLog(@"Thumb Download Complete: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld", userInfo, srcPath, sizeNow, sizeAll);
        }
            break;
            
        case DOWNLOADING:
            FNLog(@"Thumb Downloading..: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld", userInfo, srcPath, sizeNow, sizeAll);
            break;
            
        case DOWNLOAD_STOP:
            FNLog(@"Thumb Download blocked: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld", userInfo, srcPath, sizeNow, sizeAll);
            break;
            
        default:
            FNLog(@"Thumb Download error: userInfo: %@, srcPath: %@, sizeNow: %lld, sizeAll: %lld, status: %d", userInfo, srcPath, sizeNow, sizeAll, status);
            break;
    }
}

- (void)onFileUpload:(id)userInfo srcPath:(NSString *)srcPath destPath:(NSString *)destPath sizeNow:(long long)sizeNow sizeAll:(long long)sizeAll status:(FNDataTransferStatus)status {
    FNLog(@"onFileUpload: userInfo: %@, destPath: %@, sizeNow: %lld, sizeAll: %lld, status: %d", userInfo, destPath, sizeNow, sizeAll, status);
}
- (void)onDisconnected{
    [self getMessages:@"Camera Disconnected" duration:Duration position:@"bottom" showLog:NO];
    [self disconnected];
}
#pragma mark - UIActivityIndcator
- (void)createIndcator{
    self.BlockView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.BlockView.backgroundColor = [UIColor blackColor];
    self.BlockView.alpha = 0.5;
    [self.view addSubview:self.BlockView];
    self.ActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.ActivityIndicatorView setCenter:self.view.center];
    [self.BlockView addSubview:self.ActivityIndicatorView];
    [self.ActivityIndicatorView startAnimating];
    self.BlockView.hidden = YES;
    
}
- (void)showIndcater{
    self.BlockTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(hideBlockView) userInfo:nil repeats:NO];
    [self.BlockView setHidden:NO];
}

- (void)hideIndcater{
    [self.BlockTimer invalidate];
    self.BlockTimer = nil;
    [self.BlockView setHidden:YES];
}

- (void)hideBlockView{
    [self.BlockView setHidden:YES];
}
#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = [_list objectAtIndex:[indexPath row]];
    }
    return cell;
}

- (void) initialFNRemoteCameraObj {
    if (!_fnRemoteCamera) {
        _fnRemoteCamera = [[FNRemoteCamera alloc] init];
        _fnRemoteCamera.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tag = [_list objectAtIndex:[indexPath row]];
    FNLog(@"%@", tag);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([tag isEqualToString:@"connect"]) {
            NSString *gatewayIp = [[FNRemoteCamera getWifiGatewayInfo] objectForKey:@"IP"];
            if (gatewayIp) {
                NSDictionary *connect = [_fnRemoteCamera connect:gatewayIp isLiveMode:YES];
                [self getMessages:[self dicToJSONString:connect] duration:Duration position:@"center" showLog:YES];
                
                if ([[connect objectForKey:KEY_ERROR_CODE] intValue] == 0) {
                    [self getMessages:@"Connect Success" duration:Duration position:@"bottom" showLog:NO];
                    _root_path = [connect objectForKey:@"root_path"];
                    [self playerInit];
                    NSMutableDictionary *getSettingsList = [[_fnRemoteCamera getSettingsList] mutableCopy];
                    FNLog(@"response: %@", [self dicToJSONString:getSettingsList]);
                    [getSettingsList removeObjectForKey:KEY_ERROR_CODE];
                    [self updateList:getSettingsList];
                } else {
                    [self getMessages:@"Connect Failed" duration:Duration position:@"bottom" showLog:NO];
                    [self disconnected];
                }
            } else {
                [self getMessages:@"Can't get wifi ip" duration:Duration position:@"bottom" showLog:NO];
                [self disconnected];
            }
        } else if ([tag isEqualToString:@"disconnect"]) {
            NSDictionary *disconnect = [_fnRemoteCamera disconnect];
            [self getMessages:[self dicToJSONString:disconnect] duration:Duration position:@"center" showLog:YES];
            if ([[disconnect objectForKey:KEY_ERROR_CODE] intValue] == 0){
                [self getMessages:@"Disconnect Success" duration:Duration position:@"bottom" showLog:NO];
            }
            [self disconnected];
        } else if ([tag isEqualToString:@"startRecord"]) {
            NSDictionary *startRecord = [_fnRemoteCamera startRecord];
            [self getMessages:[self dicToJSONString:startRecord] duration:Duration position:@"center" showLog:YES];
        } else if ([tag isEqualToString:@"getRecordTime"]) {
            NSDictionary *getRecordTime = [_fnRemoteCamera getRecordTime];
            [self getMessages:[self dicToJSONString:getRecordTime] duration:Duration position:@"center" showLog:YES];
        } else if ([tag isEqualToString:@"stopRecord"]) {
            NSDictionary *stopRecord = [_fnRemoteCamera stopRecord];
            [self getMessages:[self dicToJSONString:stopRecord] duration:Duration position:@"center" showLog:YES];
        } else if ([tag isEqualToString:@"takePhoto"]) {
            NSDictionary *takePhoto = [_fnRemoteCamera takePhoto];
            [self getMessages:[self dicToJSONString:takePhoto] duration:Duration position:@"center" showLog:YES];
        } else if ([tag isEqualToString:@"stopTakePhoto"]) {
            NSDictionary *stopTakePhoto = [_fnRemoteCamera stopTakePhoto];
            [self getMessages:[self dicToJSONString:stopTakePhoto] duration:Duration position:@"center" showLog:YES];
        } else if ([tag isEqualToString:@"getFileList"]) {
            [self getFileListPath:_root_path];
        } else if ([tag rangeOfString:@"setting ("].location != NSNotFound) {
            long start = [tag rangeOfString:@"("].location;
            long end = [tag rangeOfString:@")"].location;
            NSString *type = [tag substringWithRange:NSMakeRange(start + 1, end - start - 1)];
            NSDictionary *getSetting = [_fnRemoteCamera getSetting:type];
            FNLog(@"response: %@", [self dicToJSONString:getSetting]);
            if ([[getSetting objectForKey:KEY_ERROR_CODE] intValue] == 0) {
                NSDictionary *getSettingOptions = [_fnRemoteCamera getSettingOptions:type];
                FNLog(@"response: %@", [self dicToJSONString:getSettingOptions]);
                if ([[getSettingOptions objectForKey:KEY_ERROR_CODE] intValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *options = [[getSettingOptions objectForKey:KEY_PARAMETER] componentsSeparatedByString:@";"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:type message:[NSString stringWithFormat:@"current: %@\npermission: %@", [getSetting objectForKey:KEY_PARAMETER], [getSettingOptions objectForKey:KEY_PERMISSION]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        if ([options count] > 1) {
                            for (id buttonTitle in options) {
                                if (buttonTitle && ![buttonTitle isEqualToString:@""])
                                    [alert addButtonWithTitle:buttonTitle];
                            }
                            [alert setAlertViewStyle:UIAlertViewStyleDefault];
                            [alert setTag:0];
                            
                        } else {
                            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                            [alert addButtonWithTitle:@"Set"];
                            [alert setTag:1];
                            
                        }
                        [alert show];
                    });
                }
            }
        }
    });
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *type = [alertView title];
    NSString *param = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView == self.listAlertView) {
        if (buttonIndex == 0) {
            return;
        }
        _list_Tag = (int)buttonIndex;
        NSDictionary *file = [self.listArray objectAtIndex:_list_Tag - 1];
        NSString *FolderName = [file objectForKey:VALUE_FILE_NAME];
        NSString *Slash = [FolderName substringWithRange:NSMakeRange(FolderName.length - 1,1)];
        if ([Slash isEqualToString:@"/"]) {
            [self getFileListPath: [NSString stringWithFormat:@"%@%@",type,param]];
        }else if (self.listArray) {
            self.downAlertView = [[downLoadView alloc]initWithDict:[self.listArray objectAtIndex:buttonIndex - 1]];
            self.downAlertView.center = self.view.center;
            self.downAlertView.delegate = self;
            [self.view addSubview:self.downAlertView];
            self.thumbresouceUrlPath = [file objectForKey:@"path"];
            self.thumbimageURLPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail_%@", param]];
            [_fnRemoteCamera downloadThumb:nil destPath:self.thumbimageURLPath srcPath:self.thumbresouceUrlPath top:NO priority:1];
        }
    }else if ([alertView tag] == 0 || [alertView tag] == 1) {
        if ([alertView tag] == 1)
            param = [[alertView textFieldAtIndex:0] text];
        switch (buttonIndex) {
            case 0:
                break;
            default:
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    BOOL isPlaying = playerStream && playerStream.rate;
                    NSDictionary *setSetting = [_fnRemoteCamera setSetting:type param:param];
                    [self getMessages:[self dicToJSONString:setSetting] duration:Duration position:@"center" showLog:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideIndcater];
//                        if (isPlaying && (!playerStream || !playerStream.rate)) {
//                            [self playerPlay];
//                        }
                    });
                });
            }
                break;
        }
    }
}

#pragma mark - Inital Player
- (void)playerInit{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playerRemove:YES];
        self.playerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 25, self.ControlBarView.frame.size.height / 2 + 25, 50, 50)];
        [self.playerImageView setImage:[UIImage imageNamed:@"Play"]];
        [self.ControlBarView addSubview:self.playerImageView];
        UITapGestureRecognizer *panGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerBtn)];
        [self.ControlBarView addGestureRecognizer:panGesture];
        [self.ControlBarView setHidden:NO];
    });
}

- (void)playerBtn{
    if (!_playerController) {
        [self playerPlay];
    } else {
        [self playerInit];
    }
}

- (void)playerPlay{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *getLivePath = [_fnRemoteCamera getLivePath];
        if ([[getLivePath objectForKey:KEY_ERROR_CODE] intValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playerRemove:NO];
                [self.refreshBtn setHidden:NO];
                _playerController = [FNPlayerController launchAsVideoPath:[getLivePath objectForKey:KEY_PARAMETER] options:nil];
                [self installPlayerNotification];
                [self.playerView addSubview:_playerController.view];
                [_playerController.view setFrame:self.playerView.bounds];
                _playerController.liveRTSPPlaying = YES;
            });
        } else {
            [self getMessages:[self dicToJSONString:getLivePath] duration:Duration position:@"center" showLog:YES];
        }
    });
}

- (void) installPlayerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStop) name:FNPlayerDidPlayToEndTimeNotification object:_playerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURLFail) name:FNPlayerFailedToPlayToEndTimeErrorKey object:_playerController];
}

- (void)playerRemove:(BOOL)hideBtn{
    if (hideBtn) {
        [self.refreshBtn setHidden:YES];
        [self.ControlBarView setHidden:YES];
    }
    if (_playerController) {
        [_playerController.view removeFromSuperview];
        _playerController = nil;
    }
    if (self.playerImageView) {
        [self.playerImageView removeFromSuperview];
        self.playerImageView = nil;
    }
}
#pragma mark - FNPlayer Delegate
- (void)openURLFail {
    FNLog(@"openURLFail");
    [self getMessages:@"player init fail, please check file path!" duration:Duration position:@"center" showLog:NO];
    [self onStop];
}

- (void) onStop {
    [self playerInit];
}

#pragma mark - Delegate
- (void)downloadfile{
    if (self.listArray) {
        NSDictionary *fileObject = [self.listArray objectAtIndex:self.list_Tag - 1];
        self.resouceUrlPath = [fileObject objectForKey:@"path"];
        self.imageURLPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[fileObject objectForKey:@"name"]];
        if (self.isDownLoading) {
            [self.downAlertView.downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
            [_fnRemoteCamera stopDownloadFile:self.resouceUrlPath deleteCache:NO];
        }else{
            [self.downAlertView.downloadBtn setTitle:@"Stop" forState:UIControlStateNormal];
            NSDictionary * file_Attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:self.imageURLPath error:nil];
            if ((BOOL)[[NSFileManager defaultManager] fileExistsAtPath:self.imageURLPath] && [[file_Attributes valueForKey:@"NSFileSize"] integerValue] == [[self.listArray[self.list_Tag - 1] valueForKey:@"size"] integerValue]) {
                [[NSFileManager defaultManager] removeItemAtPath:self.imageURLPath error:nil];
            }
            [_fnRemoteCamera downloadFile:nil destPath:self.imageURLPath srcPath:self.resouceUrlPath top:NO priority:1 append:YES];
            [self.delegate downloadfile];
        }
    }
}

- (void)deletefile{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.resouceUrlPath = [[self.listArray objectAtIndex:self.list_Tag - 1] objectForKey:@"path"];
        NSDictionary *deleteFile = [_fnRemoteCamera deleteFile:self.resouceUrlPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[deleteFile objectForKey:KEY_ERROR_CODE] intValue] == 0) {
                [self.downAlertView removeFromSuperview];
            }
            [self getMessages:[self dicToJSONString:deleteFile] duration:Duration position:@"center" showLog:YES];
            [self.delegate deletefile];
        });
    });
}
@end
