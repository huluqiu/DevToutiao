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

#import <AFNetworking.h>
#import <Masonry.h>

@interface DTDetailViewContoller ()

@property (strong, nonatomic) DTDetailArticle *detailArticle;
@property (strong, nonatomic) UIWebView *webView;
@property (copy, nonatomic) NSString *htmlString;

@end

@implementation DTDetailViewContoller

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationItem.hidesBackButton = YES;
    
    __weak typeof(self) weakSelf = self;
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *detailArticleUrl = [NSString stringWithFormat:@"%@articles/%@.json",LocalHost,self.articleId];
    [manager GET:detailArticleUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        weakSelf.detailArticle = [[DTDetailArticle alloc] initWithDic:dic];
        NSString *htmlStr = [weakSelf htmlStringWithCss:weakSelf.detailArticle.body css:weakSelf.detailArticle.css[0]];
        [weakSelf.webView loadHTMLString:htmlStr baseURL:nil];
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

@end
