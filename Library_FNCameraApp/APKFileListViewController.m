//
//  APKFileListViewController.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/17.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "APKFileListViewController.h"
#import "fileListCell.h"
#import "LocalFileCell.h"
#import "APKDVRFile.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "APKProgressView.h"
#import "LocalFileInfo+CoreDataClass.h"
#import "APKMOCManager.h"
#import "UIView+Toast.h"
#import "APKAlertTool.h"
#import "APKRemotePlayerViewController.h"
#import "LocalFileInfo+CoreDataClass.h"
#import "APKMOCManager.h"

#define VIDEO @"Video"
#define IMAGE @"Image"
#define EVENT @"Event"
#define PARKING @"Parking"


@interface APKFileListViewController ()<APKFileCellDelegate,FNListenerDelegate,APKProgressViewDelegate,APKLocalFileCellDelegate>
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) BOOL isScrolling;
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (nonatomic,retain) APKProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,assign) NSInteger currentFileindex;
@property (nonatomic,assign) BOOL isRemoteCameraSource;
@property (nonatomic,retain) UILabel *noFileL;
@property (nonatomic,retain) NSMutableDictionary *preveiwImageDic;
@property (nonatomic,assign) int requestCount;
@property (assign,nonatomic) BOOL allowStopRecord;
@property (assign,nonatomic) BOOL goToPlayerVC;
@property (nonatomic,retain) NSArray *doubleDataArr;
@property (nonatomic,retain) NSString *tempDeletePath;
@property (nonatomic,assign) BOOL isRefleshing;
@property (nonatomic,assign) BOOL isDownloading;

@end

@implementation APKFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 66;
    [self.backButton setTitle:NSLocalizedString(@"返回", nil)];
    
    if (self.type == APKTypeVideo || self.type == APKTypeImage || self.type == APKTypeEvent || self.type == APKTypeParking)
        self.isRemoteCameraSource = YES;
    
    self.remoteCamera.delegate = self;
    
    [self refreshPage];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    if (self.type == APKTypeImage || self.type == APKTypeVideo || self.type == APKTypeEvent || self.type == APKTypeParking) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
    }
    
    [self addObserver:self forKeyPath:@"previewVC.isConnected" options:NSKeyValueObservingOptionNew  context:nil];


//    [self.collectionView sendSubviewToBack:self.refreshControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    _requestCount = 0;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"previewVC.isConnected"]) {
        BOOL newValue = [change[@"new"] boolValue];
        if (newValue == NO) {
            [self disconnected];
        }
    }
}

-(void) pullRefresh
{
    self.isRefleshing = YES;
    [self refreshPage];
//    [self.refreshControl endRefreshing];
}

- (void)disconnected
{
    __weak typeof(self) weakSelf = self;
    [APKAlertTool showAlertInViewController:weakSelf message:NSLocalizedString(@"Wi-Fi未连接", nil)];
}

-(void)refreshPage
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *title = @"";
    switch (self.type) {
        case APKTypeVideo:
            title = NSLocalizedString(@"视频", nil);
            [self performSelector:@selector(getDVRFiles) withObject:nil afterDelay:0.1f];
            break;
        case APKTypeEvent:
            title = NSLocalizedString(@"事件", nil);
            [self performSelector:@selector(getDVRFiles) withObject:nil afterDelay:0.1f];
            break;
        case APKTypeParking:
            title = NSLocalizedString(@"停车监控", nil);
            [self performSelector:@selector(getDVRFiles) withObject:nil afterDelay:0.1f];
            break;
        case APKTypeImage:
            title = NSLocalizedString(@"照片", nil);
            [self performSelector:@selector(getDVRFiles) withObject:nil afterDelay:0.1f];
            break;
        case APKTypeLocalVideo:
            title = NSLocalizedString(@"视频", nil);
            [self getLocalFiles];
            break;
        case APKTypeLocalEvent:
            title = NSLocalizedString(@"事件", nil);
            [self getLocalFiles];
            break;
        case APKTypeLocalParking:
            title = NSLocalizedString(@"停车监控", nil);
            [self getLocalFiles];
            break;
        default:
            title = NSLocalizedString(@"照片", nil);
            [self getLocalFiles];
            break;
    }
    self.title = title;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.player stop];
    self.goToPlayerVC =NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.preveiwImageDic forKey:@"APKDVRFILEPREVIEWIMAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"alreadySaveFileCount:%ld",[self.preveiwImageDic allKeys].count);
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if (self.previewVC.isRecord == YES && !self.goToPlayerVC)
        [self.remoteCamera startRecord];
}

