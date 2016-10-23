//
//  detailBrowserViewController.h
//  KJH-2016150058
//
//  Created by 김티버 on 2016. 10. 23..
//  Copyright © 2016년 김티버. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailBrowserViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navHead;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *s1;
@property (strong, nonatomic) NSString *s2;

- (IBAction)closebtn:(UIButton *)sender;
@end
