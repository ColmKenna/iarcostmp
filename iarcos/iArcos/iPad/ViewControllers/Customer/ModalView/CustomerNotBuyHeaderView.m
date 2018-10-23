//
//  CustomerNotBuyHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 03/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerNotBuyHeaderView.h"

@implementation CustomerNotBuyHeaderView
@synthesize descriptionTitleLabel = _descriptionTitleLabel;

- (void)dealloc {
    self.descriptionTitleLabel = nil;
    
    [super dealloc];
}

@end
