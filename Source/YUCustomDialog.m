//
//  Created by DonYang on 3/29/17.
//
//  Lincesed under The MIT License (MIT)
//

#import "YUCustomDialog.h"

#define YU_CUSTOM_DIALOG_DEFAULT_BUTTON_HEIGHT 50.0f
#define YU_CUSTOM_DIALOG_DEFAULT_DIVIDER_HEIGHT_PX 1.0f
#define YU_CUSTOM_DIALOG_DEFAULT_DIALOG_CORNER_RADIUS 0
#define YU_CUSTOM_DIALOG_DEFAULT_DIALOG_BORDER_WIDTH 0
#define YU_CUSTOM_DIALOG_DEFAULT_EFFECT_EXTENT 10.0f
#define YU_CUSTOM_DIALOG_UICOLOR(R, G, B, A) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A)]

@interface YUCustomDialog ()

@property(nonatomic, assign) CGFloat curDividerHeight;
@property(nonatomic, assign) CGFloat curButtonHeight;

@property(nonatomic, strong) UIView *dialogView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSArray<UIButton *> *buttons;
@property(nonatomic, strong) NSArray<void (^)(YUCustomDialog *)> *handlers;

@property(nonatomic, assign) CGFloat dialogWidth;
@property(nonatomic, assign) CGFloat dialogHeight;

@end

@implementation YUCustomDialog

- (instancetype)initWithCustomView:(UIView *)customView
                           buttons:(NSArray<UIButton *> *)buttons
                          handlers:(NSArray<void (^)(YUCustomDialog *)> *)handlers {

    self = [super init];
    if (self) {
        if (customView == nil) {
            NSAssert(NO, @"YUCustomDialog customView must not be null!");
        }
        _contentView = customView;

        if (buttons.count != handlers.count) {
            NSAssert(NO, @"YUCustomDialog button and handler must with same type!");
        }
        _buttons = buttons;
        _handlers = handlers;
        
        _dividerHeight = YU_CUSTOM_DIALOG_DEFAULT_DIVIDER_HEIGHT_PX / [UIScreen mainScreen].scale;
        _buttonHeight = YU_CUSTOM_DIALOG_DEFAULT_BUTTON_HEIGHT;
        _dialogCornerRadius = YU_CUSTOM_DIALOG_DEFAULT_DIALOG_CORNER_RADIUS;
        _dialogBorderWidth = YU_CUSTOM_DIALOG_DEFAULT_DIALOG_BORDER_WIDTH;
        _effectExtent = YU_CUSTOM_DIALOG_DEFAULT_EFFECT_EXTENT;
        _dividerColor = YU_CUSTOM_DIALOG_UICOLOR(198.0f, 198.0f, 198.0f, 1.0f);
        _useMotionEffects = false;
        _closeOnTouchOutside = false;

        if (_buttons != nil && [_buttons count] > 0) {
            _curButtonHeight = _buttonHeight;
            _curDividerHeight = _dividerHeight;
        } else {
            _curButtonHeight = 0;
            _curDividerHeight = 0;
        }
        _dialogWidth = _contentView.frame.size.width;
        _dialogHeight = _contentView.frame.size.height + _curButtonHeight + _curDividerHeight;

        self.backgroundColor = YU_CUSTOM_DIALOG_UICOLOR(0, 0, 0, 0);
        /// 待查用途
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)show {

    [self setFrame:CGRectMake(0, 0, self.screenSize.width, self.screenSize.height)];
    // On iOS7, calculate with orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI * 270.0f / 180.0f));
                break;

            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI * 90.0f / 180.0f));
                break;

            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI * 180.0f / 180.0f));
                break;

            default:
                break;
        }
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        // On iOS8, just place the dialog in the middle
    }

    _dialogView = [self createDialogView];
    [_dialogView addSubview:_contentView];
    [self addButtonsToDialogView:_dialogView];
#if(defined(__IPHONE_7_0))
    if (_useMotionEffects) {
        [self applyMotionEffectsToDialogView:_dialogView];
    }
#endif
    [self addSubview:_dialogView];

    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    [self doDialogShowAnim];
}

- (CGFloat)dialogX {
    return (self.screenSize.width - _dialogWidth) / 2;
}

- (CGFloat)dialogY {
    return (self.screenSize.height - _dialogHeight) / 2;
}

- (CGSize)screenSize {
    ///计算屏幕宽高
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    return CGSizeMake(screenWidth, screenHeight);
}

- (void)doDialogShowAnim {
    _dialogView.layer.opacity = 0.5f;
    _dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = YU_CUSTOM_DIALOG_UICOLOR(0, 0, 0, 0.4f);
                         _dialogView.layer.opacity = 1.0f;
                         _dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:nil
    ];
}

