//
//  ALHeaderView.h
//  MyTest
//
//  Created by alezai on 15/9/28.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HeaderType){
    Page_Header = 0,
    Detail_Header
};

@interface ALHeaderView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

- (instancetype)initHeaderViewWithType:(HeaderType)type;

@end
