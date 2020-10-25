//
//  CYAlertController.m
//  CYAlertController
//
//  Created by Chen Yiliang on 3/1/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYAlertController.h"

#define CYAlertViewWidth                270.0f
#define CYAlertViewLeftPadding          8.0f
#define CYAlertViewCornerRadius         10.0
#define CYAlertViewTextFontSize         15.0f
#define CYAlertViewAnimationDuration    0.25f

#define CYAlertViewTitleTopMargin       20.0f
#define CYAlertViewImageTopMargin       35.0f
#define CYAlertViewImageWidth           35.0f
#define CYAlertViewMessageTopMargin     10.0f
#define CYAlertViewButtonHeight         45.0f

#define CYAlertViewTextColor [UIColor colorWithRed:63.0/255 green:63.0/255 blue:63.0/355 alpha:1.0]
#define CYAlertViewButtonTitleColor [UIColor colorWithRed:22.0/255 green:162.0/255 blue:222.0/255 alpha:1.0]
#define CYAlertViewSeperatorColor [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1.0]

static UIWindow *CYAlertWindow;

@interface CYAlertCustomView ()

@property (nonatomic, weak) CYAlertController *alertController;

@end

@implementation CYAlertCustomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.okButton.titleLabel.text.length == 0 && self.okButton.currentImage == nil) {
        [self.okButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    }
    if (self.cancelButton.titleLabel.text.length == 0 && self.cancelButton.currentImage == nil) {
        [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self hide:self.alertController.animated];
}

- (IBAction)okButtonPressed:(id)sender {
    [self hide:self.alertController.animated];
}

- (CYAlertController *)showFromViewController:(UIViewController *)viewController
                               preferredStyle:(CYAlertControllerStyle)preferredStyle
                                     animated:(BOOL)animated {
    return [self showFromViewController:viewController preferredStyle:preferredStyle animated:animated maskColor:nil];
}

- (CYAlertController *)showFromViewController:(UIViewController *)viewController
                               preferredStyle:(CYAlertControllerStyle)preferredStyle
                                     animated:(BOOL)animated
                                    maskColor:(UIColor *)maskColor {
    CYAlertController *alertController = [CYAlertController alertControllerWithCustomView:self preferredStyle:preferredStyle];
    alertController.maskColor = maskColor;
    alertController.offsetCenterY = self.offsetCenterY;
    [alertController presentFromViewController:viewController animated:animated];
    self.alertController = alertController;
    
    return alertController;
}

- (void)hide:(BOOL)animated {
    [self.alertController dismiss:animated];
}

@end

@interface CYAlertAction ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL bold;
@property (nonatomic, copy) void (^handler)(CYAlertAction *action);

@end

@implementation CYAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CYAlertAction *))handler {
    return [CYAlertAction actionWithTitle:title bold:NO handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title bold:(BOOL)bold handler:(void (^)(CYAlertAction *action))handler {
    CYAlertAction *action = [[CYAlertAction alloc] init];
    action.title = title;
    action.bold = bold;
    action.handler = handler;
    action.style = UIAlertActionStyleDefault;
    return action;
}

@end

@interface UIAlertAction (CYAlertAction)

+ (instancetype)actionWithCYAlertAction:(CYAlertAction *)alertAction style:(UIAlertActionStyle)style;

@end

@implementation UIAlertAction (CYAlertAction)

+ (instancetype)actionWithCYAlertAction:(CYAlertAction *)alertAction style:(UIAlertActionStyle)style {
    UIAlertAction *action = [UIAlertAction actionWithTitle:alertAction.title style:style handler:^(UIAlertAction * _Nonnull action) {
        if (alertAction.handler != nil) {
            alertAction.handler(alertAction);
        }
    }];
    return action;
}

@end

@interface CYAlertController () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong) NSArray<CYAlertAction *> *actions;
@property (nonatomic, assign) CYAlertControllerStyle preferredStyle;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, weak) UIViewController *fromController;

