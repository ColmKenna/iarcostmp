//
//  CustomerCallTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerCallTableCell.h"


@implementation CustomerCallTableCell
@synthesize date;
@synthesize contact;
@synthesize employee;
@synthesize typeOfCall;
@synthesize value;
@synthesize IUR;

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

- (void)dealloc
{
    if (self.date != nil) {
        self.date = nil;
    }
    if (self.contact != nil) {
        self.contact = nil;
    }
    if (self.employee != nil) {
        self.employee = nil;
    }
    if (self.typeOfCall != nil) {
        self.typeOfCall = nil;
    }
    if (self.value != nil) {
        self.value = nil;
    }
    if (self.IUR != nil) {
        self.IUR = nil;
    }
    [super dealloc];
//    [date release];
//    [contact release];
//    [employee release];
//    [typeOfCall release];
//    [value release];
}

@end
