//
//  Meeting.h
//  iArcos
//
//  Created by David Kilmartin on 09/10/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meeting : NSManagedObject

@property (nonatomic, retain) NSNumber * AgendaIUR;
@property (nonatomic, retain) NSNumber * approvedByIUR;
@property (nonatomic, retain) NSString * attachments;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSDate * DateTime;
@property (nonatomic, retain) NSNumber * Duration;
@property (nonatomic, retain) NSNumber * estimatedAttendees;
@property (nonatomic, retain) NSNumber * estimatedCost;
@property (nonatomic, retain) NSDecimalNumber * estimatedCostPerHead;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * l4iur;
@property (nonatomic, retain) NSNumber * l5iur;
@property (nonatomic, retain) NSNumber * locationIUR;
@property (nonatomic, retain) NSNumber * mOiur;
@property (nonatomic, retain) NSNumber * mPiur;
@property (nonatomic, retain) NSNumber * mSiur;
@property (nonatomic, retain) NSNumber * mYiur;
@property (nonatomic, retain) NSNumber * OrganiserIUR;
@property (nonatomic, retain) NSNumber * postMeetingMemoIUR;
@property (nonatomic, retain) NSNumber * preMeetingMemoIUR;
@property (nonatomic, retain) NSString * Reason;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * Status;
@property (nonatomic, retain) NSString * Venue;
@property (nonatomic, retain) NSNumber * speakerAgreementMemoIUR;
@property (nonatomic, retain) NSNumber * speakerAgreement;

@end
