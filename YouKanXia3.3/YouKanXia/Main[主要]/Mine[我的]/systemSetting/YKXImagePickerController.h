//
//  MHImagePickerController.h
//  maihua
//
//  Created by xgd on 16/11/29.
//  Copyright © 2016年 xgd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,CTImagePickerStatus) {
    CTImagePickerStatusNone,
    CTImagePickerStatusNotPhoto,
    CTImagePickerStatusNotCamera
};

@interface YKXImagePickerController : NSObject
@property (nonatomic, assign) BOOL allowsEditing;

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                        superVC:(UIViewController *)superVC
                     completion:(void (^)(UIImage *image, CTImagePickerStatus status))completion;
- (BOOL)isCameraAvailable;
- (BOOL)isPhotoLibraryAvailable;
@end
