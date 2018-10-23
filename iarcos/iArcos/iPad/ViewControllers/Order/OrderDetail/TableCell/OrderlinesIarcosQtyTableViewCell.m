//
//  OrderlinesIarcosQtyTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosQtyTableViewCell.h"

@implementation OrderlinesIarcosQtyTableViewCell
@synthesize normalQtyView = _normalQtyView;
@synthesize qtyInNormalQtyView = _qtyInNormalQtyView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.qtyInNormalQtyView = nil;
    self.normalQtyView = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    [super configCellWithData:theData];
    self.qtyInNormalQtyView.text = [[theData objectForKey:@"Qty"]stringValue];
}

@end
