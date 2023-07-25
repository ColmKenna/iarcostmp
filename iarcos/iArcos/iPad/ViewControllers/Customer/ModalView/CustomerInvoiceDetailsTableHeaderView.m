//
//  CustomerInvoiceDetailsTableHeaderView.m
//  iArcos
//
//  Created by Richard on 25/07/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "CustomerInvoiceDetailsTableHeaderView.h"

@implementation CustomerInvoiceDetailsTableHeaderView
@synthesize qtyLabel = _qtyLabel;
@synthesize bonLabel = _bonLabel;
@synthesize descLabel = _descLabel;
@synthesize valueLabel = _valueLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.qtyLabel = nil;
    self.bonLabel = nil;
    self.descLabel = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

@end
