//
// Created by DonYang on 3/29/17.
// Lincesed under The MIT License (MIT)
//

#import "YUDialogHelper.h"
#import "YUImageDialog.h"

@implementation YUDialogHelper

+ (void)alertImage:(UIImage *)image {
    YUImageDialog *dialog = [[YUImageDialog alloc] initWithImage:image];
    [dialog show];
}

+ (void)alertMsg:(NSString *)msg {
    [self alertMsg:msg handler:^(YUFlatDialog *dialog) {
        [dialog dismiss];
    }];
}

+ (void)alertMsg:(NSString *)msg handler:(void (^)(YUFlatDialog *))handler {
    [self alertMsg:msg btn:@"知道了" handler:handler];
}

+ (void)alertMsg:(NSString *)msg btn:(NSString *)btn handler:(void (^)(YUFlatDialog *))handler {
    [self showDialog:msg btns:@[btn] handlers:@[handler]];
}

+ (void)confirm:(NSString *)msg btn:(NSString *)btn handler:(void (^)(YUFlatDialog *))handler {
    [self confirm:msg
          leftBtn:@"取消"
      leftHandler:^(YUFlatDialog *dialog) { [dialog dismiss]; }
         rightBtn:btn
     rightHandler:handler];
}

+ (void)confirm:(NSString *)msg
        leftBtn:(NSString *)leftBtn
    leftHandler:(void (^)(YUFlatDialog *))leftHandler
       rightBtn:(NSString *)rightBtn
   rightHandler:(void (^)(YUFlatDialog *))rightHandler {
    [self showDialog:msg btns:@[leftBtn, rightBtn] handlers:@[leftHandler, rightHandler]];
}

+ (YUFlatDialog *)showDialog:(NSString *)msg
              btns:(NSArray <NSString *> *)btns
          handlers:(NSArray <void (^)(YUFlatDialog *)> *)handlers {
    return [self showDialog:msg btns:btns handlers:handlers destructiveIdx:-1];
}

+ (YUFlatDialog *)showDialog:(NSString *)msg
              btns:(NSArray <NSString *> *)btns
          handlers:(NSArray <void (^)(YUFlatDialog *)> *)handlers
    destructiveIdx:(NSInteger)destructiveIdx {
    YUFlatDialog *dialog = [[YUFlatDialog alloc] initWithMsg:msg btnNames:btns handlers:handlers destructiveBtnIdx:destructiveIdx];
    [dialog show];
    return dialog;
}

@end
