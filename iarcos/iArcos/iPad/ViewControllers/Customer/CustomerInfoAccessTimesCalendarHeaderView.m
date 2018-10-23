//
//  CustomerInfoAccessTimesCalendarHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesCalendarHeaderView.h"

@implementation CustomerInfoAccessTimesCalendarHeaderView
@synthesize timeLabel = _timeLabel;
@synthesize sunLabel = _sunLabel;
@synthesize monLabel = _monLabel;
@synthesize tueLabel = _tueLabel;
@synthesize wedLabel = _wedLabel;
@synthesize thuLabel = _thuLabel;
@synthesize friLabel = _friLabel;
@synthesize satLabel = _satLabel;

- (void)dealloc {
    self.timeLabel = nil;
    self.sunLabel = nil;
    self.monLabel = nil;
    self.tueLabel = nil;
    self.wedLabel = nil;
    self.thuLabel = nil;
    self.friLabel = nil;
    self.satLabel = nil;
    
    [super dealloc];
}

@end
