//
//  UIImage+BDPhotoPickerController.h
//  test_photo
//
//  Created by 王建斌 on 16/11/4.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BDPhotoPickerController)

- (void)saveToAlbum:(nullable void(^)(BOOL success, NSString *assetID, NSError *__nullable error))completionHandler;

- (void)saveToCustomCollectionWithName:(NSString*)name complete:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

@end
