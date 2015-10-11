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
#import "DTDetailHeaderView.h"

#import <AFNetworking.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>

@interface DTDetailViewContoller () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) DTDetailArticle *detailArticle;
@property (weak, nonatomic) IBOutlet DTDetailHeaderView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewConstraint;
@property (assign, nonatomic) CGFloat headerViewHeight;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *htmlString;

@end

@implementation DTDetailViewContoller

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.headerViewHeight = self.headerViewConstraint.constant;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerViewHeight - 20, 0, 0, 0);
    self.webView.scrollView.delegate = self;
    
    UITapGestureRecognizer *webTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapInWebView:)];
    webTap.delegate = self;
    [self.webView addGestureRecognizer:webTap];
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *detailArticleUrl = [NSString stringWithFormat:@"%@articles/%@.json",LocalHost,self.articleId];
    [manager GET:detailArticleUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        weakSelf.detailArticle = [[DTDetailArticle alloc] initWithDic:dic];
        NSString *htmlStr = [weakSelf htmlStringWithCss:weakSelf.detailArticle.body css:weakSelf.detailArticle.css[0]];
        [weakSelf.webView loadHTMLString:htmlStr baseURL:nil];
        
        NSURL *imageURL = [NSURL URLWithString:weakSelf.detailArticle.image];
        [weakSelf.headerView.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder image"]];
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
    
    NSString *strImgUrl = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).src;",point.x,point.y - self.headerViewHeight];
    strImgUrl = [self.webView stringByEvaluatingJavaScriptFromString:strImgUrl];
    if (![strImgUrl isEqualToString:@""]){
        NSLog(@"get origin image url : %@",strImgUrl);
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.isDragging || scrollView.isDecelerating) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat delta = offsetY + self.headerViewHeight;
        CGFloat height = self.headerViewHeight - delta;
        
        if (height <= 0) {
            height = 0;
        }
        
        self.headerViewConstraint.constant = height;
        
        CGFloat alpha = delta / (self.headerViewHeight - NavigationHeight);
        if (alpha >= 1) {
            alpha = 0.99;
        }
    }
}

#pragma mark - Gesture delegate
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

@end
