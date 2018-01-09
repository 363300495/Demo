//
//  UIImage+SDResize.m
//  SDChat
//
//  Created by slowdony on 2017/8/5.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import "UIImage+SDResize.h"

@implementation UIImage (SDResize)

+ (UIImage *)SDResizeWithImageName:(NSString *)iconName{
    
    return [self SDResizeWithImage: [UIImage imageNamed: iconName]];
}

+ (UIImage *)SDResizeWithImage:(UIImage *)image{
    
    CGFloat w = image.size.width * 0.7;
    CGFloat h = image.size.height * 0.7;
    return [image resizableImageWithCapInsets: UIEdgeInsetsMake(h, w, h, w)];
}

+ (UIImage *)SDImageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
