//
//  UtilitiesConfigurationTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 23/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "UtilitiesConfigurationTableCell.h"

@implementation UtilitiesConfigurationTableCell
@synthesize detail = _detail;
@synthesize tooltip = _tooltip;
@synthesize toggleSwitch = _toggleSwitch;
@synthesize myDelegate = _myDelegate;
@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.detail = nil;
    self.tooltip = nil;
    self.toggleSwitch = nil;
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (IBAction)updateSwitchValue:(id)sender {
    [self.myDelegate inputFinishedWithData:[NSNumber numberWithBool:self.toggleSwitch.on] forIndexpath:self.myIndexPath];
}

@end
