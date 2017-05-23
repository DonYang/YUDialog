//
// Created by DonYang on 3/30/17.
// Lincesed under The MIT License (MIT)
//

#import "YUFlatDialog.h"
#import "YUDialogBtnHelper.h"

#define FLAT_DIALOG_CONTENT_SIZE CGSizeMake(290, 100)
#define FLAT_DIALOG_CONTENT_FONT [UIFont systemFontOfSize:14.0f]

@implementation YUFlatDialog

- (instancetype)initWithMsg:(NSString *)msg
                   btnNames:(NSArray <NSString *> *)names
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers {
    return [self initWithMsg:msg btnNames:names handlers:handlers destructiveBtnIdx:-1];
}

- (instancetype)initWithMsg:(NSString *)msg
                   btnNames:(NSArray <NSString *> *)names
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers
          destructiveBtnIdx:(NSInteger)destructiveIdx {
    return [self initWithMsg:msg btnNames:names handlers:handlers contentSize:CGSizeZero destructiveBtnIdx:destructiveIdx];
}

- (instancetype)initWithMsg:(NSString *)msg
                   btnNames:(NSArray <NSString *> *)names
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers
                contentSize:(CGSize)contentSize
          destructiveBtnIdx:(NSInteger)destructiveIdx {
    NSMutableArray<UIButton *> *buttons = [NSMutableArray arrayWithCapacity:3];
    NSInteger idx = 0;
    for (NSString *btnName in names) {
        [buttons addObject:[YUDialogBtnHelper createBtn:btnName isDestructive:(idx == destructiveIdx)]];
        idx++;
    }
    
    self = [self initWithMsg:msg btns:buttons handlers:handlers contentSize:contentSize];
    return self;
}

- (instancetype)initWithMsg:(NSString *)msg
                       btns:(NSArray <UIButton *> *)btns
                   handlers:(NSArray<void (^)(YUFlatDialog *)> *)handlers
                contentSize:(CGSize)contentSize {

    if (CGSizeEqualToSize(CGSizeZero, contentSize)) {
        contentSize = FLAT_DIALOG_CONTENT_SIZE;
    }
    self = [super initWithCustomView:[YUFlatDialog createFlatContentView:msg size:contentSize] buttons:btns handlers:(NSArray<void (^)(YUCustomDialog *)> *)handlers];
    if (self) {
        
    }
    return self;
}

+ (UIView *)createFlatContentView:(NSString *)msg size:(CGSize)size {
    UIView *flatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    flatView.backgroundColor = UIColor.whiteColor;

    CGFloat margin = 5.0f;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(
            margin, margin, flatView.frame.size.width - 2 * margin, flatView.frame.size.height - 2 * margin
    )];
    lbl.font = FLAT_DIALOG_CONTENT_FONT;
    lbl.text = msg;
    lbl.numberOfLines = 0;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = UIColor.blackColor;

    NSDictionary *attributes = @{NSFontAttributeName: lbl.font};
    CGSize constrainedSize = CGSizeMake(lbl.bounds.size.width, NSIntegerMax);
    CGRect needRect = [lbl.text boundingRectWithSize:constrainedSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:attributes
                                             context:nil];
    // if frame is smaller than msg needed, use UITextView for scroll.
    if (needRect.size.height > lbl.bounds.size.height) {
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(
                margin, margin, flatView.frame.size.width - 2 * margin, flatView.frame.size.height - 2 * margin
        )];
        tv.font = FLAT_DIALOG_CONTENT_FONT;
        tv.text = msg;
        tv.editable = NO;
        [flatView addSubview:tv];
    } else {
        [flatView addSubview:lbl];
    }

    return flatView;
}

@end
