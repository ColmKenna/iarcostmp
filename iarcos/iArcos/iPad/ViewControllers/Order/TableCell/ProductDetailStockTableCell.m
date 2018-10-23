//
//  ProductDetailStockTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductDetailStockTableCell.h"

@implementation ProductDetailStockTableCell
@synthesize stockTitle = _stockTitle;
@synthesize stockValue = _stockValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    if (self.stockTitle != nil) { self.stockTitle = nil; }
    if (self.stockValue != nil) { self.stockValue = nil; }        
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
