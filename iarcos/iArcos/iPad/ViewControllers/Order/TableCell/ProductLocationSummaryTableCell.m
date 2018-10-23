//
//  ProductLocationSummaryTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 04/02/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "ProductLocationSummaryTableCell.h"

@implementation ProductLocationSummaryTableCell
@synthesize label0;
@synthesize label1;
@synthesize label2;
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

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.label0 = nil;
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    self.label6 = nil;
    self.label7 = nil;
    self.label8 = nil;
    self.label9 = nil;
    self.label10 = nil;
    self.label11 = nil;
    self.label12 = nil;
    self.label13 = nil;
    [super dealloc];
}

@end
