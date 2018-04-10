//
//  UIViewController+BDAlert.m
//  test_BDPhotoPicker
//
//  Created by 王建斌 on 2018/4/9.
//  Copyright © 2018年 buydeem. All rights reserved.
//

#import "UIViewController+BDAlert.h"

@implementation UIViewController (BDAlert)

- (void)showSimpleWarningAlertWithTitle:(NSString *)title
{
    [self showAlertWithTitle:title info:nil titles:@[title] handle:^(UIAlertController *alertVC, NSString *btnTitle, NSInteger btnIdx) {
        [alertVC dismissViewControllerAnimated:YES completion:NULL];
    }];
}

- (void)showAlertWithTitle:(NSString *)strTitle
                      info:(NSString *)strInfo
                    titles:(NSArray<NSString *> *)arrTitles
                    handle:(void (^)(UIAlertController*alertVC, NSString *btnTitle, NSInteger btnIdx))handleBlock
{
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:strTitle message:strInfo preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *btnTitle in arrTitles)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handleBlock)
            {
                handleBlock(alertvc, btnTitle, [arrTitles indexOfObject:btnTitle]);
            }
        }];
        [alertvc addAction:action];
    }
    
    [self presentViewController:alertvc animated:YES completion:NULL];
}

@end
