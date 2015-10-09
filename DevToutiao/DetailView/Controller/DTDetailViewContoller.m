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

@interface DTDetailViewContoller () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

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

- (void)layoutSubViews{
    __weak typeof(self) weakSelf = self;
    self.webView = [[UIWebView alloc] init];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(HeadViewHeight, 0, 0, 0);
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UITapGestureRecognizer *webTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapInWebView:)];
    webTap.delegate = self;
    [self.webView addGestureRecognizer:webTap];
    
    self.headerView = [[ALHeaderView alloc] initHeaderViewWithType:Detail_Header];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeadViewHeight);
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self layoutSubViews];
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *detailArticleUrl = [NSString stringWithFormat:@"%@articles/%@.json",LocalHost,self.articleId];
    [manager GET:detailArticleUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        weakSelf.detailArticle = [[DTDetailArticle alloc] initWithDic:dic];
        NSString *htmlStr = [weakSelf htmlStringWithCss:weakSelf.detailArticle.body css:weakSelf.detailArticle.css[0]];
        [weakSelf.webView loadHTMLString:htmlStr baseURL:nil];
        
        NSURL *imageURL = [NSURL URLWithString:weakSelf.detailArticle.image];
        [weakSelf.headerView.imageView setImageWithURL:imageURL];
        weakSelf.headerView.titleLabel.text = weakSelf.detailArticle.title;
        weakSelf.headerView.detailLabel.text = [NSString stringWithFormat:@"%@ by %@",weakSelf.detailArticle.original_site_name,weakSelf.detailArticle.author];
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

- (void)handleSingleTapInWebView:(UITapGestureRecognizer *)sender{
    CGPoint point =[sender locationInView:self.webView];
    
    NSString *strImgUrl = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).src;",point.x,point.y - HeadViewHeight];
    strImgUrl = [self.webView stringByEvaluatingJavaScriptFromString:strImgUrl];
    if (![strImgUrl isEqualToString:@""]){
        NSLog(@"get origin image url : %@",strImgUrl);
    }
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

#pragma mark - Gesture delegate
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

@end
