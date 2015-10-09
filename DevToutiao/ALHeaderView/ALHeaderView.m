//
//  ALHeaderView.m
//  MyTest
//
//  Created by alezai on 15/9/28.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "ALHeaderView.h"
#import "DTMacro.h"

#import <Masonry.h>
#import <UIImageView+AFNetworking.h>
#import "DTPromotion.h"

@interface ALHeaderView ()

@end

@implementation ALHeaderView

- (instancetype)initHeaderViewWithType:(HeaderType)type{
    if (self = [super init]) {
        
        __weak typeof(self) weakSelf = self;
        
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(20);
            make.right.equalTo(weakSelf).with.offset(-40);
            make.bottom.equalTo(weakSelf).with.offset(-20);
        }];
        
        if (type == Detail_Header){
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
    }
    
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    } else {
        return result;
    }
}

@end
