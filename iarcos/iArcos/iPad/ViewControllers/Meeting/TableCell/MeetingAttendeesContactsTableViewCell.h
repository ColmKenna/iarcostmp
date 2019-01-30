//
//  MeetingAttendeesContactsTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 25/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MeetingAttendeesContactsTableViewCell : UITableViewCell {
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end


