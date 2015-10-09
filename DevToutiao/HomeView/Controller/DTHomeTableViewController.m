//
//  DTHomeTableViewController.m
//  DevToutiao
//
//  Created by alezai on 15/9/26.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTHomeTableViewController.h"
#import "DTDailies.h"
#import "DTMacro.h"
#import "DTArticleCell.h"
#import "DTDetailViewContoller.h"
#import "ALHeaderView.h"
#import "DTPromotion.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>
#import <UIWebView+AFNetworking.h>

@interface DTHomeTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *dailiesArray;
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *promotionArray;
@property (strong, nonatomic) NSMutableArray *pageViewArray;
@property (strong, nonatomic) UIScrollView *promotionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *scrollTimer;

@end

@implementation DTHomeTableViewController

- (void)layoutSubViews{
    __weak typeof(self) weakSelf = self;
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    self.tableView = [UITableView new];
    self.tableView.contentInset = UIEdgeInsetsMake(HeadViewHeight + statusBarFrame.size.height, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.promotionView = [UIScrollView new];
    self.promotionView.pagingEnabled = YES;
    self.promotionView.bounces = NO;
    self.promotionView.showsVerticalScrollIndicator = NO;
    self.promotionView.showsHorizontalScrollIndicator = NO;
    self.promotionView.delegate = self;
    [self.view addSubview:self.promotionView];
    [self.promotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeadViewHeight + statusBarFrame.size.height);
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    self.pageControl = [UIPageControl new];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.promotionView.mas_bottom).with.offset(0);
    }];

    self.navigationView = [UIView new];
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NavigationHeight);
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"今日头条";
    [self.navigationView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.navigationView);
        make.bottom.equalTo(weakSelf.navigationView).with.offset(-10);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self layoutSubViews];
    
    __weak typeof(self) weakSelf = self;
    self.dailiesArray = [NSMutableArray new];
    self.promotionArray = [NSMutableArray new];
    self.pageViewArray = [NSMutableArray new];
    
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
    
    NSString *dailiesUrlString = [NSString stringWithFormat:@"%@dailies/latest.json",LocalHost];
    [manager GET:dailiesUrlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        DTDailies *dailies = [[DTDailies alloc] initWithDictionary:dic];
        [weakSelf.dailiesArray addObject:dailies];
        [weakSelf.tableView reloadData];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error);
    }];
    
    __block int dailiesNumber = 0;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        DTDailies *currentDailies = weakSelf.dailiesArray[dailiesNumber];
        NSString *nextDaliesUrlString = [NSString stringWithFormat:@"%@dailies/%@",LocalHost,currentDailies.pre_date];
        NSLog(@"%@",currentDailies.pre_date);
        [manager GET:nextDaliesUrlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = responseObject[@"data"];
            DTDailies *dailies = [[DTDailies alloc] initWithDictionary:dic];
            [weakSelf.dailiesArray addObject:dailies];
            dailiesNumber += 1;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.footer endRefreshing];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"error: %@",error);
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.scrollTimer) {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollPromotion:) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.scrollTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadPromotion{
    self.promotionView.contentSize = CGSizeMake(CGRectGetWidth(self.promotionView.frame) * (self.promotionArray.count + 2), CGRectGetHeight(self.promotionView.frame));
    [self.promotionView setContentOffset:CGPointMake(CGRectGetWidth(self.promotionView.frame), 0)];
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
        
        CGRect frame = self.promotionView.frame;
        [self.promotionView addSubview:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.promotionView);
            make.height.equalTo(weakSelf.promotionView.mas_height);
            make.width.equalTo(weakSelf.promotionView.mas_width);
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
        DTPromotion *promotion = self.promotionArray[self.pageControl.currentPage];
        DTDetailViewContoller *detailVC = [[DTDetailViewContoller alloc] initWithID:promotion.promotionId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollPromotion:(NSTimer *)timer{
    CGFloat pageWidth = CGRectGetWidth(self.promotionView.frame);
    NSUInteger page = self.promotionView.contentOffset.x / pageWidth + 1;
    [self.promotionView scrollRectToVisible:CGRectMake(page * pageWidth, 0, pageWidth, CGRectGetHeight(self.promotionView.frame)) animated:YES];
}

- (void)updatePageControlWithPage:(NSUInteger)page{
    CGFloat pageWidth = CGRectGetWidth(self.promotionView.frame);
    self.pageControl.currentPage = (page - 1) % 4;
    
    if(page == 0){
        [self.promotionView scrollRectToVisible:CGRectMake(pageWidth * (self.pageViewArray.count - 2), 0, pageWidth, CGRectGetHeight(self.promotionView.frame)) animated:NO];
        self.pageControl.currentPage = self.promotionArray.count - 1;
    }else if (page == (self.pageViewArray.count - 1)){
        [self.promotionView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, CGRectGetHeight(self.promotionView.frame)) animated:NO];
        self.pageControl.currentPage = 0;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dailiesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DTDailies *dailies = self.dailiesArray[section];
    return dailies.articleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DTArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    DTDailies *dailies = self.dailiesArray[indexPath.section];
    [cell setCellContentWithArticle:dailies.articleArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DTDailies *dailies = self.dailiesArray[indexPath.section];
    DTArticle *article = dailies.articleArray[indexPath.row];
    DTDetailViewContoller *detailVC = [[DTDetailViewContoller alloc] initWithID:article.articleID];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat delta = offsetY + HeadViewHeight;
        CGFloat height = HeadViewHeight - delta;
        
        if (height < 0) {
            height = 0;
        }
        
        __weak typeof(self) weakSelf = self;
        [self.promotionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.top.equalTo(weakSelf.view);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
        }];
        self.promotionView.contentSize = CGSizeMake(self.promotionView.contentSize.width, height);
        
        CGFloat alpha = delta / (HeadViewHeight - NavigationHeight);
        if (alpha >= 1) {
            alpha = 0.99;
        }
        
        self.navigationView.backgroundColor = [UIColor colorWithRed:88.000/252.000 green:171.000/252.000 blue:1 alpha:alpha];
    }else if (scrollView == self.promotionView){
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        return;
    }else if (scrollView == self.promotionView){
        CGFloat pageWidth = CGRectGetWidth(self.promotionView.frame);
        NSUInteger page = self.promotionView.contentOffset.x / pageWidth;
        [self updatePageControlWithPage:page];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.promotionView.frame);
    NSUInteger page = self.promotionView.contentOffset.x / pageWidth;
    [self updatePageControlWithPage:page];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