@end

@implementation CYAlertController
@dynamic title;

#pragma mark - Properties

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CYAlertViewLeftPadding, CYAlertViewTitleTopMargin, CYAlertViewWidth - CYAlertViewLeftPadding * 2, CYAlertViewTextFontSize + 1.0)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:CYAlertViewTextFontSize + 1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = CYAlertViewTextColor;
    }
    
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CYAlertViewLeftPadding, 0.0, CYAlertViewWidth - CYAlertViewLeftPadding * 2, CYAlertViewTextFontSize)];
        _messageLabel.font = [UIFont systemFontOfSize:CYAlertViewTextFontSize];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = CYAlertViewTextColor;
        _messageLabel.numberOfLines = 0;
    }
    
    return _messageLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, CYAlertViewImageTopMargin, CYAlertViewImageWidth, CYAlertViewImageWidth)];
    }
    
    return _imageView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CYAlertViewWidth, 0.0)];
        _contentView.layer.cornerRadius = CYAlertViewCornerRadius;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIToolbar *blurView = [[UIToolbar alloc] initWithFrame:self.contentView.bounds];
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:blurView];
    }
    
    return _contentView;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backgroundView.backgroundColor = self.maskColor ?: [UIColor colorWithWhite:0.0 alpha:0.4];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.userInteractionEnabled = NO;
        _backgroundView = backgroundView;
    }
    
    return _backgroundView;
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    _backgroundView.backgroundColor = maskColor;
}

#pragma mark - Lifecycle

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(CYAlertControllerStyle)preferredStyle {
    CYAlertController *alertController = [[CYAlertController alloc] init];
    alertController.title = title;
    alertController.message = message;
    alertController.preferredStyle = preferredStyle;
    
    return alertController;
}

+ (instancetype)alertControllerWithImage:(UIImage *)image message:(NSString *)message preferredStyle:(CYAlertControllerStyle)preferredStyle {
    CYAlertController *alertController = [[CYAlertController alloc] init];
    alertController.image = image;
    alertController.message = message;
    alertController.preferredStyle = preferredStyle;
    
    return alertController;
}

+ (instancetype)alertControllerWithCustomView:(CYAlertCustomView *)customView preferredStyle:(CYAlertControllerStyle)preferredStyle {
    CYAlertController *alertController = [[CYAlertController alloc] init];
    alertController.customView = customView;
    alertController.preferredStyle = preferredStyle;
    
    customView.alertController = alertController;
    
    return alertController;
}

- (void)dealloc {
    self.titleLabel = nil;
    self.imageView = nil;
    self.messageLabel = nil;
    self.contentView = nil;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.backgroundView atIndex:0];
    
    if (!(self.preferredStyle == CYAlertControllerStyleAlert || self.preferredStyle == CYAlertControllerStyleSystemAlert)) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGesture.delegate = self;
        [self.view addGestureRecognizer:tapGesture];
    }
}

