//
//  detailBrowserViewController.m
//  KJH-2016150058
//
//  Created by 김티버 on 2016. 10. 23..
//  Copyright © 2016년 김티버. All rights reserved.
//

#import "detailBrowserViewController.h"

@interface detailBrowserViewController ()

@end

@implementation detailBrowserViewController

@synthesize navHead, webView, s1, s2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = s1;
    self.navHead.topItem.title = s1;
    
    NSString *url_str = [[NSString stringWithFormat:@"http://.../history_api.php/detail/%@/%@", s1, s2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 클라우드 서버 폐쇄로 주소 blind
    NSURL *url = [NSURL URLWithString:url_str];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    [webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (IBAction)closebtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
