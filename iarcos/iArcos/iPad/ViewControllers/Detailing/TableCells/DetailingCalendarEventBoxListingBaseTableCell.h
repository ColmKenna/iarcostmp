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
#import "LocationCreditStatusDataManager.h"

@interface DetailingCalendarEventBoxListingBaseTableCell : UITableViewCell {
    id<DetailingCalendarEventBoxListingBaseTableCellDelegate> _actionDelegate;
    NSIndexPath* _myIndexPath;
    NSMutableDictionary* _myCellData;
    UILabel* _fieldValueLabel;
    UIButton* _locationStatusButton;
    UIButton* _creditStatusButton;
}

@property (nonatomic, assign) id<DetailingCalendarEventBoxListingBaseTableCellDelegate> actionDelegate;
@property (nonatomic, retain) NSIndexPath* myIndexPath;
@property (nonatomic, retain) NSMutableDictionary* myCellData;
@property (nonatomic,retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, retain) IBOutlet UIButton* locationStatusButton;
@property(nonatomic, retain) IBOutlet UIButton* creditStatusButton;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;
- (void)configCellLocationCreditStatusButtonWithObject:(LocationCreditStatusDataManager*)aLocationCreditStatusDataManager;

@end


