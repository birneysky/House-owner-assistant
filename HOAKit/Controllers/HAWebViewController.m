//
//  HAWebViewController.m
//  HOAKit
//
//  Created by birneysky on 16/9/22.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAWebViewController.h"

@interface HAWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL* url = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.linkTitle;
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
