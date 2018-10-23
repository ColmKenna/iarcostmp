//
//  CustomerSurveyPreviewPhotoDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 27/04/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerSurveyPreviewPhotoDelegate <NSObject>

- (void)retakePhotoWithIndexPath:(NSIndexPath*)anIndexPath currentFileName:(NSString*)aCurrentFileName previousFileName:(NSString*)aPreviousFileName;
- (void)deletePhotoWithIndexPath:(NSIndexPath*)anIndexPath currentFileName:(NSString*)aCurrentFileName;
- (void)configImagePickerDisplayFlag:(BOOL)aFlag;
- (void)takePhotoWithIndexPath:(NSIndexPath*)anIndexPath currentFileName:(NSString*)aCurrentFileName;

@end
