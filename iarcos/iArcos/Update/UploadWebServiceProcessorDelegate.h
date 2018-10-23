//
//  UploadWebServiceProcessorDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadWebServiceProcessorDelegate <NSObject>
- (void)uploadProcessStarted;
- (void)uploadProcessWithText:(NSString*)aText;
- (void)uploadProgressViewWithValue:(float)aProgressValue;
- (void)uploadProcessFinished:(NSString*)aSelectorName sectionTitle:(NSString*)aSectionTitle overallNumber:(int)anOverallNumber;
- (void)uploadProcessWithErrorMsg:(NSString*)anErrorMsg;
@optional
- (void)uploadBranchProcessInitiation;
- (void)uploadBranchProcessCompleted;

@end
