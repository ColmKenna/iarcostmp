//
//  CustomerCallDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerCallDetailTableCell.h"


@implementation CustomerCallDetailTableCell
@synthesize description;
@synthesize details;

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

- (void)dealloc
{
    if (self.description != nil) {
        self.description = nil;
    }
    if (self.details != nil) {
        self.details = nil;
    }
    [super dealloc];
}

@end
