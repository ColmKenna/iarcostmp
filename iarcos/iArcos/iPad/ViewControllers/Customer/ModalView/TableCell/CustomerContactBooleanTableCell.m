//
//  CustomerContactBooleanTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactBooleanTableCell.h"

@implementation CustomerContactBooleanTableCell
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
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];    
    self.contentString.on = [[theData objectForKey:@"contentString"] isEqualToString:@"1"] ? YES : NO;
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
    } else {
        self.contentString.enabled = NO;
    }    
}

-(void)switchValueChange:(id)sender{
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
