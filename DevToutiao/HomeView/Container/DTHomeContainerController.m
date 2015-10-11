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
        self.promotionHeight = self.promotionHeightConstraint.constant;
        self.tableVC.tableView.contentInset = UIEdgeInsetsMake(self.promotionHeight, 0, 0, 0);
    }else if ([segue.identifier isEqualToString:@"promotionview_embed"]){
        self.promotionVC = (DTPromotionViewController *)[segue destinationViewController];
        self.promotionVC.delegate = self;
    }
}

#pragma mark - DTTable view delegate
- (void)dtTableViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY + self.promotionHeight;
    CGFloat height = self.promotionHeight - delta;
    
    if (height < 0) {
        height = 0;
    }
    
    self.promotionHeightConstraint.constant = height;
    self.promotionVC.scrollView.contentSize = CGSizeMake(self.promotionVC.scrollView.contentSize.width, height);
    
    CGFloat alpha = delta / (HeadViewHeight - NavigationHeight);
    if (alpha >= 1) {
        alpha = 0.99;
    }
}

#pragma mark - DTPromotion delegate
- (void)promotionViewDidTaped:(id)promotionId{
    DTDetailViewContoller *detailVC = [[DTDetailViewContoller alloc] initWithID:promotionId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UIPageControl *)promotionPageControl{
    return self.pageControl;
}

@end
