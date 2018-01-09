//
//  MHImagePickerController.m
//  maihua
//
//  Created by xgd on 16/11/29.
//  Copyright © 2016年 xgd. All rights reserved.
//

#import "YKXImagePickerController.h"

@interface CCImagePickerController : UIImagePickerController

@end

@implementation CCImagePickerController

@end

@interface YKXImagePickerController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) CCImagePickerController *imagePickerController;
@property (nonatomic,copy) void(^completion)(UIImage *selectImage,CTImagePickerStatus status);
@end

@implementation YKXImagePickerController
- (instancetype)init{
    if(self = [super init]){
        self.allowsEditing = YES;
    }
    return self;
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType superVC:(UIViewController *)superVC completion:(void (^)(UIImage *, CTImagePickerStatus))completion{
    
    self.completion = completion;
    
    if(sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        if(![self isPhotoLibraryAvailable]){
            [self completionImagePick:self.imagePickerController image:nil status:CTImagePickerStatusNotPhoto];
            return;
        }
    }
    
    if(sourceType == UIImagePickerControllerSourceTypeCamera){
        if(![self isCameraAvailable]){
            [self completionImagePick:self.imagePickerController image:nil status:CTImagePickerStatusNotCamera];
            return;
        }
    }
    
    //创建照相机对象
    if(!self.imagePickerController){
        self.imagePickerController = [[CCImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    
    self.imagePickerController.allowsEditing = self.allowsEditing;
    self.imagePickerController.sourceType = sourceType;
    
    [superVC presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)completionImagePick:(UIImagePickerController *)picker image:(UIImage *)image status:(CTImagePickerStatus)status{
    if(picker){
        [picker dismissViewControllerAnimated:YES completion:^{
            if(self.completion){
                self.completion(image,status);
            }
        }];
    }
}

//判断是否有摄像头
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//相册是否可用
- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [self completionImagePick:picker image:image status:CTImagePickerStatusNone];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
