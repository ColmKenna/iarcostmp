//
//  OrderlinesIarcosQtyDiscTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosQtyDiscTableViewCell.h"

@implementation OrderlinesIarcosQtyDiscTableViewCell
@synthesize qtyDiscView = _qtyDiscView;
@synthesize qtyDiscImageView = _qtyDiscImageView;
@synthesize qtyInQtyDiscView = _qtyInQtyDiscView;
@synthesize discInQtyDiscView = _discInQtyDiscView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.qtyInQtyDiscView = nil;
    self.qtyDiscImageView = nil;
    self.discInQtyDiscView = nil;
    self.qtyDiscView = nil;
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    [super configCellWithData:theData];
    self.qtyInQtyDiscView.text = [[theData objectForKey:@"Qty"]stringValue];
    self.discInQtyDiscView.text = [NSString stringWithFormat:@"%1.1f%%",[[theData objectForKey:@"DiscountPercent"]floatValue]];
}

@end
