//
//  DatePickerView.h
//  AlertControllerDemo
//
//  Created by Chen Yiliang on 5/10/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYAlertController.h"

//typedef NS_ENUM(NSInteger, UIDatePickerMode) {
//    UIDatePickerModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
//    UIDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
//    UIDatePickerModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
//    UIDatePickerModeCountDownTimer, // Displays hour and minute (e.g. 1 | 53)
//}

typedef NS_ENUM(NSInteger, DatePickerViewMode) {
    DatePickerViewModeTime,
    DatePickerViewModeDate,
    DatePickerViewModeDateAndTime,
    DatePickerViewModeYearAndMonth = 4,
};

@interface DatePickerView : CYAlertCustomView

+ (instancetype)datePickerViewWithMode:(DatePickerViewMode)mode selectedDate:(NSDate *)selectedDate completion:(void (^)(NSDate *date))completion;

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, strong) void (^completion)(NSDate *date);

@end
