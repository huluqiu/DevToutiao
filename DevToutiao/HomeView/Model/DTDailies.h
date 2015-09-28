//
//  DTDailies.h
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTDailies : NSObject

@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *pre_date;
@property (copy, nonatomic) NSString *next_date;
@property (assign, getter=isToday) BOOL today;
@property (strong, nonatomic) NSArray *articleArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
