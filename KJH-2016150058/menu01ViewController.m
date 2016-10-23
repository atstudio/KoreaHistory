//
//  menu01ViewController.m
//  KJH-2016150058
//
//  Created by 김티버 on 2016. 10. 22..
//  Copyright © 2016년 김티버. All rights reserved.
//

#import "menu01ViewController.h"
#import "detailBrowserViewController.h"

@interface menu01ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@end

@implementation menu01ViewController {
    int f_p, n_p;
    NSMutableString *parsedData;
}

@synthesize picker, _tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    f_p = 0;
    n_p = 0;
    
    data1 = [[NSArray alloc] initWithObjects:@"전체", @"인물", @"사건", @"조직단체", @"유물유적", nil];
    data2= [[NSArray alloc] initWithObjects:@"ㄱ", @"ㄴ~ㄷ", @"ㄹ~ㅂ", @"ㅅ", @"ㅇ", @"ㅈ", @"ㅊ", @"ㅋ~ㅎ", @"1~0", nil];
    
    [self getJsonData_param1:0 param2:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getJsonData_param1:(int)param1 param2:(int)param2 {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [json_data removeAllObjects];
    parsedData = [NSMutableString stringWithString:@""];
    
    NSString *url = [NSString stringWithFormat:@"http://14.63.213.214/history_api.php/list/%d/%d", param1, param2];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //[NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error = nil;
    
    id tmp = [NSJSONSerialization JSONObjectWithData:[parsedData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    json_data = [[NSMutableArray alloc] initWithArray:(NSMutableArray *) tmp];
    
    [_tableView reloadData];
     
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

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [data1 count];
    } else {
        return [data2 count];
    }
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [data1 objectAtIndex:row];
    } else {
        return [data2 objectAtIndex:row];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int firstPick = (int)[self.picker selectedRowInComponent:0];
    int secondPick = (int)[self.picker selectedRowInComponent:1];
    
    if (f_p != firstPick || n_p != secondPick) {
        [self getJsonData_param1:firstPick param2:secondPick];
        f_p = firstPick;
        n_p = secondPick;
    }
    
    //NSLog(@"%ld %ld", , [self.picker selectedRowInComponent:1]);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [json_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //cell.textLabel.text = @"a";
    cell.textLabel.text = [[json_data objectAtIndex:indexPath.row] objectForKey:@"subject"];
    cell.detailTextLabel.text = [[json_data objectAtIndex:indexPath.row] objectForKey:@"description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%@", [[json_data objectAtIndex:indexPath.row] objectForKey:@"subject"]);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    detailBrowserViewController *vc = [segue destinationViewController];
    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    
    vc.s1 = [[json_data objectAtIndex:indexPath.row] objectForKey:@"subject"];
    vc.s2 = [[json_data objectAtIndex:indexPath.row] objectForKey:@"su_code"];
}

@end