- (void)layoutContentView {
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    CGRect frame = CGRectZero;
    if (self.title != nil) {
        self.titleLabel.text = self.title;
        [self.contentView addSubview:self.titleLabel];
        offsetY = CGRectGetMaxY(self.titleLabel.frame);
    }
    if (self.image != nil) {
        self.imageView.image = self.image;
        frame = self.imageView.frame;
        frame.origin.x = (CYAlertViewWidth - frame.size.width) / 2;
        self.imageView.frame = frame;
        [self.contentView addSubview:self.imageView];
        offsetY = CGRectGetMaxY(self.imageView.frame);
    }
    if (self.message != nil) {
        self.messageLabel.text = self.message;
        CGRect boundingSize = [self.message boundingRectWithSize:CGSizeMake(self.messageLabel.frame.size.width, CGFLOAT_MAX) options:0 attributes:@{NSFontAttributeName: self.messageLabel.font} context:NULL];
        frame = self.messageLabel.frame;
        frame.origin.y = offsetY + CYAlertViewMessageTopMargin;
        frame.size.height = boundingSize.size.height;
        self.messageLabel.frame = frame;
        [self.contentView addSubview:self.messageLabel];
        offsetY = CGRectGetMaxY(self.messageLabel.frame);
    }
    
    NSAssert(self.actions.count > 0, @"Aert actions can not be nil.");
    
    offsetY += CYAlertViewTitleTopMargin;
    for (int i = 0; i < self.actions.count; i++) {
        CYAlertAction *action = self.actions[i];
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offsetY, CYAlertViewWidth, 0.5)];
        seperatorView.backgroundColor = CYAlertViewSeperatorColor;
        [self.contentView addSubview:seperatorView];
        offsetY = CGRectGetMaxY(seperatorView.frame);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        if (action.bold) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:CYAlertViewTextFontSize];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:CYAlertViewTextFontSize];
        }
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:CYAlertViewButtonTitleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.preferredStyle == CYAlertControllerStyleAlert || (self.preferredStyle == CYAlertControllerStyleSystemAlert && self.actions.count > 2)) {
            if (i > 0) {
                UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offsetY, CYAlertViewWidth, 0.5)];
                seperatorView.backgroundColor = CYAlertViewSeperatorColor;
                [self.contentView addSubview:seperatorView];
                offsetY = CGRectGetMaxY(seperatorView.frame);
            }
            
            frame = button.frame;
            frame.origin.y = offsetY;
            frame.size.height = CYAlertViewButtonHeight;
            frame.size.width = CYAlertViewWidth;
            button.frame = frame;
            [self.contentView addSubview:button];
            offsetY = CGRectGetMaxY(button.frame);
        } else if (self.preferredStyle == CYAlertControllerStyleSystemAlert) {
            if (i > 0) {
                UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, 0.5, CYAlertViewButtonHeight)];
                seperatorView.backgroundColor = CYAlertViewSeperatorColor;
                [self.contentView addSubview:seperatorView];
                offsetX = CGRectGetMaxX(seperatorView.frame);
            }
            
            frame = button.frame;
            frame.origin.x = offsetX;
            frame.origin.y = offsetY;
            frame.size.height = CYAlertViewButtonHeight;
            frame.size.width = (CYAlertViewWidth - (0.5 * (self.actions.count - 1))) / self.actions.count;
            button.frame = frame;
            [self.contentView addSubview:button];
            offsetX = CGRectGetMaxX(button.frame);
            
            if (i == self.actions.count - 1) {
                offsetY = CGRectGetMaxY(button.frame);
            }
        }
    }
    
    frame = self.contentView.frame;
    frame.size.height = offsetY;
    self.contentView.frame = frame;
    self.contentView.center = self.view.center;
    [self.view addSubview:self.contentView];
}

#pragma mark - Private Methods

- (void)presentAlertControllerFromController:(UIViewController *)viewControlelr style:(UIAlertControllerStyle)style animated:(BOOL)animated {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:style];
    for (int i = 0; i < self.actions.count; i++) {
        CYAlertAction *alertAction = self.actions[i];
        UIAlertAction *action = [UIAlertAction actionWithCYAlertAction:alertAction style:alertAction.style];
        [alertController addAction:action];
    }
    
    [viewControlelr presentViewController:alertController animated:animated completion:NULL];
}

#pragma mark - Public Methods

- (void)addAction:(CYAlertAction *)action {
    NSMutableArray *actions = [[NSMutableArray alloc] initWithArray:self.actions];
    if (action != nil) {
        [actions addObject:action];
    }
    self.actions = actions;
}

