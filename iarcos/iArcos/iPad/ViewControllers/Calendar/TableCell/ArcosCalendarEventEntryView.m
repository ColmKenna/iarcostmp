//
//  ArcosCalendarEventEntryView.m
//  iArcos
//
//  Created by Richard on 19/01/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryView.h"

@implementation ArcosCalendarEventEntryView
@synthesize mainContentLabel = _mainContentLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.mainContentLabel = nil;
    
    [super dealloc];
}

@end
