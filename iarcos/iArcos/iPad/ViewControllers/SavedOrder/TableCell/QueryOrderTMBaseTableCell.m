//
//  QueryOrderTMBaseTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 29/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTMBaseTableCell.h"

@implementation QueryOrderTMBaseTableCell
@synthesize delegate = _delegate;
@synthesize cellData;
@synthesize indexPath;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize locationIUR = _locationIUR;
@synthesize locationName = _locationName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
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
    self.locationIUR = nil;
    self.locationName = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)theData{
    
}

@end
