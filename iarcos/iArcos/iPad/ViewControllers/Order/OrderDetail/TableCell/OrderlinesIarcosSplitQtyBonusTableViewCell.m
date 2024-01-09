//
//  OrderlinesIarcosSplitQtyBonusTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosSplitQtyBonusTableViewCell.h"

@implementation OrderlinesIarcosSplitQtyBonusTableViewCell
@synthesize splitQtyBonusView = _splitQtyBonusView;
@synthesize splitQtyBonusImageView = _splitQtyBonusImageView;
@synthesize qtyInSplitQtyBonusView = _qtyInSplitQtyBonusView;
@synthesize bonusInSplitQtyBonusView = _bonusInSplitQtyBonusView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.qtyInSplitQtyBonusView = nil;
    self.splitQtyBonusImageView = nil;
    self.bonusInSplitQtyBonusView = nil;
    self.splitQtyBonusView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    [super configCellWithData:theData];
    self.qtyInSplitQtyBonusView.text = [[theData objectForKey:@"units"] stringValue];
    self.bonusInSplitQtyBonusView.text = [[theData objectForKey:@"FOC"] stringValue];
}

@end
