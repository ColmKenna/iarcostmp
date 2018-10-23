//
//  OrderlinesIarcosSplitQtyTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosSplitQtyTableViewCell.h"

@implementation OrderlinesIarcosSplitQtyTableViewCell
@synthesize splitQtyView = _splitQtyView;
@synthesize qtyInSplitQtyView = _qtyInSplitQtyView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.qtyInSplitQtyView = nil;
    self.splitQtyView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    [super configCellWithData:theData];
    self.qtyInSplitQtyView.text = [[theData objectForKey:@"InStock"] stringValue];
}

@end
