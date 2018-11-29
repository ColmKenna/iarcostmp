//
//  MeetingBudgetBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 27/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingBaseTableViewCellDelegate.h"

@interface MeetingBudgetBaseTableViewCell : UITableViewCell {
    id<MeetingBaseTableViewCellDelegate> _actionDelegate;
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, assign) id<MeetingBaseTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end

