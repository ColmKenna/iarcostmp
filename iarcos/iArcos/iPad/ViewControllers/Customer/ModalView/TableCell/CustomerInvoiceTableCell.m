//
//  CustomerInvoiceTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerInvoiceTableCell.h"


@implementation CustomerInvoiceTableCell
@synthesize date;
@synthesize reference;
@synthesize wholesaler;
@synthesize type;
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
    if (self.reference != nil) {
        self.reference = nil;         
    }
    if (self.wholesaler != nil) {
        self.wholesaler = nil;         
    }
    if (self.type != nil) {
        self.type = nil;
    }
    if (self.value != nil) {
        self.value = nil;         
    }
    if (self.IUR != nil) {
        self.IUR = nil;         
    }
    [super dealloc];
//    [date release];
//    [reference release];
//    [wholesaler release];
//    [value release];
}

@end
