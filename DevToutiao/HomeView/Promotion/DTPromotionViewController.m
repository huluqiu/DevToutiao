//
//  DTPromotionViewController.m
//  DevToutiao
//
//  Created by alezai on 15/10/11.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTPromotionViewController.h"
#import "ALHeaderView.h"
#import "DTMacro.h"
#import "DTPromotion.h"

#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <Masonry.h>

@interface DTPromotionViewController ()
@property (strong, nonatomic) NSMutableArray *promotionArray;
@property (strong, nonatomic) NSMutableArray *pageViewArray;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *scrollTimer;

@end

@implementation DTPromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.promotionArray = [NSMutableArray new];
    self.pageViewArray = [NSMutableArray new];
    if ([self.delegate respondsToSelector:@selector(pageControl)]) {
        self.pageControl = [self.delegate promotionPageControl];
    }

    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *promotionUrl = [NSString stringWithFormat:@"%@promotion/banner.json",LocalHost];
    [manager GET:promotionUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *dicArray = responseObject[@"data"];
        for (NSDictionary *dic in dicArray) {
            DTPromotion *promotion = [[DTPromotion alloc] initWithDictionary:dic];
            [weakSelf.promotionArray addObject:promotion];
            [weakSelf.pageViewArray addObject:[NSNull null]];
        }
        [weakSelf.pageViewArray addObject:[NSNull null]];
        [weakSelf.pageViewArray addObject:[NSNull null]];
        [weakSelf reloadPromotion];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadPromotion{
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * (self.promotionArray.count + 2), CGRectGetHeight(self.scrollView.frame));
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)];
    self.pageControl.numberOfPages = self.promotionArray.count;
    self.pageControl.currentPage = 0;
    for (NSInteger i = -1; ABS(i) <= self.promotionArray.count; i ++) {
        [self loadPromotionViewWithPage:i];
    }
    
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollPromotion:) userInfo:nil repeats:YES];
}


- (void)loadPromotionViewWithPage:(NSInteger)page{
    if (ABS(page) > self.promotionArray.count)
        return;
    __weak typeof(self) weakSelf = self;
    NSInteger mPage = (page + 3) % 3;
    ALHeaderView *pageView = self.pageViewArray[page + 1];
    if ((NSNull *)pageView == [NSNull null]) {
        pageView = [[ALHeaderView alloc] initHeaderViewWithType:Page_Header];
        [self.pageViewArray replaceObjectAtIndex:(page +1) withObject:pageView];
        
        CGRect frame = self.scrollView.frame;
        [self.scrollView addSubview:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scrollView);
            make.height.equalTo(weakSelf.scrollView.mas_height);
            make.width.equalTo(weakSelf.scrollView.mas_width);
            make.left.mas_equalTo((page + 1) * CGRectGetWidth(frame));
        }];
        
        DTPromotion *promotion = self.promotionArray[mPage];
        [pageView.imageView setImageWithURL:[NSURL URLWithString:promotion.image]];
        pageView.titleLabel.text = promotion.title;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promotionViewTap:)];
        [pageView addGestureRecognizer:tapGesture];
    }
}

- (void)promotionViewTap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(promotionViewDidTaped:)]) {
            DTPromotion *promotion = self.promotionArray[self.pageControl.currentPage];
            [self.delegate promotionViewDidTaped:promotion.promotionId];
        }
    }
}

- (void)scrollPromotion:(NSTimer *)timer{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = self.scrollView.contentOffset.x / pageWidth + 1;
    [self.scrollView scrollRectToVisible:CGRectMake(page * pageWidth, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)) animated:YES];
}

- (void)updatePageControlWithPage:(NSUInteger)page{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    self.pageControl.currentPage = (page - 1) % 4;
    
    if(page == 0){
        [self.scrollView scrollRectToVisible:CGRectMake(pageWidth * (self.pageViewArray.count - 2), 0, pageWidth, CGRectGetHeight(self.scrollView.frame)) animated:NO];
        self.pageControl.currentPage = self.promotionArray.count - 1;
    }else if (page == (self.pageViewArray.count - 1)){
        [self.scrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)) animated:NO];
        self.pageControl.currentPage = 0;
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = self.scrollView.contentOffset.x / pageWidth;
    [self updatePageControlWithPage:page];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = self.scrollView.contentOffset.x / pageWidth;
    [self updatePageControlWithPage:page];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
