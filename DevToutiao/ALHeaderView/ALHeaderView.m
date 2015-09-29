//
//  ALHeaderView.m
//  MyTest
//
//  Created by alezai on 15/9/28.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "ALHeaderView.h"

@implementation ALHeaderView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    } else {
        return result;
    }
}


@end
