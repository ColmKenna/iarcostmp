//
//  UtilitiesTablesDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesTablesDetailTableCell.h"

@implementation UtilitiesTablesDetailTableCell
@synthesize tableName;
@synthesize recordQuantity;
@synthesize cellData;
@synthesize indexPath;

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
    self.tableName = nil;
    self.recordQuantity = nil;
    self.cellData = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

@end
