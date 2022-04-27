//
//  ArcosCalendarTableHeaderView.m
//  iArcos
//
//  Created by Richard on 29/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarTableHeaderView.h"

@implementation ArcosCalendarTableHeaderView
@synthesize monLabel = _monLabel;
@synthesize tueLabel = _tueLabel;
@synthesize wedLabel = _wedLabel;
@synthesize thuLabel = _thuLabel;
@synthesize friLabel = _friLabel;
@synthesize satLabel = _satLabel;
@synthesize sunLabel = _sunLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.monLabel = nil;
    self.tueLabel = nil;
    self.wedLabel = nil;
    self.thuLabel = nil;
    self.friLabel = nil;
    self.satLabel = nil;
    self.sunLabel = nil;    
    
    [super dealloc];
}

@end
