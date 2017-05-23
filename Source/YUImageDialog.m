//
//  YUImageDialog.m
//  Pods
//
//  Created by Don Yang on 23/05/2017.
//
//

#import "YUImageDialog.h"
#import "YUDialogBtnHelper.h"

@implementation YUImageDialog

- (instancetype)initWithImage:(UIImage *)image {
    
    UIButton *button = [YUDialogBtnHelper createBtn:@"关闭" isDestructive: NO];
    UIImageView *iv = [YUImageDialog createImage:image];
    
    self = [super initWithCustomView:iv buttons:@[button] handlers: @[^(YUImageDialog *dialog) {
        [dialog dismiss];
    }]];
    if (self) {
        
    }
    return self;
}

+ (UIImageView *)createImage: (UIImage *)image {
    UIImageView *iv = [[UIImageView alloc] initWithImage: image];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if(image.size.width > screenWidth){
        iv.frame = CGRectMake(0, 0, screenWidth, image.size.height*(screenWidth / image.size.width));
    }
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(image.size.height > screenHeight){
        iv.frame = CGRectMake(0, 0, image.size.width*(screenHeight/image.size.height), screenHeight);
    }
    
    return iv;
}

@end
