//
//  ArcosCalendarEventEntryDetailBaseTableViewCell.h
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCalendarEventEntryDetailBaseTableViewCellDelegate.h"


@interface ArcosCalendarEventEntryDetailBaseTableViewCell : UITableViewCell {
    id<ArcosCalendarEventEntryDetailBaseTableViewCellDelegate> _actionDelegate;
    NSIndexPath* _myIndexPath;
    NSMutableDictionary* _cellData;
}

@property(nonatomic, assign) id<ArcosCalendarEventEntryDetailBaseTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) NSIndexPath* myIndexPath;
@property(nonatomic, retain) NSMutableDictionary* cellData;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end


