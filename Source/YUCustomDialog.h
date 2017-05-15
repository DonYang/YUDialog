//
//  Created by DonYang on 3/29/17.
//
//  Lincesed under The MIT License (MIT)
//

#import <UIKit/UIKit.h>

@interface YUCustomDialog : UIView

@property(nonatomic, assign) BOOL closeOnTouchOutside;

@property(nonatomic, assign) CGFloat buttonHeight;

@property(nonatomic, assign) CGFloat dividerHeight;

@property(nonatomic, strong) UIColor *dividerColor;

@property(nonatomic, assign) CGFloat dialogCornerRadius;

@property(nonatomic, assign) CGFloat dialogBorderWidth;

@property(nonatomic, assign) CGFloat effectExtent;

@property(nonatomic, assign) BOOL useMotionEffects;

- (instancetype)initWithCustomView:(UIView *)customView
                           buttons:(NSArray<UIButton *> *)buttons
                          handlers:(NSArray<void (^)(YUCustomDialog *)> *)handlers;

- (void)show;

- (void)dismiss;

@end
