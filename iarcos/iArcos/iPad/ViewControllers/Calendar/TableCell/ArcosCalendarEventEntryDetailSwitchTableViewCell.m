//
//  ArcosCalendarEventEntryDetailSwitchTableViewCell.m
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailSwitchTableViewCell.h"

@implementation ArcosCalendarEventEntryDetailSwitchTableViewCell
@synthesize fieldDescLabel = _fieldDescLabel;
@synthesize fieldValueSwitch = _fieldValueSwitch;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldDescLabel = nil;
    self.fieldValueSwitch = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.fieldDescLabel.text = [aCellData objectForKey:@"FieldDesc"];
    NSString* fieldData = [aCellData objectForKey:@"FieldData"];
    self.fieldValueSwitch.on = [fieldData isEqualToString:@"1"] ? YES : NO;
}

- (IBAction)switchValueChange:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    NSString* returnValue = sw.on ? @"1" : @"0";
    [self.actionDelegate detailBaseInputFinishedWithData:returnValue atIndexPath:self.myIndexPath];
    [self.actionDelegate refreshListWithSwitchReturnValue:returnValue];
}

@end
