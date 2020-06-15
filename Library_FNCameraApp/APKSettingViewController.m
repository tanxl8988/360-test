//
//  APKSettingViewController.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/10.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "APKSettingViewController.h"
#import "FNISDKToolViewController.h"
#import "APKAlertTool.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@import Library_FNCamera;

@interface APKSettingViewController ()
@property (nonatomic, strong) FNRemoteCamera *remoteCamera;
@property (nonatomic,retain) NSArray *switchTypeArr;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switchArr;
@property (nonatomic,retain) NSArray *alertTypeArr;
@property (nonatomic,retain) NSDictionary *alertTypeNameDic;
@property (nonatomic,retain) NSArray *alertParamArr;
@property (nonatomic,retain) NSDictionary *paramLocalNameDic;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *valuesL;
@property (nonatomic,retain) UILabel *currentL;
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *remainingSpaceL;
@property (weak, nonatomic) IBOutlet UILabel *cameraVersionL;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *namesL;
@property (nonatomic,assign) BOOL isConnected;
@property (nonatomic,retain) UIView *keyView;
@property (nonatomic,assign) BOOL isRecord;
@property (nonatomic,retain) NSArray *nameArr;
@property (nonatomic,retain) NSArray *cellArr;
@property (weak, nonatomic) IBOutlet UITableViewCell *resolutionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *exposureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *videoCyclicCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *parkingModeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *autoVideoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *correctTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *G_sensorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *screenSaverCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *voiceSetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *languageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *formatSDCardCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *factorySetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wifiModeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *remainingSpaceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (weak, nonatomic) IBOutlet UILabel *resolutionL;
@property (weak, nonatomic) IBOutlet UITableViewCell *WiFiSetCell;
@property (weak, nonatomic) IBOutlet UILabel *WiFILabel;

@property (assign,nonatomic) BOOL allowStopRecord;


@end

@implementation APKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.keyView = [UIApplication sharedApplication].keyWindow;
    
    self.tabBarItem.title = NSLocalizedString(@"设置", nil);
    
    for (int i = 0; i < self.namesL.count; i++) {

        UILabel *l = self.namesL[i];
        l.text = self.nameArr[i];
    }
    __weak typeof (self) weakself = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:@"WIFIISCLOSE" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakself.isConnected = NO;
    }];
 
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FNISDKToolViewController *previewVC = self.tabBarController.viewControllers.firstObject;
    self.remoteCamera = previewVC.remoteCamera;
    self.cameraVersionL.text = previewVC.cameraVersion;
    self.isRecord = previewVC.isRecord;
    
    if (previewVC.isConnected == YES){
        
//        [self.remoteCamera stopRecord];
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.keyView animated:YES];
        [self performSelector:@selector(getSettingInfo) withObject:nil afterDelay:0.1f];
        self.isConnected = YES;
    }
    else
        self.isConnected = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        Byte command[] = {4, 0, 3, 0};  // [Respond Type, Respond CommandID, Set/Get Type, Set/Get CommandID, Set/Get Data]
        NSDictionary *getSupportCommandLists = [self.remoteCamera sendCommandWithData:[NSData dataWithBytes:command length:sizeof(command)]];
        if ([getSupportCommandLists[KEY_ERROR_CODE] intValue] == 0) {
            NSData *param = getSupportCommandLists[KEY_PARAMETER];
            if ([param isKindOfClass:[NSData class]]) {
                NSLog(@"getSupportCommandLists: %@", [[NSString alloc] initWithBytes:param.bytes length:param.length encoding:NSUTF8StringEncoding]);
                NSLog(@"");
                // getSupportCommandLists: [0, 2, 2, 3]; [Respond Data]
            }
        }
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isRecord == YES)
        [self.remoteCamera startRecord];
    
    self.allowStopRecord = NO;
}

