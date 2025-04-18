//
//  MeetingAttachmentsTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttachmentsTableViewCellDelegate <NSObject>

- (void)meetingAttachmentsViewButtonPressedWithFileName:(NSString*)aFileName atIndexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttachmentsRevertDeleteActionWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttachmentsDeleteFinishedWithData:(ArcosAttachmentSummary*)anArcosAttachmentSummary atIndexPath:(NSIndexPath*)anIndexPath;

@end

