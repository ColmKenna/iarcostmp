//
//  ReportCallHeaderView.m
//  iArcos
//
//  Created by Richard on 18/08/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ReportCallHeaderView.h"

@implementation ReportCallHeaderView
@synthesize locationLabel = _locationLabel;
@synthesize employeeLabel = _employeeLabel;
@synthesize valueLabel = _valueLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.locationLabel = nil;
    self.employeeLabel = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

@end
