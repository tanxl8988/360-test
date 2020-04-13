//
//  fileListCell.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/19.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol APKFileCellDelegate <NSObject>
- (void)clickDownloadButtonAction:(NSInteger)tag;
- (void)clickDeleteButtonAction:(NSInteger)tag;
@end

@interface fileListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIButton *cellDownloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *cellDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) id<APKFileCellDelegate>delegate;

-(NSString *)handleSizeStr:(NSString *)sizeStr;
- (UIImage*) getVideoPreViewImage:(NSURL *)path;
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
