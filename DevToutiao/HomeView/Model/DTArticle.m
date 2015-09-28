//
//  DTArticle.m
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTArticle.h"

@implementation DTArticle

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _articleID = dic[@"id"];
        _title = dic[@"title"];
        _contributor = dic[@"contributor"];
        _original_site_name = dic[@"original_site_name"];
        _is_recommend = dic[@"is_recommend"];
        _original_url = dic[@"original_url"];
        _image = dic[@"image"];
        _thumbnail = dic[@"thumbnail"];
    }
    
    return self;
}

@end
