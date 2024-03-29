//
//  DTHomeContainerController.m
//  DevToutiao
//
//  Created by alezai on 15/10/11.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTHomeContainerController.h"
#import "DTMacro.h"
#import "DTHomeTableViewController.h"
#import "DTPromotionViewController.h"
#import "DTDetailViewContoller.h"

@interface DTHomeContainerController () <DTHomeTableViewDelegate, DTPromotionDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionHeightConstraint;
@property (strong, nonatomic) DTHomeTableViewController *tableVC;
@property (strong, nonatomic) DTPromotionViewController *promotionVC;
@property (assign, nonatomic) CGFloat promotionHeight;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation DTHomeContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"tableview_embed"]) {
        self.tableVC = (DTHomeTableViewController *)[segue destinationViewController];
        self.tableVC.delegate = self;
        self.promotionHeight = [[UIScreen mainScreen] bounds].size.height * 2/5;
        self.promotionHeightConstraint.constant = self.promotionHeight;
        self.tableVC.tableView.contentInset = UIEdgeInsetsMake(self.promotionHeight - 20, 0, 0, 0);
    }else if ([segue.identifier isEqualToString:@"promotionview_embed"]){
        self.promotionVC = (DTPromotionViewController *)[segue destinationViewController];
        self.promotionVC.delegate = self;
    }
}

#pragma mark - DTTable view delegate
- (void)dtTableViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.isDragging || scrollView.isDecelerating) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat delta = offsetY + self.promotionHeight;
        CGFloat height = self.promotionHeight - delta;
        
        if (height < 0) {
            height = 0;
        }
        
        self.promotionHeightConstraint.constant = height;
        self.promotionVC.scrollView.contentSize = CGSizeMake(self.promotionVC.scrollView.contentSize.width, height);
        
        CGFloat alpha = delta / (self.promotionHeight - NavigationHeight);
        if (alpha >= 1) {
            alpha = 0.99;
        }
    }
}

#pragma mark - DTPromotion delegate

- (UIPageControl *)promotionPageControl{
    return self.pageControl;
}

@end
