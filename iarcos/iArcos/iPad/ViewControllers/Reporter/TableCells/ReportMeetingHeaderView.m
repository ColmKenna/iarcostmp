//
//  ReportMeetingHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 17/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportMeetingHeaderView.h"

@implementation ReportMeetingHeaderView
@synthesize detailsLabel = _detailsLabel;
@synthesize typeLabel = _typeLabel;
@synthesize statusLabel = _statusLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.detailsLabel = nil;
    self.typeLabel = nil;
    self.statusLabel = nil;
    
    [super dealloc];
}

@end
