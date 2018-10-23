//
//  UtilitiesDescriptionDetailEditBoolTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailEditBoolTableCell.h"

@implementation UtilitiesDescriptionDetailEditBoolTableCell
@synthesize narrative = _narrative;
@synthesize contentSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.narrative = nil;
    if (self.contentSwitch != nil) { self.contentSwitch = nil; }            
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    self.cellData = theData;
    NSNumber* actualContent = [theData objectForKey:@"actualContent"];
    if ([actualContent intValue] == 1) {
        self.contentSwitch.on = YES;
    } else {
        self.contentSwitch.on = NO;
    }
}

-(IBAction)switchValueChange:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    NSNumber* returnValue = sw.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    [self.delegate inputFinishedWithData:returnValue actualContent:returnValue WithIndexPath:self.indexPath];
}

@end
