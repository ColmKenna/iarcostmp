//
//  CustomerDetailsTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 03/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsTableCell.h"

@implementation CustomerDetailsTableCell
@synthesize fieldDesc;
@synthesize contentString;
@synthesize fieldType;
@synthesize actualContent;
@synthesize originalIndex;

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
