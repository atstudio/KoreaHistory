//
//  menu02ViewController.h
//  KJH-2016150058
//
//  Created by 김티버 on 2016. 10. 22..
//  Copyright © 2016년 김티버. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menu02ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *gameStartView;
@property (strong, nonatomic) IBOutlet UIView *gameMainView;
@property (strong, nonatomic) IBOutlet UIView *gameOverView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextbox;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *correctCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainChanceLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtonSet;


@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) IBOutlet UILabel *resultGuideLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastScoreLabel;




- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (IBAction)gameStart;

- (IBAction)answerButtonClick:(UIButton *)sender;

@end
