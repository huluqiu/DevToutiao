//
//  DTDetailArticle.m
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTDetailArticle.h"

@implementation DTDetailArticle

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _articleId = dic[@"id"];
        _title = dic[@"title"];
        _author = dic[@"author"];
        _original_site_name = dic[@"original_site_name"];
        _share_url = dic[@"share_url"];
        _share_image_url = dic[@"share_image_url"];
        _original_url = dic[@"original_url"];
        _image = dic[@"image"];
        _body = dic[@"body"];
        _comment_disable = dic[@"comment_disable"];
        _comment_count = dic[@"comment_count"];
        _like_count = dic[@"like_count"];
        _favorite_count = dic[@"favorite_count"];
        _display_full_content = dic[@"display_full_content"];
        _css = dic[@"css"];
    }
    return self;
}

@end
