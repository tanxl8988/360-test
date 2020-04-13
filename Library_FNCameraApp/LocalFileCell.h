//
//  LocalFileCell.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

NS_ASSUME_NONNULL_BEGIN
@protocol APKLocalFileCellDelegate <NSObject>
- (void)deleteLocalFileButtonAction:(NSInteger)tag;
- (void)shareButtonAction:(NSInteger)tag;
@end
@interface LocalFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellSize;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) id<APKLocalFileCellDelegate>delegate;

-(NSString *)handleSizeStr:(NSString *)sizeStr;
- (UIImage*) getVideoPreViewImage:(NSURL *)path;

@end

NS_ASSUME_NONNULL_END
