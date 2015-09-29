//
//  DTDetailViewContoller.m
//  DevToutiao
//
//  Created by alezai on 15/9/28.
//  Copyright © 2015年 alezai. All rights reserved.
//

#import "DTDetailViewContoller.h"
#import "DTDetailArticle.h"
#import "DTMacro.h"
#import "ALHeaderView.h"

#import <AFNetworking.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>

@interface DTDetailViewContoller () <UIScrollViewDelegate>

@property (assign) id articleId;
@property (strong, nonatomic) DTDetailArticle *detailArticle;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) ALHeaderView *headerView;
@property (copy, nonatomic) NSString *htmlString;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorLabel;

@end

@implementation DTDetailViewContoller

- (instancetype)initWithID:(id)articleId{
    if (self = [super init]) {
        _articleId = articleId;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.webView = [[UIWebView alloc] init];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(HeadViewHeight, 0, 0, 0);
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.headerView = [ALHeaderView new];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeadViewHeight);
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
    
    self.titleLabel = [UILabel new];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerView).with.offset(20);
        make.right.equalTo(weakSelf.headerView).with.offset(-40);
        make.bottom.equalTo(weakSelf.headerView).with.offset(-20);
    }];
    
    self.authorLabel = [UILabel new];
    self.authorLabel.font = [UIFont boldSystemFontOfSize:10];
    self.authorLabel.textAlignment = NSTextAlignmentRight;
    [self.headerView addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(5);
        make.right.equalTo(weakSelf.headerView).with.offset(-20);
        make.bottom.equalTo(weakSelf.headerView).with.offset(-5);
    }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *detailArticleUrl = [NSString stringWithFormat:@"%@articles/%@.json",LocalHost,self.articleId];
    [manager GET:detailArticleUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        weakSelf.detailArticle = [[DTDetailArticle alloc] initWithDic:dic];
        NSString *htmlStr = [weakSelf htmlStringWithCss:weakSelf.detailArticle.body css:weakSelf.detailArticle.css[0]];
        [weakSelf.webView loadHTMLString:htmlStr baseURL:nil];
        
        NSURL *imageURL = [NSURL URLWithString:weakSelf.detailArticle.image];
        [weakSelf.imageView setImageWithURL:imageURL];
        weakSelf.titleLabel.text = weakSelf.detailArticle.title;
        weakSelf.authorLabel.text = [NSString stringWithFormat:@"%@ by %@",weakSelf.detailArticle.original_site_name,weakSelf.detailArticle.author];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
}

- (NSString *)htmlStringWithCss:(NSString *)html css:(NSString *)css{
    NSString *str;
    NSString *headCssStr = [NSString stringWithFormat:@"<head>\n\t<link rel = \"stylesheet\" href=\"%@\" />\n</head>\n",css];
    str = [headCssStr stringByAppendingString:html];
    return str;
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY + HeadViewHeight;
    CGFloat height = HeadViewHeight - delta;
    
    if (height <= 0) {
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
}

@end
