//
//  LocalFileCell.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "LocalFileCell.h"

@implementation LocalFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [self.shareBtn setTitle:NSLocalizedString(@"分享", nil) forState:UIControlStateNormal];

    // Initialization code
}
- (IBAction)deleteBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteLocalFileButtonAction:)]) {
        [self.delegate deleteLocalFileButtonAction:sender.tag];
    }
}
- (IBAction)shareBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonAction:)]) {
        [self.delegate shareButtonAction:sender.tag];
    }
}

-(NSString *)handleSizeStr:(NSString *)sizeStr
{
    float f = [sizeStr floatValue];
    NSString *size = [NSString stringWithFormat:@"%.1fM",f/(1024*1024)];
    return size;
}

- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
