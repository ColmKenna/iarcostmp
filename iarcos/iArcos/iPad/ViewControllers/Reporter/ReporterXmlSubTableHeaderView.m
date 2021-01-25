//
//  ReporterXmlSubTableHeaderView.m
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlSubTableHeaderView.h"

@implementation ReporterXmlSubTableHeaderView
@synthesize countLabel = _countLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize qtyLabel = _qtyLabel;
@synthesize valueLabel = _valueLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.countLabel = nil;
    self.descriptionLabel = nil;
    self.qtyLabel = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

@end
