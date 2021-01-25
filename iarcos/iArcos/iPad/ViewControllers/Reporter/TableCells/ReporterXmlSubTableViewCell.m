//
//  ReporterXmlSubTableViewCell.m
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlSubTableViewCell.h"

@implementation ReporterXmlSubTableViewCell
@synthesize countLabel = _countLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize qtyLabel = _qtyLabel;
@synthesize valueLabel = _valueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.countLabel = nil;
    self.descriptionLabel = nil;
    self.qtyLabel = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

@end
