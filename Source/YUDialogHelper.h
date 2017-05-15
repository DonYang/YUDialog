//
// Created by DonYang on 3/29/17.
// Lincesed under The MIT License (MIT)
//

#import <UIKit/UIKit.h>
#import "YUFlatDialog.h"

@interface YUDialogHelper : UIView

+ (void)alertMsg:(NSString *)msg;

+ (void)alertMsg:(NSString *)msg handler:(void (^)(YUFlatDialog *))handler;

+ (void)alertMsg:(NSString *)msg btn:(NSString *)btn handler:(void (^)(YUFlatDialog *))handler;

+ (void)confirm:(NSString *)msg btn:(NSString *)btn handler:(void (^)(YUFlatDialog *))handler;

+ (void)confirm:(NSString *)msg
        leftBtn:(NSString *)leftBtn
    leftHandler:(void (^)(YUFlatDialog *))leftHandler
       rightBtn:(NSString *)rightBtn
   rightHandler:(void (^)(YUFlatDialog *))rightHandler;

+ (YUFlatDialog *)showDialog:(NSString *)msg
              btns:(NSArray <NSString*> *)btns
          handlers:(NSArray <void (^)(YUFlatDialog *)>*)handlers;

+ (YUFlatDialog *)showDialog:(NSString *)msg
              btns:(NSArray <NSString*> *)btns
          handlers:(NSArray <void (^)(YUFlatDialog *)>*)handlers
    destructiveIdx:(NSInteger)destructiveIdx;

@end