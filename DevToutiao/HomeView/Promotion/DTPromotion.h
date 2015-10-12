//
//  DTPromotion.h
//  DevToutiao
//
//  Created by alezai on 15/9/29.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTPromotion : NSObject

@property (assign, nonatomic) id promotionId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *image;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
