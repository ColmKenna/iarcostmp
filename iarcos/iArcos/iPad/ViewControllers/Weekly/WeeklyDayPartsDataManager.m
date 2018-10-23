//
//  WeeklyDayPartsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 25/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "WeeklyDayPartsDataManager.h"

@implementation WeeklyDayPartsDataManager
//@synthesize dayPartsDictList = _dayPartsDictList;
//@synthesize dayPartsCode = _dayPartsCode;
//@synthesize dayPartsTitle = _dayPartsTitle;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
//        self.dayPartsCode = @"DP";//DP 01 CC
    }
    return self;
}

- (void)dealloc {
//    self.dayPartsDictList = nil;
//    self.dayPartsCode = nil;
//    self.dayPartsTitle = nil;
    
    [super dealloc];
}

/*
- (NSString*)retrieveDayPartsTitle {
    NSString* auxDayPartsTitle = @"";
    NSDictionary* dayPartsDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:self.dayPartsCode];
    if (dayPartsDict != nil) {
        auxDayPartsTitle = [dayPartsDict objectForKey:@"Details"];
    }
    return auxDayPartsTitle;
}

- (NSMutableArray*)retrieveDayPartsDictList {  
    return [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:self.dayPartsCode];
}
*/

@end
