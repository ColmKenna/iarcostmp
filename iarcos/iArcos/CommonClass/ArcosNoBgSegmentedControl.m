//
//  ArcosNoBgSegmentedControl.m
//  iArcos
//
//  Created by Richard on 12/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ArcosNoBgSegmentedControl.h"

@implementation ArcosNoBgSegmentedControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor clearColor];
}
*/
- (instancetype)initWithItems:(nullable NSArray *)items {
    self = [super initWithItems:items];
    if (self != nil) {
        UIImage* segmentedBgImage = [UIImage imageNamed:@"segmentedbg.png"];
        UIImage* segmentedDividerBgImage = [UIImage imageNamed:@"segmenteddividerbg.png"];
        [self setBackgroundImage:segmentedBgImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setDividerImage:segmentedDividerBgImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    return self;
}

@end
