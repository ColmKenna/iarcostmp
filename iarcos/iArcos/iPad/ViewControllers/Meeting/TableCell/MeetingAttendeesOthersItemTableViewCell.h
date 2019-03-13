//
//  MeetingAttendeesOthersItemTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 08/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttendeesOthersItemTableViewCellDelegate.h"

@interface MeetingAttendeesOthersItemTableViewCell : UITableViewCell <UITextFieldDelegate>{
    id<MeetingAttendeesOthersItemTableViewCellDelegate> _actionDelegate;
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, assign) id<MeetingAttendeesOthersItemTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end
