//
//  MeetingExpenseTableViewHeader.m
//  iArcos
//
//  Created by David Kilmartin on 23/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseTableViewHeader.h"

@implementation MeetingExpenseTableViewHeader
@synthesize dateLabel = _dateLabel;
@synthesize detailsLabel = _detailsLabel;
@synthesize commentsLabel = _commentsLabel;
@synthesize amountLabel = _amountLabel;

- (void)dealloc {
    self.dateLabel = nil;
    self.detailsLabel = nil;
    self.commentsLabel = nil;
    self.amountLabel = nil;
    
    [super dealloc];
}

@end