-(void)getLocalFiles
{
    NSString *type = [self getLocalVideoType];
    NSArray *localFilesArr = [LocalFileInfo retrieveLocalfileInfosWithType:type offset:0 count:1000 context:[APKMOCManager sharedInstance].context];
    [self.dataArr addObjectsFromArray:localFilesArr];
    
    NSMutableArray *arr = [NSMutableArray array];
    int count = (int)self.dataArr.count - 1;
    for (int i = 0; i <= count; i++) {
        [arr addObject:self.dataArr[count - i]];
    }
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    [self.HUD hideAnimated:YES];
    
    if (localFilesArr.count == 0)
        [self.view addSubview:self.noFileL];
    [self.refreshControl endRefreshing];

}

-(void)getDVRFiles
{
//    if (self.dataArr.count > 0) [self.dataArr removeAllObjects];
    self.dataArr = [NSMutableArray array];
    
    NSDictionary *response = @{};
    if (self.type == APKTypeVideo)
        response = [self.remoteCamera getFileList:[NSString stringWithFormat:@"%@video",self.rootPath]];
    else if(self.type == APKTypeImage)
        response = [self.remoteCamera getFileList:[NSString stringWithFormat:@"%@snapshots",self.rootPath]];
    else if(self.type == APKTypeEvent)
          response = [self.remoteCamera getFileList:[NSString stringWithFormat:@"%@event",self.rootPath]];
    else if(self.type == APKTypeParking)
          response = [self.remoteCamera getFileList:[NSString stringWithFormat:@"%@parking",self.rootPath]];

    NSString *containStr = @"";
    if (self.type == APKTypeVideo) {
        containStr = @"mp4";
    }else if(self.type == APKTypeImage){
        containStr = @"snapshot";
    }else if(self.type == APKTypeEvent){
        containStr = @"event";
    }else if(self.type == APKTypeParking){
        containStr = @"parking";
    }
    
    NSString *type = [self getLocalVideoType];
    NSArray *Arr = response[@"param"];
    for (NSDictionary *dic in Arr) {
        
        if ([dic[@"path"] containsString:containStr]) {
            APKDVRFile *file = [[APKDVRFile alloc] init];
            file.date = [self UTCDateFromLocalString:dic[@"date"]];
            file.name = dic[@"name"];
            NSString *path = [dic[@"path"] stringByReplacingOccurrencesOfString:@"ss" withString:@"s/s"];
            path = [path stringByReplacingOccurrencesOfString:@"video" withString:@"video/"];
            path = [path stringByReplacingOccurrencesOfString:@"event" withString:@"event/"];
            path = [path stringByReplacingOccurrencesOfString:@"parking" withString:@"parking/"];
            file.path = path;
            file.size = dic[@"size"];
   
            LocalFileInfo *localFile = [LocalFileInfo retrieveLocalFileInfoWithName:file.name type:type context:[APKMOCManager sharedInstance].context];
            file.isDownloaded = localFile == nil ? NO : YES;
            [self.dataArr addObject:file];
        }
    }
    [self.HUD hideAnimated:YES];
    NSArray *sortArr = [self.dataArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        APKDVRFile *file1 = obj1;
        APKDVRFile *file2 = obj2;
        return [file2.date compare:file1.date];
    }];
    self.dataArr = [NSMutableArray arrayWithArray:sortArr];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    if (self.type == APKTypeVideo || self.type == APKTypeEvent || self.type == APKTypeParking) {
        if (self.dataArr.count > 0) {
            self.doubleDataArr = [NSArray arrayWithArray:self.dataArr];
            self.requestCount = 0;
            [self getPreveiwImage];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.dataArr.count == 0 && (self.type == APKTypeImage || self.type == APKTypeVideo || self.type == APKTypeEvent || self.type == APKTypeParking)) {
        
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"没有获取到数据，是否继续获取?", nil) handler:^(UIAlertAction *action) {
            
            [weakSelf refreshPage];
        }];
    }
}

-(NSString *)getLocalVideoType
{
    NSString *type = @"";
    switch (self.type) {
        case APKTypeVideo:
        case APKTypeLocalVideo:
            type = VIDEO;
            break;
        case APKTypeEvent:
        case APKTypeLocalEvent:
            type = EVENT;
            break;
        case APKTypeParking:
        case APKTypeLocalParking:
            type = PARKING;
            break;
        default:
            type = IMAGE;
            break;
    }
    return type;
}


