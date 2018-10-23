//
//  CustomerSurveyDetailsSectionHeader.m
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsSectionHeader.h"

@implementation CustomerSurveyDetailsSectionHeader
@synthesize narrative = _narrative;

- (void)dealloc {
    self.narrative = nil;
    
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