-(void)getSettingInfo
{
    
    NSDictionary *response = [self.remoteCamera getSettingsList];
    
    for (int i = 0; i < self.switchTypeArr.count; i++) {
        
        UISwitch *swi = self.switchArr[i];
        NSString *state = response[self.switchTypeArr[i]];
        swi.on = [state isEqualToString:@"on"] ? YES : NO;
    }
    
    for (int i = 0; i < self.alertTypeArr.count; i++) {
        
        UILabel *l = self.valuesL[i];
        NSString *value = response[self.alertTypeArr[i]];
        
        NSString *title = self.paramLocalNameDic[value];
        if (!title) title = value;
        l.text = title;
    }
    
    NSDictionary *freeSpaceResponse = [self.remoteCamera getSetting:@"camera_free"];
    float freeSpace = [freeSpaceResponse[@"param"] floatValue];
    NSString *spaceStr = [NSString stringWithFormat:@"%.2fGB",freeSpace/(1024*1024*1024)];
    self.remainingSpaceL.text = spaceStr;
    self.resolutionL.text = response[@"video_resolution"];
    
    [self.HUD hideAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cellNum = self.cellArr[section];
    return cellNum.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArr[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakself = self;
    
    if (!self.isConnected) {
        [APKAlertTool showAlertInViewController:self message:NSLocalizedString(@"Wi-Fi未连接", nil)];
        return;
    }
    
    [self alertToStopRecord:^(bool state) {
        if (!state) {
            return;
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.tag == 0) return;
        
        if (cell.tag == 100) {
            
            weakself.HUD = [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
            [APKAlertTool showAlertInViewController:weakself title:nil message:NSLocalizedString(@"确定要格式化吗", nil) confirmHandler:^(UIAlertAction *action) {
                
                [weakself.HUD hideAnimated:YES];
                NSDictionary *response = [weakself.remoteCamera setSetting:@"format" param:nil];
                if([response[KEY_ERROR_CODE] integerValue] == 0)
                    [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"格式化成功", nil)];
                else
                    [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"格式化失败", nil)];
                
            } cancelHandler:^(UIAlertAction *action) {
                [weakself.HUD hideAnimated:YES];
            }];
            
        }else if(cell.tag == 101){
            
            weakself.HUD = [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
            [APKAlertTool showAlertInViewController:weakself title:nil message:NSLocalizedString(@"确定要恢复出厂设置吗", nil) confirmHandler:^(UIAlertAction *action) {
                
                [weakself.HUD hideAnimated:YES];
                NSDictionary *response = [weakself.remoteCamera setSetting:@"camera_reset" param:nil];
                if([response[KEY_ERROR_CODE] integerValue] == 0)
                    [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"恢复出厂设置成功", nil)];
                else
                    [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"恢复出厂设置失败", nil)];
                
            } cancelHandler:^(UIAlertAction *action) {
                [weakself.HUD hideAnimated:YES];
            }];
        }else if(cell == self.WiFiSetCell){
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"WIFI设置"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            __block int i = 0;

              UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {
                                                                        //响应事件
                  NSString *ssidStr = alert.textFields[1].text;
                  if (ssidStr.length == 0) {
                      [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"设置失败，SSID不得为空", nil)];
                      return;
                  }
                  
                  NSString *passWordStr = alert.textFields[1].text;
                  if (passWordStr.length < 8) {
                      [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"设置失败，密码不得小于8位", nil)];
                      return;
                  }
                for(UITextField *text in alert.textFields){
                    NSLog(@"text = %@", text.text);
                    NSString *Str = i == 0 ? @"wifi_ssid" : @"wifi_password";
                    NSDictionary *respose = [self.remoteCamera setSetting:Str param:text.text];
                    
                    if([respose[KEY_ERROR_CODE] integerValue] != 0){
                        [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"设置失败", nil)];
                        break;
                    }
                    
                    if(i == 1){
                        [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"设置成功,重启机器之后生效", nil)];
                    }
                    i++;
                }
            }];
              UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction * action) {
                                                                       //响应事件
                                                                       NSLog(@"action = %@", alert.textFields);
                                                                   }];
            FNISDKToolViewController *previewVC = self.tabBarController.viewControllers.firstObject;
            __block NSString *ssid = previewVC.SSID;
            __block NSString *password = previewVC.password;
              [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                  textField.text = ssid;
                  textField.keyboardType = UIKeyboardTypeASCIICapable;
              }];
              [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                  textField.text = password;
                  textField.keyboardType = UIKeyboardTypeNumberPad;

//                  textField.secureTextEntry = YES;
              }];
                
              [alert addAction:okAction];
              [alert addAction:cancelAction];
              [self presentViewController:alert animated:YES completion:nil];
            
        }else if (cell.tag == 103){
            
            [self.remoteCamera stopRecord];
            NSDictionary *response = [weakself.remoteCamera setSetting:@"camera_clock" param:[weakself currentTime]];
            if([response[KEY_ERROR_CODE] integerValue] == 0)
                [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"校准时间成功", nil)];
            else
                [APKAlertTool showAlertInViewController:weakself message:NSLocalizedString(@"校准时间失败", nil)];
        }else{
            
            NSString *type = weakself.alertTypeArr[cell.tag - 1];
            NSArray *params = weakself.alertParamArr[cell.tag - 1];
            weakself.currentL = weakself.valuesL[cell.tag - 1];
            [weakself setAlertActionWithType:type andPatam:params];
        }
    }];
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

