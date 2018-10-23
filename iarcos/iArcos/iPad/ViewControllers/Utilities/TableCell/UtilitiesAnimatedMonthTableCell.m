//
//  UtilitiesAnimatedMonthTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 06/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesAnimatedMonthTableCell.h"

@implementation UtilitiesAnimatedMonthTableCell

@synthesize orderPadDetails;
@synthesize productCode;
@synthesize productSize;
@synthesize labelDetails;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;
@synthesize label7;
@synthesize label8;
@synthesize label9;
@synthesize label10;
@synthesize label11;
@synthesize label12;
@synthesize label13;
@synthesize label14;
@synthesize label15;
@synthesize label16;

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
    if (self.orderPadDetails != nil) { self.orderPadDetails = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.productSize != nil) { self.productSize = nil; }
    if (self.labelDetails != nil) { self.labelDetails = nil; }
    if (self.label3 != nil) { self.label3 = nil; }
    if (self.label4 != nil) { self.label4 = nil; }
    if (self.label5 != nil) { self.label5 = nil; }
    if (self.label6 != nil) { self.label6 = nil; }
    if (self.label7 != nil) { self.label7 = nil; }
    if (self.label8 != nil) { self.label8 = nil; }
    if (self.label9 != nil) { self.label9 = nil; }
    if (self.label10 != nil) { self.label10 = nil; }
    if (self.label11 != nil) { self.label11 = nil; }
    if (self.label12 != nil) { self.label12 = nil; }
    if (self.label13 != nil) { self.label13 = nil; }
    if (self.label14 != nil) { self.label14 = nil; }    
    if (self.label15 != nil) { self.label15 = nil; }
    if (self.label16 != nil) { self.label16 = nil; }
    
    [super dealloc];
}

@end
