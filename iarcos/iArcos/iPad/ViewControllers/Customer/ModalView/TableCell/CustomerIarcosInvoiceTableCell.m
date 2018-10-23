//
//  CustomerIarcosInvoiceTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosInvoiceTableCell.h"

@implementation CustomerIarcosInvoiceTableCell
@synthesize dateLabel = _dateLabel;
@synthesize referenceLabel = _referenceLabel;
@synthesize wholesalerLabel = _wholesalerLabel;
@synthesize typeLabel = _typeLabel;
@synthesize employeeLabel = _employeeLabel;
@synthesize valueLabel = _valueLabel;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.dateLabel = nil;
    self.referenceLabel = nil;
    self.wholesalerLabel = nil;
    self.typeLabel = nil;
    self.employeeLabel = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

@end