-(void)getPreveiwImage
{
    __block NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"APKDVRFILEPREVIEWIMAGE"];
    __block APKDVRFile *file = self.dataArr.count > 0 ? self.dataArr[_requestCount] : self.doubleDataArr[_requestCount];
    __weak typeof(self) weakSelf = self;
    if (![[dic allKeys] containsObject:file.name]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *urlStr = [NSString stringWithFormat:@"http://%@%@",self.IP,file.path];

            UIImage *image = [[fileListCell new] firstFrameWithVideoURL:[NSURL URLWithString:urlStr] size:CGSizeMake(60, 60)];
            NSMutableArray *arr = weakSelf.dataArr.count > 0 ? weakSelf.dataArr : weakSelf.doubleDataArr;
            file.previewImage = image;
            NSInteger index = [arr indexOfObject:file];
            NSArray *indexArr = @[[NSIndexPath indexPathForRow:index inSection:0]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image && image != nil) {
                    file.previewImage = image;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self.preveiwImageDic setObject:UIImagePNGRepresentation(image) forKey:file.name];
//                        [self.preveiwImageDic setObject:image forKey:file.name];
                    });
                    [weakSelf.tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            });
            weakSelf.requestCount++;
            NSLog(@"getFile.........%@",file.name);
            if (weakSelf.requestCount <= weakSelf.dataArr.count - 1) {
                [weakSelf getPreveiwImage];
            }
        });
    }else{
        NSLog(@"alreadyHaveFile.......%@",file.name);
        _requestCount++;
        if (_requestCount <= self.dataArr.count - 1) {
            [self getPreveiwImage];
        }
    }
}

-(void)alertToStopRecord:(void(^)(bool state))recordState;
{
    
    NSDictionary *dic = [self.remoteCamera getSetting:@"status"];
      if (![dic[@"param"] isEqualToString:@"record"]) {
          recordState(YES);
          return;
      }
    
    __weak typeof(self) weakSelf = self;
    if (!self.allowStopRecord) {
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"执行此操作需停止录像?", nil) handler:^(UIAlertAction *action) {
            
            weakSelf.allowStopRecord = YES;
            recordState(YES);
            if (weakSelf.previewVC.isRecord) {
                [weakSelf.remoteCamera stopRecord];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"录像已停止", nil)];
                });
            }else
                [weakSelf.remoteCamera stopRecord];
        }];
    }else
        recordState(YES);
}


-(NSDate *)UTCDateFromLocalString:(NSString *)localString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:localString];
    return date;
}

