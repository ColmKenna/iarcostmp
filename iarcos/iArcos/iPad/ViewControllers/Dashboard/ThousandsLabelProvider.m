//
//  ThousandsLabelProvider.m
//  SciChartText
//
//  Created by David Kilmartin on 23/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ThousandsLabelProvider.h"

@implementation ThousandsLabelProvider
@synthesize dataHashmap = _dataHashmap;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataHashmap = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"berocca", @"1992", @"berocca3", @"1993", @"berocca4", @"1994",@"berocca5", @"1995",@"berocca6", @"1996",@"berocca7", @"1997",@"berocca8", @"1998", @"berocca9", @"1999", @"berocca00", @"2000",@"berocca01", @"2001",@"berocca02", @"2002",@"berocca03", @"2003",@"berocca04", @"2004",@"berocca05", @"2005",@"berocca06", @"2006",@"berocca07", @"2007",@"berocca08", @"2008",@"berocca09", @"2009",@"berocca10", @"2010",@"berocca11", @"2011",@"berocca12", @"2012",@"berocca13", @"2013",@"berocca14", @"2014",@"berocca15", @"2015",@"berocca16", @"2016", nil];
    }
    return self;
}

- (void)dealloc {
    self.dataHashmap = nil;
    
    [super dealloc];
}

//-(NSString*)formatLabel:(SCIGenericType)dataValue {
//    NSString* key = [NSString stringWithFormat:@"%.0f",SCIGenericDouble(dataValue)];
//    NSString* value = [self.dataHashmap objectForKey:key];
//    if (value == nil) {
//        value = @"UnAssigned";//UnAssigned
//    }
//    return value;
//}


@end
