//
//  DatePickerView.m
//  AlertControllerDemo
//
//  Created by Chen Yiliang on 5/10/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "DatePickerView.h"

#define DATA_PICKER_VIEW_MIN_DATE_TIME_INTERVEL     20 // unit: year
#define DATE_PICKER_VIEW_MAX_DATE_TIME_INTERVEL     20 // unit: year

@interface DatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDateComponents *selectedDateComponents;
@property (nonatomic, assign) DatePickerViewMode mode;

@property (nonatomic, strong) NSDateComponents *minimumDateComponents;
@property (nonatomic, strong) NSDateComponents *maximumDateComponents;

@end

@implementation DatePickerView

+ (instancetype)datePickerViewWithMode:(DatePickerViewMode)mode selectedDate:(NSDate *)selectedDate completion:(void (^)(NSDate *))completion {
    DatePickerView *pickerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    pickerView.mode = mode;
    pickerView.completion = completion;
    if (mode == DatePickerViewModeYearAndMonth) {
        pickerView.datePicker.hidden = YES;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        dateComponents.year -= DATA_PICKER_VIEW_MIN_DATE_TIME_INTERVEL;
        pickerView.minimumDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        dateComponents.year += DATA_PICKER_VIEW_MIN_DATE_TIME_INTERVEL + DATE_PICKER_VIEW_MAX_DATE_TIME_INTERVEL;
        pickerView.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        pickerView.selectedDate = selectedDate ?: [NSDate date];
    } else {
        pickerView.pickerView.hidden = YES;
        pickerView.datePicker.datePickerMode = (UIDatePickerMode)mode;
        pickerView.datePicker.date = selectedDate ?: [NSDate date];
    }
    
    return pickerView;
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    
    if (selectedDate != nil) {
        self.selectedDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:selectedDate];
        
        if (self.mode == DatePickerViewModeYearAndMonth) {
            [self.pickerView selectRow:self.selectedDateComponents.year - self.minimumDateComponents.year inComponent:0 animated:YES];
            [self.pickerView selectRow:self.selectedDateComponents.month - 1 inComponent:1 animated:YES];
        }
    } else {
        self.selectedDateComponents = nil;
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    
    self.datePicker.minimumDate = minimumDate;
    if (minimumDate != nil) {
        self.minimumDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:minimumDate];
    } else {
        self.minimumDateComponents = nil;
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    
    self.datePicker.maximumDate = maximumDate;
    if (maximumDate != nil) {
        self.maximumDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:maximumDate];
    } else {
        self.maximumDateComponents = nil;
    }
}

- (IBAction)okButtonPressed:(id)sender {
    [super okButtonPressed:sender];
    
    if (self.completion != nil) {
        NSDate *selectedDate = nil;
        if (self.mode == DatePickerViewModeYearAndMonth) {
            selectedDate = [[NSCalendar currentCalendar] dateFromComponents:self.selectedDateComponents];
        } else {
            selectedDate = self.datePicker.date;
        }
        self.completion(selectedDate);
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [super cancelButtonPressed:sender];
    
    if (self.completion != nil) {
        self.completion(nil);
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.mode == DatePickerViewModeYearAndMonth) {
        return 2;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.mode == DatePickerViewModeYearAndMonth) {
        if (component == 0) {
            return self.maximumDateComponents.year - self.minimumDateComponents.year + 1;
        } else {
            return 12;
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.mode == DatePickerViewModeYearAndMonth) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%d", self.minimumDateComponents.year + row];
        } else {
            return [NSString stringWithFormat:@"%02d", row + 1];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.mode == DatePickerViewModeYearAndMonth) {
        if (component == 0) {
            self.selectedDateComponents.year = self.minimumDateComponents.year + row;
        } else {
            self.selectedDateComponents.month = row + 1;
        }
    }
}

@end
