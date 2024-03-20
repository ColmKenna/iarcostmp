//
//  DetailingCalendarEventBoxListingBaseTableCell.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "DetailingCalendarEventBoxListingBaseTableCellDelegate.h"

@interface DetailingCalendarEventBoxListingBaseTableCell : UITableViewCell {
    id<DetailingCalendarEventBoxListingBaseTableCellDelegate> _actionDelegate;
    NSIndexPath* _myIndexPath;
    NSMutableDictionary* _myCellData;
    UILabel* _fieldValueLabel;
}

@property (nonatomic, assign) id<DetailingCalendarEventBoxListingBaseTableCellDelegate> actionDelegate;
@property (nonatomic, retain) NSIndexPath* myIndexPath;
@property (nonatomic, retain) NSMutableDictionary* myCellData;
@property (nonatomic,retain) IBOutlet UILabel* fieldValueLabel;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end


