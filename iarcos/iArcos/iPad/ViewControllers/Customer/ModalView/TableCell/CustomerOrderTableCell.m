//
//  CustomerOrderTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerOrderTableCell.h"


@implementation CustomerOrderTableCell

@synthesize orderNumber;
@synthesize date;
@synthesize wholesaler;
@synthesize value;
@synthesize delivery;
@synthesize employee;
@synthesize orderIUR;

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
    if (self.orderNumber != nil) { self.orderNumber = nil; }
    if (self.date != nil) { self.date = nil; }
    if (self.wholesaler != nil) { self.wholesaler = nil; }
    if (self.value != nil) { self.value = nil; }    
    if (self.delivery != nil) { self.delivery = nil; }
    if (self.employee != nil) { self.employee = nil; }
    if (self.orderIUR != nil) { self.orderIUR = nil; }
    
    [super dealloc];
}

@end