- (IBAction)backButtonClick:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isRemoteCameraSource) {
        
        fileListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        APKDVRFile *file = self.dataArr[indexPath.row];
        NSString *urlStr = [NSString stringWithFormat:@"http://%@%@",self.IP,file.path];
        
        if (self.type == APKTypeVideo || self.type == APKTypeEvent || self.type == APKTypeParking) {
            
            if (file.previewImage && file.previewImage != nil) {
                cell.imageView.image = file.previewImage;
            }else{
                NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"APKDVRFILEPREVIEWIMAGE"];
                NSArray *arr = [dic allKeys];
                if ([arr containsObject:file.name])
                    cell.imageView.image = [UIImage imageWithData:dic[file.name]];
            }
            
        }else
            [cell.cellImage setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];

        cell.cellTitle.text = file.name;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.size.text = [cell handleSizeStr:file.size];
        cell.cellDownloadBtn.tag = indexPath.row;
        cell.cellDownloadBtn.enabled = !file.isDownloaded ? YES : NO;
        cell.cellDeleteBtn.tag = indexPath.row;
        [cell.cellDeleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        NSString *downloadBtnTitle = file.isDownloaded == YES ? NSLocalizedString(@"已下载", nil) : NSLocalizedString(@"下载", nil);
        [cell.cellDownloadBtn setTitle:downloadBtnTitle forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }else
    {
        LocalFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"localCell"];
        LocalFileInfo *file = self.dataArr[indexPath.row];
        cell.cellTitle.text = file.name;
        cell.deleteBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        cell.cellSize.text = [cell handleSizeStr:file.size];
        [cell.deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [cell.shareBtn setTitle:NSLocalizedString(@"分享", nil) forState:UIControlStateNormal];
        switch (self.type) {
            case APKTypeLocalVideo:
            case APKTypeLocalEvent:
            case APKTypeLocalParking:

            {
                NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"APKDVRFILEPREVIEWIMAGE"];
                NSArray *arr = [dic allKeys];
                if ([arr containsObject:file.name])
                    cell.imageView.image = [UIImage imageWithData:dic[file.name]];
                else
                    cell.cellImage.image = [cell getVideoPreViewImage:[NSURL fileURLWithPath:file.url]];
            }
                break;
            default:
                cell.cellImage.image = [UIImage imageWithContentsOfFile:file.url];
                break;
        }

        cell.delegate = self;
        return cell;
    }
    return nil;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.type == APKTypeVideo)
        return;
    
    __weak typeof (self) weakself = self;

    __block NSString *url = @"";
    APKDVRFile *file = self.dataArr[indexPath.row];

    if (self.isRemoteCameraSource) {
        
        if (self.type == APKTypeImage) {
            url = [NSString stringWithFormat:@"http://%@%@",self.IP,file.path];
            [self performSegueWithIdentifier:@"pushRemotePlayer" sender:url];
        }
        
//        if (self.type == APKTypeVideo) {
//            [self alertToStopRecord:^(bool state) {
//                if (!state) {
//                    return;
//                }else{
//                    weakself.goToPlayerVC = YES;
//                    NSDictionary *response = [weakself.remoteCamera getStreamingPath:file.path protocol:nil];
//                    url = response[@"param"];
////                    [self performSegueWithIdentifier:@"pushRemotePlayer" sender:url];
//                }
//            }];
//        }
    }else{
        
        LocalFileInfo *file = self.dataArr[indexPath.row];
        [self performSegueWithIdentifier:@"pushRemotePlayer" sender:file.url];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    APKRemotePlayerViewController *playerVC = segue.destinationViewController;
    playerVC.remoteCamera = self.remoteCamera;
//    playerVC.player = self.player;
    playerVC.previewVC = self.previewVC;
    playerVC.url = sender;
    playerVC.type = self.type;
}

#pragma mark - APKDVRFileDelegate
-(void)clickDownloadButtonAction:(NSInteger)tag
{
    __weak typeof (self) weakself = self;

    [self alertToStopRecord:^(bool state) {
        if (!state) {
            return;
        }else{
            if (weakself.isDownloading == YES) {
                return;
            }
            
            weakself.currentFileindex = tag;
            weakself.isDownloading = YES;
            [weakself downloadFile];
        }
    }];
}

-(void)downloadFile
{
    [self.remoteCamera stopRecord];
    
    APKDVRFile *file = self.dataArr[self.currentFileindex];
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *savePath = [cachesDir stringByAppendingPathComponent:file.name];
    [self.remoteCamera downloadFile:savePath destPath:savePath srcPath:file.path top:YES priority:0 append:true];
    [self tableviewEnable:NO];
}

-(void)tableviewEnable:(BOOL)enable
{
    self.tableView.userInteractionEnabled = enable;
    self.backButton.enabled = enable;
    self.isDownloading = !enable;
}

- (void)onFileTransfer:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath sizeNow:(long long)sizeNow sizeAll:(long long)sizeAll fileInfo:(NSDictionary *)fileInfo status:(FNDataTransferStatus)status{
    
    APKDVRFile *file = self.dataArr[self.currentFileindex];
    switch (status) {
        case DOWNLOADED: {
            
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf tableviewEnable:YES];
                [weakSelf.progressView setHidden:YES];
            });
            NSString *type = [self getLocalVideoType];
            
            NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
            [context performBlock:^{
                //保存到数据库
                [LocalFileInfo createWithName:file.name type:type url:userInfo size:file.size context:[APKMOCManager sharedInstance].context];
                NSError *error = nil;
                [context save:&error];
                NSAssert(!error, @"保存下载文件信息到数据库失败");
                if (!error) {
                    file.isDownloaded = YES;
                    [weakSelf.tableView reloadData];
                }
            }];
        }
        case DOWNLOADING: {
            // 檔案下載中
            NSInteger progress = (NSInteger) (sizeNow * 100 / sizeAll);
            NSLog(@"download :%zd",progress);
            float showProgress = (float)progress/100;
            NSString *proressStr = [NSString stringWithFormat:@"%zd%%/100%%",progress];
            
            self.progressView.titleL.text = file.name;
            self.progressView.progressView.progress = showProgress;
            self.progressView.progressL.text = proressStr;
            self.progressView.hidden = NO;
            self.progressView.center = self.view.center;
            break;
        }
        case DOWNLOAD_STOP: {
            // 檔案下載停止
            [self tableviewEnable:YES];
            self.progressView.hidden = YES;
            [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"取消下载成功", nil)];
            break;
        }
        case DOWNLOAD_FAIL: {
            // 檔案下載失敗
            self.progressView.hidden = YES;
            [self tableviewEnable:YES];
            [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"下载失败", nil)];
            break;
        }
        default:
            self.progressView.hidden = YES;
            [self tableviewEnable:YES];
            break;
    }
}

