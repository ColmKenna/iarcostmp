//
//  CustomerNotBuyDetailHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerNotBuyDetailHeaderView.h"

@implementation CustomerNotBuyDetailHeaderView
@synthesize detailsTitleLabel = _detailsTitleLabel;
@synthesize lastOrderedTitleLabel = _lastOrderedTitleLabel;

- (void)dealloc {
    self.detailsTitleLabel = nil;
    self.lastOrderedTitleLabel = nil;
    
    [super dealloc];
}

@end
