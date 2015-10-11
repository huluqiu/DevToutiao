//
//  DTPromotionViewController.h
//  DevToutiao
//
//  Created by alezai on 15/10/11.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTPromotionDelegate <NSObject>

- (UIPageControl *)promotionPageControl;

@end

@interface DTPromotionViewController : UIViewController

@property (weak, nonatomic) id<DTPromotionDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
