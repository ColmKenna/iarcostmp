//
//  ReportOrderHeaderView.m
//  iArcos
//
//  Created by Richard on 05/05/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ReportOrderHeaderView.h"

@implementation ReportOrderHeaderView
@synthesize locationLabel = _locationLabel;
@synthesize employeeLabel = _employeeLabel;
@synthesize orderDateLabel = _orderDateLabel;
@synthesize deliveryDateLabel = _deliveryDateLabel;
@synthesize goodsLabel = _goodsLabel;
@synthesize vatLabel = _vatLabel;
@synthesize totalLabel = _totalLabel;


- (void)dealloc {
    self.locationLabel = nil;
    self.employeeLabel = nil;
    self.orderDateLabel = nil;
    self.deliveryDateLabel = nil;
    self.goodsLabel = nil;
    self.vatLabel = nil;
    self.totalLabel = nil;
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