- (void)presentFromViewController:(UIViewController *)fromController animated:(BOOL)animated {
    NSAssert(fromController != nil, @"fromController can not be nil.");
    
    if (self.preferredStyle == CYAlertControllerStyleSystemActionSheet) {
        [self presentAlertControllerFromController:fromController style:UIAlertControllerStyleActionSheet animated:animated];
        return;
    }
    
    if (CYAlertWindow == nil) {
        CYAlertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        CYAlertWindow.backgroundColor = [UIColor clearColor];
        CYAlertWindow.windowLevel = UIWindowLevelAlert - 1;
    }
    
    self.fromController = fromController;
    self.animated = animated;
    CYAlertWindow.rootViewController = self;
    
    if (self.preferredStyle == CYAlertControllerStyleAlert || self.preferredStyle == CYAlertControllerStyleSystemAlert) {
        [self layoutContentView];
    } else {
        NSAssert(self.customView != nil, @"customView can not be nil if preferredStyle is equal CYAlertControllerStyleCustomAlert or CYAlertControllerStyleCustomActionSheet");
        if (self.preferredStyle == CYAlertControllerStyleCustomAlert) {
            self.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
            CGPoint center = self.view.center;
            center.y += self.offsetCenterY;
            self.customView.center = center;
            [self.view addSubview:self.customView];
        } else {
            CGRect frame = self.customView.frame;
            frame.origin.y = self.view.frame.size.height;
            frame.size.width = self.view.frame.size.width;
            self.customView.frame = frame;
            self.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
            [self.view addSubview:self.customView];
        }
        [self.view addSubview:self.customView];
    }
    
    [CYAlertWindow makeKeyAndVisible];
    
    if (self.preferredStyle == CYAlertControllerStyleAlert || self.preferredStyle == CYAlertControllerStyleCustomAlert) {
        self.backgroundView.alpha = 0.0;
        self.contentView.alpha = 0.0;
//        self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:animated ? CYAlertViewAnimationDuration : 0.0 animations:^{
            self.backgroundView.alpha = 1.0;
            self.contentView.alpha = 1.0;
//            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:animated ? CYAlertViewAnimationDuration / 3 : 0.0 animations:^{
//                self.contentView.transform = CGAffineTransformIdentity;
//            } completion:NULL];
        }];
    } else {
        self.backgroundView.alpha = 0.0;
        [UIView animateWithDuration:animated ? CYAlertViewAnimationDuration : 0.0 animations:^{
            self.backgroundView.alpha = 1.0;
            CGRect frame = self.customView.frame;
            frame.origin.y = self.view.frame.size.height - frame.size.height;
            self.customView.frame = frame;
        } completion:NULL];
    }
}

- (void)dismiss:(BOOL)animated {
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        [self.fromController.view.window makeKeyAndVisible];
        CYAlertWindow.hidden = YES;
        //CYAlertWindow.rootViewController = nil;
    };
    
    if (animated) {
        [UIView animateWithDuration:CYAlertViewAnimationDuration animations:^{
            self.backgroundView.alpha = 0.0;
            switch (self.preferredStyle) {
                case CYAlertControllerStyleAlert:
                case CYAlertControllerStyleSystemAlert:
                    self.contentView.alpha = 0.0;
                    break;
                case CYAlertControllerStyleCustomAlert:
                    self.customView.alpha = 0.0;
                    break;
                case CYAlertControllerStyleCustomActionSheet: {
                    CGRect frame = self.customView.frame;
                    frame.origin.y = self.view.frame.size.height;
                    self.customView.frame = frame;
                    break;
                    
                default:
                    break;
                }
            }
        } completion:completion];
    } else {
        completion(YES);
    }
}

#pragma mark - Acitons

- (IBAction)viewTapped:(id)sender {
    [self dismiss:self.animated];
}

- (IBAction)buttonPressed:(id)sender {
    [self dismiss:self.animated];
    
    UIButton *button = (UIButton *)sender;
    CYAlertAction *action = self.actions[button.tag];
    if (action.handler != nil) {
        action.handler(action);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}

@end
