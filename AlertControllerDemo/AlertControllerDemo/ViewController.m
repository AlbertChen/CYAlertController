//
//  ViewController.m
//  AlertControllerDemo
//
//  Created by Chen Yiliang on 4/28/17.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "ViewController.h"
#import "CYAlertController.h"
#import "DatePickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)likeSystemButtonPressed:(id)sender {
    CYAlertController *alertController = [CYAlertController alertControllerWithTitle:@"快给我们一个爱的鼓励吧" message:nil];
    // Create the actions.
    CYAlertAction *encourageAction = [CYAlertAction actionWithTitle:@"必须鼓励"  bold:YES handler:^(CYAlertAction *action) {
        NSLog(@"必须鼓励");
    }];
    CYAlertAction *ruthlessAction = [CYAlertAction actionWithTitle:@"残忍拒绝" handler:^(CYAlertAction *action) {
        NSLog(@"残忍拒绝");
    }];
    CYAlertAction *nextRemindAction = [CYAlertAction actionWithTitle:@"下次提醒" handler:^(CYAlertAction *action) {
        NSLog(@"下次提醒");
    }];
    [alertController addAction:encourageAction];
    [alertController addAction:ruthlessAction];
    [alertController addAction:nextRemindAction];
    [alertController presentFromViewController:self animated:YES completion:nil];
}

- (IBAction)custemAlertButtonPressed:(id)sender {
    DatePickerView *pickerView = [DatePickerView datePickerViewWithMode:DatePickerViewModeYearAndMonth selectedDate:nil completion:^(NSDate *date) {
        NSLog(@"select date: %@", date);
    }];
    CGRect frame = pickerView.frame;
    frame.size.width = 260.0;
    pickerView.frame = frame;
    pickerView.layer.cornerRadius = 5.0;
    [pickerView showFromViewController:self preferredStyle:CYAlertControllerStyleCustomAlert animated:YES completion:NULL];
}

- (IBAction)custemActionSheetButtonPressed:(id)sender {
    DatePickerView *pickerView = [DatePickerView datePickerViewWithMode:DatePickerViewModeDate selectedDate:nil completion:^(NSDate *date) {
        NSLog(@"select date: %@", date);
    }];
    [pickerView showFromViewController:self preferredStyle:CYAlertControllerStyleCustomActionSheet animated:YES completion:NULL];
}

@end
