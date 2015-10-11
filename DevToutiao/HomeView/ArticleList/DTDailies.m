//
//  DTDailies.m
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTDailies.h"
#import "DTArticle.h"

@implementation DTDailies

- (instancetype)initWithDictionary:(NSDictionary *)dic{

    if (self = [super init]) {
        _date = dic[@"date"];
        _pre_date = dic[@"pre_date"];
        _next_date = dic[@"next_date"];
        _today = dic[@"is_today"];
        
        _articleArray = [NSArray arrayWithArray:[self articleArrayWithDicArray:dic[@"article"]]];
    }
    
    return self;
}

- (NSArray *)articleArrayWithDicArray:(NSArray *)array{
    
    NSMutableArray *articleArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        DTArticle *article = [[DTArticle alloc] initWithDictionary:dic];
        [articleArray addObject:article];
    }
    return articleArray;
}

@end
