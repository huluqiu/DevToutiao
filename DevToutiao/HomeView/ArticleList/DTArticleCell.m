//
//  DTArticleCell.m
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTArticleCell.h"
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>

@implementation DTArticleCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        _siteNameLabel = [[UILabel alloc] init];
        [self addSubview:_siteNameLabel];
        
        _thumbnailImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbnailImageView];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        _siteNameLabel = [[UILabel alloc] init];
        [self addSubview:_siteNameLabel];
        
        _thumbnailImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbnailImageView];
    }
    return self;
}

- (void)setCellContentWithArticle:(DTArticle *)article{
    __weak typeof(self) weakSelf = self;
    
    self.titleLabel.text = article.title;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf).with.offset(10);
        make.right.equalTo(weakSelf.thumbnailImageView.mas_left).with.offset(-20);
    }];
    
    self.siteNameLabel.text = article.original_site_name;
    self.siteNameLabel.font = [UIFont boldSystemFontOfSize:10];
    self.siteNameLabel.textColor = [UIColor grayColor];
    [self.siteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_left);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(weakSelf).with.offset(-5);
    }];
    CGSize size = [self.siteNameLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.siteNameLabel.frame))];
    CGRect frame = self.siteNameLabel.frame;
    self.siteNameLabel.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, CGRectGetHeight(frame));

    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:article.thumbnail]];
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.top.equalTo(weakSelf.titleLabel.mas_top);
        make.bottom.equalTo(weakSelf).with.offset(-10);
        make.right.equalTo(weakSelf).with.offset(-20);
    }];

}

@end
