//
//  APKProgressView.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/20.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import "APKProgressView.h"

@implementation APKProgressView


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCancelDownloadButtonAction)]) {
        [self.delegate clickCancelDownloadButtonAction];
        NSLog(@"");
        NSLog(@"");
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
