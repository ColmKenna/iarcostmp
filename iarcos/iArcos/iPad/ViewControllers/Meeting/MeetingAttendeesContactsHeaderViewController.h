//
//  MeetingAttendeesContactsHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 23/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeetingAttendeesContactsHeaderViewController : UIViewController {
    UIButton* _addButton;
}

@property(nonatomic, retain) IBOutlet UIButton* addButton;

- (IBAction)addButtonPressed:(id)sender;

@end

