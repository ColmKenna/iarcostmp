#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    if (!image) return nil;

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
