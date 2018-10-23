//
//  CustomerTyvLyTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 15/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerTyvLyTableCell.h"

@implementation CustomerTyvLyTableCell

@synthesize orderPadDetails;
@synthesize productCode;
@synthesize productSize;
@synthesize details;
@synthesize lYQty;
@synthesize lYBonus;
@synthesize lYValue;
@synthesize lYTDQty;
@synthesize lYTDBonus;
@synthesize lYTDValue;
@synthesize tYTDQty;
@synthesize tYTDBonus;
@synthesize tYTDValue;
@synthesize qty;


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
    if (self.orderPadDetails != nil) { self.orderPadDetails = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.productSize != nil) { self.productSize = nil; }
    if (self.details != nil) { self.details = nil; }
    if (self.lYQty != nil) { self.lYQty = nil; }
    if (self.lYBonus != nil) { self.lYBonus = nil; }
    if (self.lYValue != nil) { self.lYValue = nil; }    
    
    if (self.lYTDQty != nil) { self.lYTDQty = nil; }
    if (self.lYTDBonus != nil) { self.lYTDBonus = nil; }
    if (self.lYTDValue != nil) { self.lYTDValue = nil; }
    
    if (self.tYTDQty != nil) { self.tYTDQty = nil; }    
    if (self.tYTDBonus != nil) { self.tYTDBonus = nil; }
    if (self.tYTDValue != nil) { self.tYTDValue = nil; }
    if (self.qty != nil) { self.qty = nil; }
    
    
    [super dealloc];
}


@end
