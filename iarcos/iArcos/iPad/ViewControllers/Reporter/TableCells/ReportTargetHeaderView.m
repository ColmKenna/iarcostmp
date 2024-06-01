//
//  ReportTargetHeaderView.m
//  iArcos
//
//  Created by Richard on 23/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ReportTargetHeaderView.h"

@implementation ReportTargetHeaderView
@synthesize descriptionLabel = _descriptionLabel;
@synthesize q1TargetLabel = _q1TargetLabel;
@synthesize q1ActualLabel = _q1ActualLabel;
@synthesize q1PercentageLabel = _q1PercentageLabel;
@synthesize q2TargetLabel = _q2TargetLabel;
@synthesize q2ActualLabel = _q2ActualLabel;
@synthesize q2PercentageLabel = _q2PercentageLabel;
@synthesize q3TargetLabel = _q3TargetLabel;
@synthesize q3ActualLabel = _q3ActualLabel;
@synthesize q3PercentageLabel = _q3PercentageLabel;
@synthesize q4TargetLabel = _q4TargetLabel;
@synthesize q4ActualLabel = _q4ActualLabel;
@synthesize q4PercentageLabel = _q4PercentageLabel;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.descriptionLabel = nil;
    self.q1TargetLabel = nil;
    self.q1ActualLabel = nil;
    self.q1PercentageLabel = nil;
    self.q2TargetLabel = nil;
    self.q2ActualLabel = nil;
    self.q2PercentageLabel = nil;
    self.q3TargetLabel = nil;
    self.q3ActualLabel = nil;
    self.q3PercentageLabel = nil;
    self.q4TargetLabel = nil;
    self.q4ActualLabel = nil;
    self.q4PercentageLabel = nil;
    
    [super dealloc];
}

@end
