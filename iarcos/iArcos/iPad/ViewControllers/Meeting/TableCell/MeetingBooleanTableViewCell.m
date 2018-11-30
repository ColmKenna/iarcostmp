//
//  MeetingBooleanTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 29/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBooleanTableViewCell.h"

@implementation MeetingBooleanTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize yesButton = _yesButton;
@synthesize yesLabel = _yesLabel;
@synthesize noButton = _noButton;
@synthesize noLabel = _noLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.yesButton = nil;
    self.yesLabel = nil;
    self.noButton = nil;
    self.noLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
    NSNumber* fieldData = [aCellData objectForKey:@"FieldData"];
    if ([fieldData boolValue]) {
        [self yesButtonPressedProcessor];
    } else {
        [self noButtonPressedProcessor];
    }
}

- (void)yesButtonPressedProcessor {
    [self.yesButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
    [self.noButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
}

- (void)noButtonPressedProcessor {
    [self.yesButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    [self.noButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
}

- (IBAction)yesButtonPressed:(id)sender {
    [self yesButtonPressedProcessor];
    [self.actionDelegate meetingBaseInputFinishedWithData:[NSNumber numberWithBool:YES] atIndexPath:self.myIndexPath];
}

- (IBAction)noButtonPressed:(id)sender {
    [self noButtonPressedProcessor];
    [self.actionDelegate meetingBaseInputFinishedWithData:[NSNumber numberWithBool:NO] atIndexPath:self.myIndexPath];
}

@end
