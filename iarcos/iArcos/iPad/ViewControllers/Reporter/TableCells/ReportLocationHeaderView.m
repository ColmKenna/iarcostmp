//
//  ReportLocationHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 19/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportLocationHeaderView.h"

@implementation ReportLocationHeaderView
@synthesize locationLabel = _locationLabel;
@synthesize contactLabel = _contactLabel;
@synthesize typeLabel = _typeLabel;
@synthesize lastCallLabel = _lastCallLabel;
@synthesize lastOrderLabel = _lastOrderLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.locationLabel = nil;
    self.contactLabel = nil;
    self.typeLabel = nil;
    self.lastCallLabel = nil;
    self.lastOrderLabel = nil;
    
    [super dealloc];
}

@end
