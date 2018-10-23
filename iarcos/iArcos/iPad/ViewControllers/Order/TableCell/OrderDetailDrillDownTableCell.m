//
//  OrderDetailDrillDownTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 04/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailDrillDownTableCell.h"

@implementation OrderDetailDrillDownTableCell
@synthesize drillDownLabel = _drillDownLabel;
@synthesize isEventSet = _isEventSet;

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
    if (self.drillDownLabel != nil) { self.drillDownLabel = nil; }        
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.drillDownLabel.text = [theData objectForKey:@"FieldNameLabel"];
    if (!self.isEventSet) {
        self.isEventSet = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.contentView addGestureRecognizer:singleTap];
        [singleTap release];
    }
}

-(void)handleSingleTapGesture:(id)sender {
    NSNumber* orderHeaderType = [self.cellData objectForKey:@"OrderHeaderType"];
    if ([orderHeaderType intValue] == 1) {//Order
        [self.delegate showOrderlineDetailsDelegate];
    } else if ([orderHeaderType intValue] == 2) {
        [self.delegate showCallDetailsDelegate];
    }
}

@end
