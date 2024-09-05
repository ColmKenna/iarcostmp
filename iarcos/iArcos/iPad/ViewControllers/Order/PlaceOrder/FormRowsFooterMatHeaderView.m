//
//  FormRowsFooterMatHeaderView.m
//  iArcos
//
//  Created by Richard on 13/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsFooterMatHeaderView.h"

@implementation FormRowsFooterMatHeaderView
@synthesize titleLabel = _titleLabel;
@synthesize templateView = _templateView;
@synthesize separatorLabel = _separatorLabel;
@synthesize monthLabel0 = _monthLabel0;
@synthesize monthLabel1 = _monthLabel1;
@synthesize monthLabel2 = _monthLabel2;
@synthesize monthLabel3 = _monthLabel3;
@synthesize monthLabel4 = _monthLabel4;
@synthesize monthLabel5 = _monthLabel5;
@synthesize monthLabel6 = _monthLabel6;
@synthesize monthLabel7 = _monthLabel7;
@synthesize monthLabel8 = _monthLabel8;
@synthesize monthLabel9 = _monthLabel9;
@synthesize monthLabel10 = _monthLabel10;
@synthesize monthLabel11 = _monthLabel11;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.titleLabel = nil;
    self.templateView = nil;
    self.monthLabel0 = nil;
    self.monthLabel1 = nil;
    self.monthLabel2 = nil;
    self.monthLabel3 = nil;
    self.monthLabel4 = nil;
    self.monthLabel5 = nil;
    self.monthLabel6 = nil;
    self.monthLabel7 = nil;
    self.monthLabel8 = nil;
    self.monthLabel9 = nil;
    self.monthLabel10 = nil;
    self.monthLabel11 = nil;
    self.separatorLabel = nil;
    
    [super dealloc];
}

@end
