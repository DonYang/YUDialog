//
//  ViewController.m
//  YUCustomDialog
//
//  Created by DonYang on 3/30/17.
//  Copyright © 2017 DonYang. All rights reserved.
//

#import "ViewController.h"
#import "YUDialogHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]];
    
    UIButton *msgDialog = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgDialog setFrame:CGRectMake(10, 30, self.view.bounds.size.width - 20, 50)];
    [msgDialog addTarget:self action:@selector(msgDialog:) forControlEvents:UIControlEventTouchDown];
    [msgDialog setTitle:@"Message Dialog" forState:UIControlStateNormal];
    [msgDialog setBackgroundColor:[UIColor whiteColor]];
    [msgDialog setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [msgDialog.layer setBorderWidth:0];
    [msgDialog.layer setCornerRadius:5];
    [self.view addSubview:msgDialog];
    
    UIButton *confirmDialog = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmDialog setFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 50)];
    [confirmDialog addTarget:self action:@selector(confirmDialog:) forControlEvents:UIControlEventTouchDown];
    [confirmDialog setTitle:@"Confirm Dialog" forState:UIControlStateNormal];
    [confirmDialog setBackgroundColor:[UIColor whiteColor]];
    [confirmDialog setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirmDialog.layer setBorderWidth:0];
    [confirmDialog.layer setCornerRadius:5];
    [self.view addSubview:confirmDialog];
    
    UIButton *deleteDialog = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteDialog setFrame:CGRectMake(10, 170, self.view.bounds.size.width - 20, 50)];
    [deleteDialog addTarget:self action:@selector(deleteDialog:) forControlEvents:UIControlEventTouchDown];
    [deleteDialog setTitle:@"Delete Dialog" forState:UIControlStateNormal];
    [deleteDialog setBackgroundColor:[UIColor whiteColor]];
    [deleteDialog setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [deleteDialog.layer setBorderWidth:0];
    [deleteDialog.layer setCornerRadius:5];
    [self.view addSubview:deleteDialog];
    
    UIButton *longTextDialog = [UIButton buttonWithType:UIButtonTypeCustom];
    [longTextDialog setFrame:CGRectMake(10, 240, self.view.bounds.size.width - 20, 50)];
    [longTextDialog addTarget:self action:@selector(longTextDialog:) forControlEvents:UIControlEventTouchDown];
    [longTextDialog setTitle:@"Long Text Dialog" forState:UIControlStateNormal];
    [longTextDialog setBackgroundColor:[UIColor whiteColor]];
    [longTextDialog setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [longTextDialog.layer setBorderWidth:0];
    [longTextDialog.layer setCornerRadius:5];
    [self.view addSubview:longTextDialog];
}

- (IBAction)msgDialog:(id)sender {
    [YUDialogHelper alertMsg:@"Hello, Flat Dialog"];
}

- (IBAction)confirmDialog:(id)sender {
    [YUDialogHelper confirm:@"This is confirm dialog with two buttons." btn:@"确定" handler:^(YUFlatDialog *dialog) {
        [dialog dismiss];
    }];
}

- (IBAction)deleteDialog:(id)sender {
    [YUDialogHelper showDialog:@"Are you sure, delete bla bla bla" btns:@[@"取消", @"删除"] handlers:@[
                                                                                                 ^(YUFlatDialog *dialog) { [dialog dismiss]; },
                                                                                                  ^(YUFlatDialog *dialog) { [dialog dismiss]; }
                                                                                                  ] destructiveIdx:1];
}

- (IBAction)longTextDialog:(id)sender {
    [YUDialogHelper alertMsg:@"Hello, Flat DialogHello, Flat DialogHello, Flat DialogHello, "
     "Flat DialogHello, Flat DialogHello, Flat DialogFlat DialogHello, Flat DialogHello, Flat Dialog"
     "Flat DialogHello, Flat DialogHello, Flat DialogFlat DialogHello, Flat DialogHello, Flat Dialog"
     "Flat DialogHello, Flat DialogHello, Flat DialogFlat DialogHello, Flat DialogHello, Flat Dialog"];
}
@end

