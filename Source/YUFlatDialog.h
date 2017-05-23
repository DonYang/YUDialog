//
// Created by DonYang on 3/30/17.
// Lincesed under The MIT License (MIT)
//

#import <Foundation/Foundation.h>
#import "YUCustomDialog.h"

@interface YUFlatDialog : YUCustomDialog

- (instancetype)initWithMsg:(NSString *)msg
                   btnNames:(NSArray <NSString *> *)names
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers;

- (instancetype)initWithMsg:(NSString *)msg
                   btnNames:(NSArray <NSString *> *)names
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers
          destructiveBtnIdx:(NSInteger)btnIdx;

- (instancetype)initWithMsg:(NSString *)msg
                   btnNames:(NSArray <NSString *> *)names
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers
                contentSize:(CGSize)contentSize
          destructiveBtnIdx:(NSInteger)btnIdx;

- (instancetype)initWithMsg:(NSString *)msg
                       btns:(NSArray <UIButton *> *)btns
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers
                contentSize:(CGSize)contentSize;

@end
