//
//  APKFileView.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/3/18.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "APKFileView.h"

@implementation APKFileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.videoL.text = NSLocalizedString(@"视频", nil);
    self.imageL.text = NSLocalizedString(@"照片", nil);
}


- (IBAction)clickFileButton:(UIButton *)sender {
    NSLog(@"is tip....");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedFileButton:)]) {
        [self.delegate didSelectedFileButton:sender];
    }
}

@end
