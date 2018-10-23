//
//  CustomerContactBaseTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 29/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactBaseTableCell.h"

@implementation CustomerContactBaseTableCell
@synthesize delegate;
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

- (void)dealloc
{
    self.cellData = nil;
    self.indexPath = nil;
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    
}
@end
