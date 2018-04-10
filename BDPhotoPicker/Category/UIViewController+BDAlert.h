//
//  UIViewController+BDAlert.h
//  test_BDPhotoPicker
//
//  Created by 王建斌 on 2018/4/9.
//  Copyright © 2018年 buydeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BDAlert)

- (void)showSimpleWarningAlertWithTitle:(NSString*)title;

- (void)showAlertWithTitle:(NSString*)strTitle info:(NSString*)strInfo titles:(NSArray<NSString*>*)arrTitles handle:(void(^)(UIAlertController*alertVC, NSString *btnTitle, NSInteger btnIdx))handleBlock;

@end
