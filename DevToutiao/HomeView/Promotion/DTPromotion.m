//
//  DTPromotion.m
//  DevToutiao
//
//  Created by alezai on 15/9/29.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTPromotion.h"

@implementation DTPromotion

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _promotionId = dic[@"id"];
        _title = dic[@"title"];
        _image = dic[@"image"];
    }
    return self;
}

@end
