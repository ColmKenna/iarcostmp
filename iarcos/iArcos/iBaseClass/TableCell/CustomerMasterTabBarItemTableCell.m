//
//  CustomerMasterTabBarItemTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterTabBarItemTableCell.h"

@implementation CustomerMasterTabBarItemTableCell
@synthesize tabItemButton = _tabItemButton;
@synthesize tabItemTitleLabel = _tabItemTitleLabel;
@synthesize auxView = _auxView;
@synthesize dividerView = _dividerView;
@synthesize clickTimes = _clickTimes;
@synthesize myImageFile = _myImageFile;
@synthesize indexPath = _indexPath;
@synthesize mySelectedImage = _mySelectedImage;
@synthesize myUnSelectedImage = _myUnSelectedImage;
//@synthesize isImageCalculated = _isImageCalculated;
@synthesize myCustomController = _myCustomController;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.tabItemButton = nil;
    self.tabItemTitleLabel = nil;
    self.auxView = nil;
    self.dividerView = nil;
    self.myImageFile = nil;
    self.indexPath = nil;
    self.mySelectedImage = nil;
    self.myUnSelectedImage = nil;
    self.myCustomController = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)theData currentIndexPath:(NSIndexPath*)aCurrentIndexPath {
//    if (!self.isImageCalculated) {
//        self.isImageCalculated = NO;
//        
//    }
    UIImage* baseImage = [UIImage imageNamed:[theData objectForKey:@"ImageFile"]];
    self.mySelectedImage = [self getTabItemImage:baseImage size:baseImage.size selected:YES];
    self.myUnSelectedImage = [self getTabItemImage:baseImage size:baseImage.size selected:NO];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.auxView addGestureRecognizer:singleTap1];
    [singleTap1 release];
    self.clickTimes = 0;
    self.myImageFile = [theData objectForKey:@"ImageFile"];
    if (aCurrentIndexPath != nil && self.indexPath.row == aCurrentIndexPath.row) {
        [self selectedImageProcessor];
    } else {
        [self unSelectedImageProcessor];
    }
    self.tabItemTitleLabel.text = [theData objectForKey:@"Title"];
    self.myCustomController = [theData objectForKey:@"MyCustomController"];
}

- (void)selectedImageProcessor {
    [self.tabItemButton setImage:self.mySelectedImage forState:UIControlStateNormal];
    self.tabItemTitleLabel.textColor = [UIColor colorWithRed:0.0 green:132.0/255.0 blue:254.0/255.0 alpha:1.0];
}

- (void)unSelectedImageProcessor {
    [self.tabItemButton setImage:self.myUnSelectedImage forState:UIControlStateNormal];
    self.tabItemTitleLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
}

- (void)handleSingleTapGesture {
//    [self.actionDelegate didSelectTableRow:self.indexPath];
}

-(UIImage*)getTabItemImage:(UIImage*)sourceImage size:(CGSize)sourceSize selected:(BOOL)selectedFlag {
    UIImage* backgroundImage = [self tabBarBackgroundImageWithSize:sourceImage.size selected:selectedFlag];
    
    // Convert the passed in image to a white backround image with a black fill
    UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:sourceImage];
    
    // Create an image mask
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
                                             CGImageGetHeight(bwImage.CGImage),
                                             CGImageGetBitsPerComponent(bwImage.CGImage),
                                             CGImageGetBitsPerPixel(bwImage.CGImage),
                                             CGImageGetBytesPerRow(bwImage.CGImage),
                                             CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
    
    // Using the mask create a new image
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
    
    UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:sourceImage.scale orientation:sourceImage.imageOrientation];
    
    // Cleanup
    CGImageRelease(imageMask);
    CGImageRelease(tabBarImageRef);
    
    // Create a new context with the right size
    UIGraphicsBeginImageContextWithOptions(sourceSize, NO, 0.0);
    
    // Draw the new tab bar image at the center
    
    [tabBarImage drawInRect:CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// Convert the image's fill color to black and background to white
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)sourceImage {
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(sourceImage.CGImage), CGImageGetHeight(sourceImage.CGImage));
    //    NSLog(@"imageRect: %@",NSStringFromCGRect(imageRect));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(sourceImage.CGImage), 1);
    //kCGBitmapAlphaInfoMask kCGImageAlphaPremultipliedLast
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, sourceImage.CGImage);
    // Set the fill color to black: R:0 G:0 B:0 alpha:1
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    // Fill with black
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:sourceImage.scale orientation:sourceImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)sourceSize selected:(BOOL)selectedFlag {
    UIGraphicsBeginImageContextWithOptions(sourceSize, NO, 0.0);
    if (selectedFlag) {
        [[UIColor colorWithRed:0.0 green:132.0/255.0 blue:254.0/255.0 alpha:1.0] set];
        UIRectFill(CGRectMake(0, 0, sourceSize.width, sourceSize.height));
    } else {
        [[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0] set];
        UIRectFill(CGRectMake(0, 0, sourceSize.width, sourceSize.height));
    }
    
    UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalBackgroundImage;
}

@end
