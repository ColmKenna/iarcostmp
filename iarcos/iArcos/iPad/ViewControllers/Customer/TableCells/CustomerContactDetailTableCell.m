//
//  CustomerContactDetailTableCell.m
//  iArcos
//
//  Created by Richard on 12/10/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDetailTableCell.h"

@implementation CustomerContactDetailTableCell
@synthesize nameLabel = _nameLabel;
@synthesize addressLabel = _addressLabel;
@synthesize cP09Button = _cP09Button;
@synthesize cP10Button = _cP10Button;
@synthesize dateLabel = _dateLabel;
@synthesize memoTextView = _memoTextView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.nameLabel = nil;
    self.addressLabel = nil;
    self.cP09Button = nil;
    self.cP10Button = nil;
    self.dateLabel = nil;
    self.memoTextView = nil;
    
    [super dealloc];
}

@end
