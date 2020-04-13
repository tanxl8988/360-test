//
//  APKProgressView.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/20.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol APKProgressViewDelegate <NSObject>
- (void)clickCancelDownloadButtonAction;
@end

@interface APKProgressView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressL;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) id<APKProgressViewDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
