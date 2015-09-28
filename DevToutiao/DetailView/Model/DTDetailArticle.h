//
//  DTDetailArticle.h
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTDetailArticle : NSObject

@property (assign, nonatomic) id articleId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *original_site_name;
@property (copy, nonatomic) NSString *share_url;
@property (copy, nonatomic) NSString *share_image_url;
@property (copy, nonatomic) NSString *original_url;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *body;
@property (assign, getter=isComment_disable) BOOL comment_disable;
@property (assign, nonatomic) id comment_count;
@property (assign, nonatomic) id like_count;
@property (assign, nonatomic) id favorite_count;
@property (assign, getter=isDisplay_full_content) BOOL display_full_content;
@property (copy, nonatomic) NSArray *css;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
