//
//  YUDialogBtnHelper.h
//  Pods
//
//  Created by Don Yang on 23/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface YUDialogBtnHelper : NSObject

+ (UIButton *)createBtn:(NSString *)name isDestructive:(BOOL)isDestructive;

+ (UIButton *)createBtn:(NSString *)name;

@end
