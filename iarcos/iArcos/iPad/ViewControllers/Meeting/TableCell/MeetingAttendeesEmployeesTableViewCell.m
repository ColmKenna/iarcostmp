//
//  MeetingAttendeesEmployeesTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 24/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesEmployeesTableViewCell.h"

@implementation MeetingAttendeesEmployeesTableViewCell
@synthesize fieldValueLabel = _fieldValueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldValueLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueLabel.text = [aCellData objectForKey:@"Title"];
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

//- (void)configCellWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails {
//    [super configCellWithArcosAttendeeWithDetails:anArcosAttendeeWithDetails];
//    self.fieldValueLabel.text = anArcosAttendeeWithDetails.Name;
//    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
//        [self.fieldValueLabel removeGestureRecognizer:recognizer];
//    }
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//    [self.fieldValueLabel addGestureRecognizer:singleTap];
//    [singleTap release];
//}

- (void)handleSingleTapGesture:(id)sender {
    [self.actionDelegate meetingAttendeeEmployeeSelectFinishedWithData:self.cellData atIndexPath:self.myIndexPath];
}

@end