- (void)onCameraUnstableAndReconnectSuccess
{
    [self tableviewEnable:YES];
    self.progressView.hidden = YES;
    [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"机器断开重连成功", nil)];
}

-(void)clickDeleteButtonAction:(NSInteger)tag
{
    __weak typeof(self) weakSelf = self;
    [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"确定删除该文件吗", nil) handler:^(UIAlertAction *action) {
        
        APKDVRFile *file = weakSelf.dataArr[tag];
        NSDictionary *response = [weakSelf.remoteCamera deleteFile:file.path];
        if ([response[KEY_ERROR_CODE] integerValue] == 0){
            
            [weakSelf.dataArr removeObjectAtIndex:tag];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
            NSArray * deleteArr = @[indexPath];
            [weakSelf.tableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationRight];
            [weakSelf.tableView reloadData];
            if (weakSelf.dataArr.count == 0) {
                [weakSelf.view addSubview:weakSelf.noFileL];
            }
        }else
            [APKAlertTool showAlertInViewController:weakSelf message:NSLocalizedString(@"删除失败", nil)];
    }];
}


#pragma mark - APKLocalFileCellDelegate

-(void)deleteLocalFileButtonAction:(NSInteger)tag
{
    __block LocalFileInfo *file = self.dataArr[tag];
    self.tempDeletePath = file.url;
        
    __weak typeof(self)weakSelf = self;
    NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
    [context performBlock:^{
       
        [context deleteObject:file];
        NSError *error = nil;
        [context save:&error];
        NSAssert(!error, @"删除数据库失败");
        if (!error) {
            
            BOOL ab = [[NSFileManager defaultManager] removeItemAtPath:weakSelf.tempDeletePath error:&error];
            [weakSelf.dataArr removeObjectAtIndex:tag];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
            NSArray * deleteArr = @[indexPath];
            [weakSelf.tableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationRight];
            [weakSelf.tableView reloadData];
            if (weakSelf.dataArr.count == 0) {
                [weakSelf.view addSubview:weakSelf.noFileL];
            }
        }
    }];

}

-(void)shareButtonAction:(NSInteger)tag
{
    LocalFileInfo *file = self.dataArr[tag];
    UIImage *previewImage = [UIImage imageWithContentsOfFile:file.url];
    NSArray *activityItems = @[];
    NSURL *URL = [NSURL fileURLWithPath:file.url];
    if (self.type == APKTypeLocalImage)
        activityItems = @[previewImage];
    else
        activityItems = @[URL];
    if (activityItems.firstObject && activityItems.firstObject != nil) {
        UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:avc animated:YES completion:nil];
    }
}

#pragma mark - APKProgressViewDelegate
-(void)clickCancelDownloadButtonAction
{
    APKDVRFile *file = self.dataArr[self.currentFileindex];
    [self.remoteCamera stopDownloadFile:file.path deleteCache:NO];
    [self.progressView setHidden:YES];
    [self tableviewEnable:YES];
}



-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(APKProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[NSBundle mainBundle] loadNibNamed:@"APKProgressView" owner:nil options:nil].firstObject;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _progressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 40, 200);
        _progressView.delegate = self;
        [window addSubview:_progressView];
    }
    return _progressView;
}

-(UILabel *)noFileL
{
    if (!_noFileL) {
        _noFileL = [[UILabel alloc] initWithFrame:self.view.bounds];
        _noFileL.text = NSLocalizedString(@"暂无文件", nil);
        _noFileL.textAlignment = NSTextAlignmentCenter;
    }
    return _noFileL;
}
-(NSMutableDictionary *)preveiwImageDic
{
    if (!_preveiwImageDic) {
       NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"APKDVRFILEPREVIEWIMAGE"];
        _preveiwImageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return _preveiwImageDic;
}

-(NSArray *)doubleDataArr
{
    if (!_doubleDataArr) {
        _doubleDataArr = @[];
    }
    return _doubleDataArr;
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
