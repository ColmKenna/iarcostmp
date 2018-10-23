//
//  CustomerInfoCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoCell.h"

@implementation CustomerInfoCell
@synthesize infoTitle;
@synthesize infoValue;

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
    if (self.infoTitle != nil) { self.infoTitle = nil; }
    if (self.infoValue != nil) { self.infoValue = nil; }           
    [super dealloc];
}

@end
