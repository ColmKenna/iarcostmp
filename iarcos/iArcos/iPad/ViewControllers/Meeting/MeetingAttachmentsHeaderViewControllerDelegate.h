//
//  MeetingAttachmentsHeaderViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttachmentsHeaderViewControllerDelegate <NSObject>

- (UIViewController*)retrieveParentViewController;
- (NSNumber*)retrieveMeetingAttachmentsHeaderLocationIUR;
- (void)addMeetingAttachmentsRecordWithFileName:(NSString*)aFileName;

@end

