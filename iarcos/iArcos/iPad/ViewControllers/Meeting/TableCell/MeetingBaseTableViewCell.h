//
//  MeetingBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingCellKeyDefinition.h"
#import "MeetingBaseTableViewCellDelegate.h"
#import "ArcosAttendeeWithDetails.h"

@interface MeetingBaseTableViewCell : UITableViewCell {
    id<MeetingBaseTableViewCellDelegate> _actionDelegate;
    MeetingCellKeyDefinition* _meetingCellKeyDefinition;
    NSMutableDictionary* _cellData;
    NSIndexPath* _myIndexPath;
//    ArcosAttendeeWithDetails* _arcosAttendeeWithDetails;
}

@property(nonatomic, assign) id<MeetingBaseTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) MeetingCellKeyDefinition* meetingCellKeyDefinition;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* myIndexPath;
//@property(nonatomic, retain) ArcosAttendeeWithDetails* arcosAttendeeWithDetails;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;
//- (void)configCellWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails;


@end

