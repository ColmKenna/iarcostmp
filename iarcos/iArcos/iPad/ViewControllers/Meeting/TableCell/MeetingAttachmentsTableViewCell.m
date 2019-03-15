//
//  MeetingAttachmentsTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsTableViewCell.h"

@implementation MeetingAttachmentsTableViewCell
@synthesize fileNameLabel = _fileNameLabel;
@synthesize miscLabel = _miscLabel;
@synthesize removeButton = _removeButton;
@synthesize removeActiveButton = _removeActiveButton;
@synthesize viewButton = _viewButton;

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
    
    [super dealloc];
}

- (void)configCellWithArcosAttachmentSummary:(ArcosAttachmentSummary*)anArcosAttachmentSummary {
    self.fileNameLabel.text = anArcosAttachmentSummary.FileName;
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[NSNumber numberWithInt:anArcosAttachmentSummary.EmployeeIUR]];
    NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
    NSString* dateAttached = [ArcosUtils stringFromDate:anArcosAttachmentSummary.DateAttached format:[GlobalSharedClass shared].dateFormat];
    self.miscLabel.text = [NSString stringWithFormat:@"%@ by %@", dateAttached, employeeName];
}

@end
