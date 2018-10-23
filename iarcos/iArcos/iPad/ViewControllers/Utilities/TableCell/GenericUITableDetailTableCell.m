//
//  GenericUITableDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 26/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "GenericUITableDetailTableCell.h"

@implementation GenericUITableDetailTableCell
@synthesize attributeName;
@synthesize attributeValue;

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
    if (self.attributeName != nil) {
        self.attributeName = nil;
    }
    if (self.attributeValue != nil) {
        self.attributeValue = nil;
    }
    [super dealloc];
}

@end
