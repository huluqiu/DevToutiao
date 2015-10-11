//
//  DTDetailHeaderView.m
//  DevToutiao
//
//  Created by alezai on 15/10/11.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTDetailHeaderView.h"
#import <Masonry.h>

@implementation DTDetailHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.detailLabel = [UILabel new];
        self.detailLabel.font = [UIFont boldSystemFontOfSize:10];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(5);
            make.right.equalTo(weakSelf).with.offset(-20);
            make.bottom.equalTo(weakSelf).with.offset(-5);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
