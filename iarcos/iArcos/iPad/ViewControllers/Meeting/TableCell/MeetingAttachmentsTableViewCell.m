//
//  MeetingAttachmentsTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsTableViewCell.h"

@implementation MeetingAttachmentsTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize fileNameLabel = _fileNameLabel;
@synthesize miscLabel = _miscLabel;
@synthesize removeButton = _removeButton;
@synthesize removeActiveButton = _removeActiveButton;
@synthesize viewButton = _viewButton;
@synthesize arcosAttachmentSummary = _arcosAttachmentSummary;
@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fileNameLabel = nil;
    self.miscLabel = nil;
    self.removeButton = nil;
    self.removeActiveButton = nil;
    self.viewButton = nil;
    self.arcosAttachmentSummary = nil;
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithArcosAttachmentSummary:(ArcosAttachmentSummary*)anArcosAttachmentSummary {
    self.arcosAttachmentSummary = anArcosAttachmentSummary;
    self.fileNameLabel.text = anArcosAttachmentSummary.FileName;
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[NSNumber numberWithInt:anArcosAttachmentSummary.EmployeeIUR]];
    NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
    NSString* dateAttached = [ArcosUtils stringFromDate:anArcosAttachmentSummary.DateAttached format:[GlobalSharedClass shared].dateFormat];
    self.miscLabel.text = [NSString stringWithFormat:@"%@ by %@", dateAttached, employeeName];
    if (anArcosAttachmentSummary.EmployeeIUR != [[SettingManager employeeIUR] intValue]) {
        self.removeButton.hidden = YES;
        self.removeActiveButton.hidden = YES;
    } else {
        self.removeButton.hidden = NO;
        self.removeActiveButton.hidden = NO;
        [self configHideRemovedButtonWithPCiur:anArcosAttachmentSummary.PCiur];
    }
    
}

- (IBAction)viewButtonPressed:(id)sender {
    [self.actionDelegate meetingAttachmentsViewButtonPressedWithFileName:self.arcosAttachmentSummary.FileName atIndexPath:self.myIndexPath];
}

- (void)configHideRemovedButtonWithPCiur:(int)aPCiur {
    BOOL aRemovedHideFlag = YES;
    if (aPCiur == -999) {
        aRemovedHideFlag = NO;
    }
    self.removeButton.hidden = aRemovedHideFlag;
    self.removeActiveButton.hidden = !aRemovedHideFlag;
}

- (IBAction)removeButtonPressed:(id)sender {
    self.arcosAttachmentSummary.PCiur = 0;
    [self.actionDelegate meetingAttachmentsRevertDeleteActionWithIndexPath:self.myIndexPath];
}

- (IBAction)removeActionButtonPressed:(id)sender {
    [self.actionDelegate meetingAttachmentsDeleteFinishedWithData:self.arcosAttachmentSummary atIndexPath:self.myIndexPath];
}

@end
