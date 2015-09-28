//
//  DTArticleCell.h
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTArticle.h"

@interface DTArticleCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *siteNameLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;

- (void)setCellContentWithArticle:(DTArticle *)article;

@end
