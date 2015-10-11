//
//  DTArticle.h
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTArticle : NSObject

@property (assign, nonatomic) id articleID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *contributor;
@property (copy, nonatomic) NSString *original_site_name;
@property (copy, nonatomic) NSString *is_recommend;
@property (copy, nonatomic) NSString *original_url;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *thumbnail;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
