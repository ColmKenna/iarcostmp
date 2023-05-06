//
//  SavedOrderDetailHeaderView.m
//  iArcos
//
//  Created by Richard on 04/05/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "SavedOrderDetailHeaderView.h"

@implementation SavedOrderDetailHeaderView
@synthesize locationLabel = _locationLabel;
@synthesize goodsLabel = _goodsLabel;
@synthesize vatLabel = _vatLabel;
@synthesize totalLabel = _totalLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.locationLabel = nil;
    self.goodsLabel = nil;
    self.vatLabel = nil;
    self.totalLabel = nil;
    
    [super dealloc];
}

@end
