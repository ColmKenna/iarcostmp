//
//  OrderlinesIarcosQtyBonusTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosQtyBonusTableViewCell.h"

@implementation OrderlinesIarcosQtyBonusTableViewCell
@synthesize qtyBonusView = _qtyBonusView;
@synthesize qtyBonusImageView = _qtyBonusImageView;
@synthesize qtyInQtyBonusView = _qtyInQtyBonusView;
@synthesize bonusInQtyBonusView = _bonusInQtyBonusView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.qtyBonusView = nil;
    self.qtyBonusImageView = nil;
    self.qtyInQtyBonusView = nil;
    self.bonusInQtyBonusView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    [super configCellWithData:theData];
    self.qtyInQtyBonusView.text = [[theData objectForKey:@"Qty"]stringValue];
    self.bonusInQtyBonusView.text = [[theData objectForKey:@"Bonus"]stringValue];
}

@end
