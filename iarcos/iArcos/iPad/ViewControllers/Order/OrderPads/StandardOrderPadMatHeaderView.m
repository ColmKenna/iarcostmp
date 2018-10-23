//
//  StandardOrderPadMatHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 06/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "StandardOrderPadMatHeaderView.h"

@implementation StandardOrderPadMatHeaderView
@synthesize descriptionLabel = _descriptionLabel;
@synthesize month3 = _month3;
@synthesize month4 = _month4;
@synthesize month5 = _month5;
@synthesize month6 = _month6;
@synthesize month7 = _month7;
@synthesize month8 = _month8;
@synthesize month9 = _month9;
@synthesize month10 = _month10;
@synthesize month11 = _month11;
@synthesize month12 = _month12;
@synthesize month13 = _month13;
@synthesize month14 = _month14;
@synthesize month15 = _month15;
@synthesize totalLabel = _totalLabel;
@synthesize qtyLabel = _qtyLabel;
@synthesize bonLabel = _bonLabel;
@synthesize stockLabel = _stockLabel;


- (void)dealloc {
    self.descriptionLabel = nil;
    self.month3 = nil;
    self.month4 = nil;
    self.month5 = nil;
    self.month6 = nil;
    self.month7 = nil;
    self.month8 = nil;
    self.month9 = nil;
    self.month10 = nil;
    self.month11 = nil;
    self.month12 = nil;
    self.month13 = nil;
    self.month14 = nil;
    self.month15 = nil;
    self.totalLabel = nil;
    self.qtyLabel = nil;
    self.bonLabel = nil;
    self.stockLabel = nil;
    
    [super dealloc];
}


@end