-(void)alertToStopRecord:(void(^)(bool state))recordState;
{
    __weak typeof(self) weakSelf = self;
    
    if (!self.isRecord || self.isRecord == NO) {
        recordState(YES);
        return;
    }
    
    if (!self.allowStopRecord) {
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"执行此操作需停止录像?", nil) confirmHandler:^(UIAlertAction *action) {
            
            weakSelf.allowStopRecord = YES;
            recordState(YES);
            [weakSelf.remoteCamera stopRecord];
            dispatch_async(dispatch_get_main_queue(), ^{
            [APKAlertTool showAlertInView:weakSelf.view andText:NSLocalizedString(@"录像已停止", nil)];
            });
        } cancelHandler:^(UIAlertAction *action) {
            recordState(NO);
        }];
    }else
        recordState(YES);
}

-(void)setAlertActionWithType:(NSString *)type andPatam:(NSArray *)paramArr
{
    __weak typeof (self) weakself = self;
    NSString *alertName = self.alertTypeNameDic[type];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:alertName
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < paramArr.count; i++) {
        
        NSString *param = paramArr[i];
        NSString *title = weakself.paramLocalNameDic[param];
        if (!title) title = param;
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            weakself.HUD = [MBProgressHUD showHUDAddedTo:weakself.keyView animated:YES];
            NSDictionary *response = [weakself.remoteCamera setSetting:type param:param];
            [weakself checkErrorStatus:response isAlertAction:YES andTitle:title];
        }];
        
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (IBAction)clickSwitchActions:(UISwitch *)sender {
    
    if (!self.isConnected) {
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"Wi-Fi未连接", nil) handler:^(UIAlertAction *action) {
            sender.on = !sender.isOn;
        }];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self alertToStopRecord:^(bool state) {
        
        if (!state) {
            sender.on = !sender.isOn;
            return;
        }else{
            weakSelf.HUD = [MBProgressHUD showHUDAddedTo:weakSelf.keyView animated:YES];
            [weakSelf.tableView setScrollEnabled:NO];
            
            NSString *type = weakSelf.switchTypeArr[sender.tag];
            NSString *param = sender.isOn == YES ? @"on" : @"off";
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *response = [weakSelf.remoteCamera setSetting:type param:param];
                [weakSelf checkErrorStatus:response isAlertAction:NO andTitle:nil];
            });
        }
    }];
}

- (void) checkErrorStatus:(NSDictionary*) response isAlertAction:(BOOL)isAlert andTitle:(NSString*)title {
    
    __weak typeof (self) weakself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakself.HUD hideAnimated:YES afterDelay:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakself.tableView setScrollEnabled:YES];
            if ([response[KEY_ERROR_CODE] integerValue] != 0) {
                
                [APKAlertTool showAlertInViewController:weakself title:nil message:@"设置失败" handler:^(UIAlertAction *action) {
                    nil;
                }];
            }else{
                
                if (isAlert == YES) weakself.currentL.text = title;
//                [APKAlertTool showAlertInViewController:self title:nil message:@"设置成功" handler:^(UIAlertAction *action) {
//                    nil;
//                }];
//                [self.view makeToast:NSLocalizedString(@"设置成功", nil)];
            }
        });
    });
}


-(NSArray *)switchTypeArr
{
    if (!_switchTypeArr) {
        _switchTypeArr = @[@"video_stamp",@"video_wdr",@"video_motion_det",@"auto_record",@"video_audio",@"button_sound"];
    }
    return _switchTypeArr;
}

-(NSArray *)alertTypeArr
{
    if (!_alertTypeArr) {
        _alertTypeArr = @[@"video_ev",@"video_cyclic",@"",@"sensor_sensitivity",@"auto_screen_poweroff",@"light_frequency",@"language",@"auto_poweroff",@"wifi_mode"];
    }
    return _alertTypeArr;
}

