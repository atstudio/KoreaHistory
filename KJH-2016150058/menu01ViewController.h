//
//  menu01ViewController.h
//  KJH-2016150058
//
//  Created by 김티버 on 2016. 10. 22..
//  Copyright © 2016년 김티버. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menu01ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource> {
    NSArray *data1;
    NSArray *data2;
    NSMutableArray *json_data;
}

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;

@end
