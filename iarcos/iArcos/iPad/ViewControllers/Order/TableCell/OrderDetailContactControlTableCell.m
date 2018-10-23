//
//  OrderDetailContactControlTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 27/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailContactControlTableCell.h"

@implementation OrderDetailContactControlTableCell
@synthesize controlLabel = _controlLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.controlLabel != nil) { self.controlLabel = nil; }        
    
    [super dealloc];
}

@end