/// dialogView是用于放contentView, 分割线, 按钮三部分
- (UIView *)createDialogView {

    UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(self.dialogX, self.dialogY, _dialogWidth, _dialogHeight)];

    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogView.bounds;
    gradient.colors = @[
            (__bridge id) [YU_CUSTOM_DIALOG_UICOLOR(218.0f, 218.0f, 218.0f, 1.0f) CGColor],
            (__bridge id) [YU_CUSTOM_DIALOG_UICOLOR(233.0f, 233.0f, 233.0f, 1.0f) CGColor],
            (__bridge id) [YU_CUSTOM_DIALOG_UICOLOR(218.0f, 218.0f, 218.0f, 1.0f) CGColor]
    ];
    if(_dialogCornerRadius > 0){
        gradient.cornerRadius = _dialogCornerRadius;
    }

    [dialogView.layer insertSublayer:gradient atIndex:0];

    if(_dialogBorderWidth){
        dialogView.layer.borderColor = [YU_CUSTOM_DIALOG_UICOLOR(198.0f, 198.0f, 198.0f, 1.0f) CGColor];
        dialogView.layer.borderWidth = _dialogBorderWidth;
    }

    if(_dialogCornerRadius){
        dialogView.layer.cornerRadius = _dialogCornerRadius;
        dialogView.layer.shadowRadius = _dialogCornerRadius + 5;
        dialogView.layer.shadowOpacity = 0.1f;
        dialogView.layer.shadowOffset = CGSizeMake(0 - (_dialogCornerRadius + 5) / 2, 0 - (_dialogCornerRadius + 5) / 2);
        dialogView.layer.shadowColor = [UIColor blackColor].CGColor;
        dialogView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogView.bounds
                                                                 cornerRadius:dialogView.layer.cornerRadius].CGPath;
    }

    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(
            0, dialogView.bounds.size.height - _curButtonHeight - _curDividerHeight,
            dialogView.bounds.size.width, _curDividerHeight
    )];
    divider.backgroundColor = _dividerColor;
    [dialogView addSubview:divider];

    /// 待查用途
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    return dialogView;
}

- (void)addButtonsToDialogView:(UIView *)dialogView {
    if (_buttons == nil || _buttons.count == 0) {
        return;
    }

    CGFloat buttonWidth = dialogView.bounds.size.width / _buttons.count;
    NSUInteger idx = 0;
    for (UIButton *btn in _buttons) {
        [btn setFrame:CGRectMake(
                idx * buttonWidth,
                dialogView.bounds.size.height - _curButtonHeight,
                buttonWidth,
                _curButtonHeight
        )];
        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:idx];
        [dialogView addSubview:btn];

        idx++;
    }
}

- (void)onButtonClick:(UIButton *)sender {
    void (^handler)(YUCustomDialog *) = _handlers[(NSUInteger) sender.tag];
    if (handler != nil) {
        handler(self);
    }
}

- (void)dismiss {
    CATransform3D currentTransform = _dialogView.layer.transform;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[_dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation((CGFloat) (-startRotation + M_PI * 270.0f / 180.0f), 0.0f, 0.0f, 0.0f);

        _dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }

    _dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = YU_CUSTOM_DIALOG_UICOLOR(0, 0, 0, 0);
                         _dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         _dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
    ];
}

#if (defined(__IPHONE_7_0))

- (void)applyMotionEffectsToDialogView:(UIView *)dialogView {

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }

    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-_effectExtent);
    horizontalEffect.maximumRelativeValue = @( _effectExtent);

    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-_effectExtent);
    verticalEffect.maximumRelativeValue = @( _effectExtent);

    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];

    [dialogView addMotionEffect:motionEffectGroup];
}

#endif

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Rotation changed, on iOS7
- (void)changeOrientationForIOS7 {

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation((CGFloat) (-startRotation + M_PI * 270.0f / 180.0f));
            break;

        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation((CGFloat) (-startRotation + M_PI * 90.0f / 180.0f));
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation((CGFloat) (-startRotation + M_PI * 180.0f / 180.0f));
            break;

        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0f);
            break;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.transform = rotation;
                     }
                     completion:nil
    ];

}

// Rotation changed, on iOS8
- (void)changeOrientationForIOS8:(NSNotification *)notification {
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize keyboardSize = [[notification userInfo][UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         CGSize screenSize = self.screenSize;
                         self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
                         _dialogView.frame = CGRectMake(
                                 self.dialogX, self.dialogY - keyboardSize.height / 2, _dialogWidth, _dialogHeight
                         );
                     }
                     completion:nil
    ];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[notification userInfo][UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.frame = CGRectMake(
                                 self.dialogX, self.dialogY - keyboardSize.height / 2, _dialogWidth, _dialogHeight
                         );
                     }
                     completion:nil
    ];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.frame = CGRectMake(
                                 self.dialogX, self.dialogY, _dialogWidth, _dialogHeight
                         );
                     }
                     completion:nil
    ];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_closeOnTouchOutside) {
        return;
    }

    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[YUCustomDialog class]]) {
        [self dismiss];
    }
}

@end
