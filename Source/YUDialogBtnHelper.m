//
//  YUDialogBtnHelper.m
//  Pods
//
//  Created by Don Yang on 23/05/2017.
//
//

#import "YUDialogBtnHelper.h"

#define YUDIALOG_BUTTON_FONT [UIFont systemFontOfSize:15.0f]

@implementation YUDialogBtnHelper

+ (UIButton *)createBtn:(NSString *)name isDestructive:(BOOL)isDestructive {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColor.whiteColor;
    [btn setTitle:name forState:UIControlStateNormal];
    if (isDestructive) {
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    } else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    [btn.titleLabel setFont:YUDIALOG_BUTTON_FONT];
    return btn;
}

+ (UIButton *)createBtn:(NSString *)name {
    return [self createBtn:name isDestructive:NO];
}

@end
