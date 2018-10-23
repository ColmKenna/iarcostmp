//
//  QueryOrderMemoBooleanTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderMemoBooleanTableCell.h"

@implementation QueryOrderMemoBooleanTableCell
@synthesize fieldDesc = _fieldDesc;
@synthesize contentString = _contentString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.fieldDesc = nil;
    self.contentString = nil;
    
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
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

-(IBAction)switchValueChange:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    NSString* returnValue = sw.on ? @"1" : @"0";
    [self.delegate inputFinishedWithData:returnValue actualData:returnValue forIndexpath:self.indexPath];
}

@end
