//
//  CYAlertController.h
//  Demo
//
//  Created by Chen Yiliang on 3/1/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 CYAlertController *alertController = [CYAlertController alertControllerWithImage:[UIImage imageNamed:@"已勾选"] message:@"Message"];
 CYAlertAction *cancelAction = [CYAlertAction actionWithTitle:@"Cancel" handler:^(CYAlertAction *action) {
 NSLog(@"Cancel button pressed.");
 }];
 CYAlertAction *okAction = [CYAlertAction actionWithTitle:@"OK" handler:^(CYAlertAction *action) {
 NSLog(@"OK button pressed.");
 }];
 [alertController addAction:cancelAction];
 [alertController addAction:okAction];
 [alertController presentFromViewController:self animated:YES completion:NULL];
 */

typedef NS_ENUM(NSInteger, CYAlertControllerStyle) {
    CYAlertControllerStyleAlert = 0,
    CYAlertControllerStyleCustomAlert,
    CYAlertControllerStyleCustomActionSheet
};

@class CYAlertController;

@interface CYAlertCustomView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) CGFloat offsetCenterY;
@property (nonatomic, weak, readonly) CYAlertController *alertController;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okButtonPressed:(id)sender;

- (CYAlertController *)showFromViewController:(UIViewController *)viewController
                               preferredStyle:(CYAlertControllerStyle)preferredStyle
                                     animated:(BOOL)animated
                                   completion:(void (^)(void))completion;
- (CYAlertController *)showFromViewController:(UIViewController *)viewController
                               preferredStyle:(CYAlertControllerStyle)preferredStyle
                                     animated:(BOOL)animated
                                    maskColor:(UIColor *)maskColor
                                   completion:(void (^)(void))completion;
- (void)hide:(BOOL)animated;

@end

@interface CYAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CYAlertAction *action))handler;
+ (instancetype)actionWithTitle:(NSString *)title bold:(BOOL)bold handler:(void (^)(CYAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;

@end

@interface CYAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)alertControllerWithImage:(UIImage *)image message:(NSString *)message;
+ (instancetype)alertControllerWithCustomView:(CYAlertCustomView *)customView preferredStyle:(CYAlertControllerStyle)preferredStyle; // preferredStyle = CYAlertControllerStyleCustomAlert or CYAlertControllerStyleCustomActionSheet

- (void)addAction:(CYAlertAction *)action;
@property (nonatomic, readonly) NSArray<CYAlertAction *> *actions;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) CGFloat offsetCenterY; // Work only when style is CYAlertControllerStyleCustomAlert

@property (nonatomic, readonly) BOOL animated;
@property (nonatomic, readonly) CYAlertControllerStyle preferredStyle;

- (void)presentFromViewController:(UIViewController *)fromController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss:(BOOL)animated;

@end
