//
//  CustomerBooleanTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerBooleanTableCell.h"

@implementation CustomerBooleanTableCell

@synthesize fieldDesc;
@synthesize contentString;

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

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.redAsterixLabel.hidden = YES;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
//    self.contentString.on = [[theData objectForKey:@"contentString"] boolValue];    
    self.contentString.on = [[theData objectForKey:@"contentString"] isEqualToString:@"1"] ? YES : NO;
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    /*
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
    } else {
        self.contentString.enabled = NO;
    }
     */
    self.contentString.enabled = YES;
    if ([securityLevel intValue] == [GlobalSharedClass shared].blockedLevel) {
        self.contentString.enabled = NO;
    } else if ([securityLevel intValue] == [GlobalSharedClass shared].mandatoryLevel) {
        [self configRedAsterix];
    }
}

-(IBAction)switchValueChange:(id)sender{
    UISwitch* sw=(UISwitch*)sender;
    NSString* returnValue = sw.on ? @"1" : @"0";
    [self.delegate inputFinishedWithData:returnValue actualData:returnValue forIndexpath:self.indexPath];
}

- (void)dealloc
{
    if (self.fieldDesc != nil) {
        self.fieldDesc = nil;
    }
    if (self.contentString != nil) {
        self.contentString = nil;
    }
    [super dealloc];
}

@end
