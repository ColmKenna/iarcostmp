//
//  MeetingAttendeesContactsHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 23/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactSelectionListingTableViewController.h"
#import "MeetingAttendeesContactsHeaderViewControllerDelegate.h"
#import "CustomerGroupDataManager.h"


@interface MeetingAttendeesContactsHeaderViewController : UIViewController <ContactSelectionListingTableViewControllerDelegate> {
    id<MeetingAttendeesContactsHeaderViewControllerDelegate> _actionDelegate;
    UIButton* _addButton;
    CustomerGroupDataManager* _customerGroupDataManager;
}

@property(nonatomic, assign) id<MeetingAttendeesContactsHeaderViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* addButton;
@property(nonatomic, retain) CustomerGroupDataManager* customerGroupDataManager;

- (IBAction)addButtonPressed:(id)sender;

@end

