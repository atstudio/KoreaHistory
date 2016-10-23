//
//  menu02ViewController.m
//  KJH-2016150058
//
//  Created by 김티버 on 2016. 10. 22..
//  Copyright © 2016년 김티버. All rights reserved.
//

#import "menu02ViewController.h"

@interface menu02ViewController ()

@end

@implementation menu02ViewController {
    int remain_cnt;
    int correct_cnt;
    int answer_code;
    NSMutableString *parsedData;
    NSMutableArray *quiz_data;
    NSMutableArray *json_data;
}

@synthesize gameStartView, gameMainView, gameOverView, nameTextbox, nameLabel, questionLabel, correctCountLabel, remainChanceLabel, answerButtonSet, resultGuideLabel, lastScoreLabel;

- (void)updateGameTitle:(NSString *)title {
    questionLabel.text = title;
}

- (void)updateGameStatusCorrect:(int)correct Remain:(int)remain {
    correct_cnt = correct;
    remain_cnt = remain;
    answer_code = 0;
    
    correctCountLabel.text = [NSString stringWithFormat:@"맞춘 갯수 : %d", correct_cnt];
    remainChanceLabel.text = [NSString stringWithFormat:@"남은 기회 : %d", remain_cnt];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameLabel.text = @"";
    [self updateGameStatusCorrect:0 Remain:3];

    gameMainView.hidden = YES;
    gameOverView.hidden = YES;
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmCancel)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)confirmCancel {
    if (gameMainView.hidden == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"나가기 경고" message:@"지금 종료하면 모든 진행상황을 잃게됩니다! 그래도 퀴즈를 관두시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"네", nil];
    
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void) getJsonData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [json_data removeAllObjects];
    parsedData = [NSMutableString stringWithString:@""];
    
    NSString *url = @"http://14.63.213.214/history_api.php/quiz";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error = nil;
    
    id tmp = [NSJSONSerialization JSONObjectWithData:[parsedData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    answer_code = (int)[[tmp valueForKey:@"right_code"] integerValue];
    quiz_data = [tmp valueForKey:@"quiz_data"];
    [self updateGameTitle:[tmp valueForKey:@"quiz_hint"]];
    
    int answer_cnt = (int)[quiz_data count];
    /*
    if (answer_cnt != 4) {
        for(int i=answer_cnt; i<4; i++) {
            [[answerButtonSet objectAtIndex:i] setHidden:YES];
        }
    } else {
        for (int i=0; i<4; i++) {
            [[answerButtonSet objectAtIndex:i] setHidden:NO];
        }
    }
    */
            
    for (int i=0; i<answer_cnt; i++) {
        [[answerButtonSet objectAtIndex:i] setEnabled:YES];
        [[answerButtonSet objectAtIndex:i] setTitle:[quiz_data objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data {
    NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [parsedData appendString:strReturn];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error {
    NSLog(@"%@", [error debugDescription]);
    NSLog(@"%@", [error localizedDescription]);
}

- (void)game_init {
    [quiz_data removeAllObjects];
    for(int i=0; i<4; i++) {
        [[answerButtonSet objectAtIndex:i] setEnabled:NO];
    }
    [self getJsonData];
}

- (IBAction)gameStart {
    NSString *name = [NSString stringWithString:nameTextbox.text];
    if (![name isEqual: @""]) {
        [nameTextbox resignFirstResponder];
        gameStartView.hidden = YES;
        gameMainView.hidden = NO;
        nameLabel.text = [NSString stringWithFormat:@"%@님의 도전!", name];
        [self game_init];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"이름을 입력해주세요!" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (IBAction)answerButtonClick:(UIButton *)sender {
    if (sender.tag == answer_code) {
        correct_cnt++;
    } else {
        remain_cnt--;
    }
    
    if (remain_cnt <= 0) {
        gameMainView.hidden = YES;
        NSString *guideText = @"";
        
        if (correct_cnt <= 5) {
            guideText = @"더 열심히 공부하셔야겠네요!";
        } else if (correct_cnt > 5 && correct_cnt <= 10) {
            guideText = @"어느정도 지식은 있습니다. 분발하세요";
        } else if (correct_cnt > 10 && correct_cnt <= 15) {
            guideText = @"훌륭합니다. 많은 것을 알고있네요.";
        } else {
            guideText = @"와우! 당신이야말로 걸어다니는 역사책! 대단합니다!";
        }
        resultGuideLabel.text = guideText;
        lastScoreLabel.text = [NSString stringWithFormat:@"%@님의 점수 : %d점", nameTextbox.text, correct_cnt];
        
        gameOverView.hidden = NO;
    } else {
        [self updateGameStatusCorrect:correct_cnt Remain:remain_cnt];
        [self game_init];
    }
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
