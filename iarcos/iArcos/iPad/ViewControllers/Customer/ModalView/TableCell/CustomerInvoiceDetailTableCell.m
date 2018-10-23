//
//  CustomerInvoiceDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 29/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerInvoiceDetailTableCell.h"


@implementation CustomerInvoiceDetailTableCell
@synthesize qty;
@synthesize bonusQty;
@synthesize description;
@synthesize value;

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
    if (self.qty != nil) {
        self.qty = nil;
    }
    if (self.bonusQty != nil) {
        self.bonusQty = nil;
    }
    if (self.description != nil) {
        self.description = nil;
    }
    if (self.value != nil) {
        self.value = nil;
    }
    [super dealloc];
}

@end
