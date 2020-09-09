//
//  APKFileView.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/3/18.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class APKFlodersView;
@protocol APKFlodersViewDelegate <NSObject>

- (void)didSelectedFileButton:(UIButton*)button;
@end

@interface APKFileView : UIView
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UILabel *videoL;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *imageL;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (weak, nonatomic) IBOutlet UILabel *eventL;
@property (weak, nonatomic) IBOutlet UIButton *parkingButton;
@property (weak, nonatomic) IBOutlet UILabel *parkingL;

@property (weak,nonatomic) id<APKFlodersViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
