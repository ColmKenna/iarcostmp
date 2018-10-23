//
//  DetailingTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DetailingTableCell.h"


@implementation DetailingTableCell
@synthesize locationIUR = _locationIUR;
@synthesize orderNumber = _orderNumber;
@synthesize locationName = _locationName;

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
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.orderNumber != nil) { self.orderNumber = nil; }
    if (self.locationName != nil) { self.locationName = nil; }
    
    [super dealloc];
}
-(void)configCellWithData:(NSMutableDictionary*)theData{
    
}
-(void)cancelAction{
    
}

- (void)layoutMySubviews:(NSString*)anActionType {
    
}


@end
