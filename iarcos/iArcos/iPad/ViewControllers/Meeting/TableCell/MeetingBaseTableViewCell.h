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

@interface MeetingBaseTableViewCell : UITableViewCell {
    id<MeetingBaseTableViewCellDelegate> _actionDelegate;
    MeetingCellKeyDefinition* _meetingCellKeyDefinition;
}

@property(nonatomic, assign) id<MeetingBaseTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) MeetingCellKeyDefinition* meetingCellKeyDefinition;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end

