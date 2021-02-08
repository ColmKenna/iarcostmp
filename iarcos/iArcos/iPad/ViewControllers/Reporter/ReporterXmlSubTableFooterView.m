//
//  ReporterXmlSubTableFooterView.m
//  iArcos
//
//  Created by Richard on 06/02/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlSubTableFooterView.h"

@implementation ReporterXmlSubTableFooterView
@synthesize countSumLabel = _countSumLabel;
@synthesize totalLabel = _totalLabel;
@synthesize qtySumLabel = _qtySumLabel;
@synthesize valueSumLabel = _valueSumLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.countSumLabel = nil;
    self.totalLabel = nil;
    self.qtySumLabel = nil;
    self.valueSumLabel = nil;
    
    [super dealloc];
}

@end
