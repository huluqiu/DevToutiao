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

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>

@interface DTHomeTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dailiesArray;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) ALHeaderView *headerView;
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DTHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    self.headerView = [ALHeaderView new];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeadViewHeight + statusBarFrame.size.height);
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationView = [UIView new];
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NavigationHeight);
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.headerView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.dailiesArray = [NSMutableArray new];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString *promotionUrl = [NSString stringWithFormat:@"%@promotion/banner.json",LocalHost];
        [manager GET:promotionUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSArray *dicArray = responseObject[@"data"];
            NSDictionary *dic = dicArray[0];
            NSURL *url = [NSURL URLWithString:dic[@"image"]];
            [weakSelf.imageView setImageWithURL:url];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"error: %@",error);
        }];
        
        NSString *dailiesUrlString = [NSString stringWithFormat:@"%@dailies/latest.json",LocalHost];
        [manager GET:dailiesUrlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = responseObject[@"data"];
            DTDailies *dailies = [[DTDailies alloc] initWithDictionary:dic];
            [weakSelf.dailiesArray addObject:dailies];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.header endRefreshing];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"error: %@",error);
        }];
    }];
    [self.tableView.header beginRefreshing];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY + HeadViewHeight;
    CGFloat height = HeadViewHeight - delta;
    
    if (height < 0) {
        height = 0;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    CGFloat alpha = delta / (HeadViewHeight - NavigationHeight);
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:alpha];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
