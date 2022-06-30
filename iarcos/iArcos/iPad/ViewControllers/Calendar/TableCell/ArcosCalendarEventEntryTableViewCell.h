//
//  ArcosCalendarEventEntryTableViewCell.h
//  iArcos
//
//  Created by Richard on 11/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "ArcosCalendarEventEntryTableViewCellDelegate.h"

@interface ArcosCalendarEventEntryTableViewCell : UITableViewCell {
    id<ArcosCalendarEventEntryTableViewCellDelegate> _actionDelegate;
    UILabel* _subjectLabel;
    UILabel* _startDateLabel;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, assign) id<ArcosCalendarEventEntryTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* subjectLabel;
@property(nonatomic, retain) IBOutlet UILabel* startDateLabel;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end

