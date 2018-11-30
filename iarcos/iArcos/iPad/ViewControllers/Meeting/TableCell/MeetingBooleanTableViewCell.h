//
//  MeetingBooleanTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 29/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingBaseTableViewCell.h"

@interface MeetingBooleanTableViewCell : MeetingBaseTableViewCell {
    UILabel* _fieldNameLabel;
    UIButton* _yesButton;
    UILabel* _yesLabel;
    UIButton* _noButton;
    UILabel* _noLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UIButton* yesButton;
@property(nonatomic, retain) IBOutlet UILabel* yesLabel;
@property(nonatomic, retain) IBOutlet UIButton* noButton;
@property(nonatomic, retain) IBOutlet UILabel* noLabel;

- (IBAction)yesButtonPressed:(id)sender;
- (IBAction)noButtonPressed:(id)sender;

@end

