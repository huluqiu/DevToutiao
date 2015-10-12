//
//  DTHomeTableViewController.h
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTHomeTableViewDelegate <NSObject>

- (void)dtTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface DTHomeTableViewController : UITableViewController

@property (weak, nonatomic) id<DTHomeTableViewDelegate>delegate;

@end
