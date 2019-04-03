//
//  MeetingAttachmentsTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 20/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttachmentsTableViewControllerDelegate <NSObject>

- (NSNumber*)retrieveMeetingAttachmentsTableLocationIUR;
- (NSNumber*)retrieveMeetingAttachmentsMeetingIUR;

@end

