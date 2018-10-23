//
//  ProductDetailLevelTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductDetailLevelTableCell.h"

@implementation ProductDetailLevelTableCell
@synthesize levelTitle = _levelTitle;
@synthesize levelValue = _levelValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    if (self.levelTitle != nil) { self.levelTitle = nil; }
    if (self.levelValue != nil) { self.levelValue = nil; }        
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
