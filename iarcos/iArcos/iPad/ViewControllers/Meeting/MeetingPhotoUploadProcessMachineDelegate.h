//
//  MeetingPhotoUploadProcessMachineDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingPhotoUploadProcessMachineDelegate <NSObject>

- (void)photoUploadStartedWithText:(NSString*)aText;
- (void)photoUploadCompleted;

@end