-(NSDictionary *)alertTypeNameDic
{
    if (!_alertTypeNameDic) {
        _alertTypeNameDic = @{@"video_ev":NSLocalizedString(@"录像曝光补偿", nil),@"video_cyclic":NSLocalizedString(@"循环录像周期", nil),@"":NSLocalizedString(@"", nil),@"sensor_sensitivity":NSLocalizedString(@"重力感应", nil),@"auto_screen_poweroff":NSLocalizedString(@"屏幕保护", nil),@"light_frequency":NSLocalizedString(@"光源频率", nil),@"language":NSLocalizedString(@"相机语言", nil),@"auto_poweroff":NSLocalizedString(@"定时关机", nil),@"wifi_mode":NSLocalizedString(@"Wi-Fi模式", nil)};
    }
    return _alertTypeNameDic;
}

-(NSArray *)alertParamArr
{
    if (!_alertParamArr) {
        _alertParamArr = @[@[@"+2.0",@"+1.7",@"+1.3",@"+1.0",@"+0.7",@"+0.3",@"0.0",@"-0.3",@"-0.7",@"-1.0",@"-1.3",@"-1.7",@"-2.0"],@[@"off",@"1 min",@"3 min",@"5 min"],@[],@[@"off",@"level1",@"level2",@"level3",@"level4"],@[@"off",@"1 min",@"3 min",@"5 min"],@[@"50Hz",@"60Hz"],@[@"EN",@"JA",@"TC",@"SC",@"ES",@"FR"],@[@"off",@"1 min",@"3 min",@"5 min"],@[@"ap",@"station"]];
    }
    return _alertParamArr;
}

-(NSDictionary *)paramLocalNameDic
{
    if (!_paramLocalNameDic) {
        _paramLocalNameDic = @{@"off":NSLocalizedString(@"关闭", nil),@"1 min":NSLocalizedString(@"1 分钟", nil),@"3 min":NSLocalizedString(@"3 分钟", nil),@"5 min":NSLocalizedString(@"5 分钟", nil),@"EN":NSLocalizedString(@"English", nil),@"JA":NSLocalizedString(@"日本語", nil),@"TC":NSLocalizedString(@"繁體中文", nil),@"SC":NSLocalizedString(@"简体中文", nil),@"ES":NSLocalizedString(@"Espanol", nil),@"FR":NSLocalizedString(@"Français", nil),@"ap":NSLocalizedString(@"一般", nil),@"station":NSLocalizedString(@"热点", nil)};
    }
    return _paramLocalNameDic;
}

-(NSArray *)nameArr
{
    if (!_nameArr) {
        _nameArr = @[NSLocalizedString(@"视频分辨率", nil),NSLocalizedString(@"视频戳记", nil),NSLocalizedString(@"录像曝光补偿", nil),NSLocalizedString(@"循环录像周期", nil),NSLocalizedString(@"录像宽动态", nil),NSLocalizedString(@"移动侦测", nil),NSLocalizedString(@"自动录像", nil),NSLocalizedString(@"校准时间", nil),NSLocalizedString(@"重力感应", nil),NSLocalizedString(@"录像设定", nil),NSLocalizedString(@"屏幕保护", nil),NSLocalizedString(@"光源频率", nil),NSLocalizedString(@"按键音设定", nil),NSLocalizedString(@"相机语言", nil),NSLocalizedString(@"定时关机", nil),NSLocalizedString(@"格式化存储卡", nil),NSLocalizedString(@"恢复出厂设置", nil),NSLocalizedString(@"Wi-Fi模式", nil),NSLocalizedString(@"相机剩余空间", nil),NSLocalizedString(@"相机软件版本", nil)];
    }
    return _nameArr;
}

-(NSArray *)cellArr
{
    if (!_cellArr) {
        _cellArr = @[@[self.resolutionCell,self.exposureCell],@[self.correctTimeCell,self.wifiModeCell],@[self.G_sensorCell,self.voiceSetCell,self.languageCell,self.formatSDCardCell,self.factorySetCell,self.WiFiSetCell],@[self.remainingSpaceCell,self.versionCell]];
    }
    return _cellArr;
}

@end
