//
//  CustomerDetailsIURTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 06/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsIURTableCell.h"

@implementation CustomerDetailsIURTableCell
@synthesize detail;
@synthesize descrDetailIUR;
@synthesize active;

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
    [super dealloc];
}

@end
