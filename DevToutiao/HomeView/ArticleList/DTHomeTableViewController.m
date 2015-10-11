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

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>

@interface DTHomeTableViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *dailiesArray;

@end

@implementation DTHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.dailiesArray = [NSMutableArray new];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
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
    DTArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"home tableview cell"];
    if (cell == nil) {
        cell = [[DTArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"home tableview cell"];
    }
    DTDailies *dailies = self.dailiesArray[indexPath.section];
    [cell setCellContentWithArticle:dailies.articleArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([self.delegate respondsToSelector:@selector(dtTableViewDidScroll:)]) {
        [self.delegate dtTableViewDidScroll:scrollView];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[DTDetailViewContoller class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DTDailies *dailies = self.dailiesArray[indexPath.section];
        DTArticle *article = dailies.articleArray[indexPath.row];
        DTDetailViewContoller *detailVC = (DTDetailViewContoller *)segue.destinationViewController;
        detailVC.articleId = article.articleID;
    }
}

@end
