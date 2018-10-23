//
//  OrderDetailIArcosDrillDownTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderDetailIArcosDrillDownTableCell.h"

@implementation OrderDetailIArcosDrillDownTableCell
@synthesize drillDownButton = _drillDownButton;
@synthesize drillDownLabel = _drillDownLabel;
@synthesize isEventSet = _isEventSet;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.drillDownButton = nil;
    if (self.drillDownLabel != nil) { self.drillDownLabel = nil; }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    NSNumber* tmpOrderHeaderType = [self.cellData objectForKey:@"OrderHeaderType"];
    if ([tmpOrderHeaderType intValue] == 1 || [tmpOrderHeaderType intValue] == 3) {
        [self.drillDownButton setImage:[UIImage imageNamed:@"Orderlines.png"] forState:UIControlStateNormal];
    } else {//call
        [self.drillDownButton setImage:[UIImage imageNamed:@"Call.png"] forState:UIControlStateNormal];
    }
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
    } else if ([orderHeaderType intValue] == 3) {
        [self.delegate showRemoteOrderlineDetailsDelegate];
    } else if ([orderHeaderType intValue] == 4) {
        [self.delegate showRemoteCallDetailsDelegate];
    }
}

@end
