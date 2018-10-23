//
//  CustomerAccessTimesUtils.m
//  iArcos
//
//  Created by David Kilmartin on 03/10/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerAccessTimesUtils.h"
#import "ArcosUtils.h"

@implementation CustomerAccessTimesUtils
@synthesize weekdayHashtable = _weekdayHashtable;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.weekdayHashtable = [NSMutableDictionary dictionaryWithCapacity:7];
        [self.weekdayHashtable setObject:@"Sunday" forKey:[NSNumber numberWithInt:0]];
        [self.weekdayHashtable setObject:@"Monday" forKey:[NSNumber numberWithInt:1]];
        [self.weekdayHashtable setObject:@"Tuesday" forKey:[NSNumber numberWithInt:2]];
        [self.weekdayHashtable setObject:@"Wednesday" forKey:[NSNumber numberWithInt:3]];
        [self.weekdayHashtable setObject:@"Thursday" forKey:[NSNumber numberWithInt:4]];
        [self.weekdayHashtable setObject:@"Friday" forKey:[NSNumber numberWithInt:5]];
        [self.weekdayHashtable setObject:@"Saturday" forKey:[NSNumber numberWithInt:6]];
    }
    return self;
}

- (void)dealloc {
    self.weekdayHashtable = nil;
    
    [super dealloc];
}

- (NSString*)retrieveAccessTimesInfoValue:(NSString*)anAccessTimesContent {
    NSString* infoValueText = @"";
    NSString* auxAccessTimesContent = anAccessTimesContent;
    int index = 1;
    int length = [ArcosUtils convertNSUIntegerToUnsignedInt:[auxAccessTimesContent length]];
    
    NSMutableDictionary* weekDayHashtable = [NSMutableDictionary dictionary];
    while (index < length) {
        NSString* weekDaySymbol = [auxAccessTimesContent substringWithRange:NSMakeRange(index - 1, 1)];
        if ([[weekDaySymbol uppercaseString] isEqualToString:@"A"]) {
            NSString* dayString = [auxAccessTimesContent substringWithRange:NSMakeRange(index, 1)];
            NSNumber* dayNumber = [ArcosUtils convertStringToNumber:dayString];
            [weekDayHashtable setObject:dayNumber forKey:dayNumber];
        }
        index = index + 6;
    }
    NSMutableArray* dayNumberKeyList = [NSMutableArray arrayWithArray:[weekDayHashtable allKeys]];
    NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"self"
                                                                    ascending:YES] autorelease];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray* sortedArray = [dayNumberKeyList sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray* weekDayList = [NSMutableArray arrayWithCapacity:[sortedArray count]];
    for (int i = 0; i < [sortedArray count]; i++) {
        NSNumber* tmpWeekDayNumber = [sortedArray objectAtIndex:i];
        NSString* tmpWeekDayString = [self.weekdayHashtable objectForKey:tmpWeekDayNumber];
        if (tmpWeekDayString != nil) {
            [weekDayList addObject:tmpWeekDayString];
        }
    }
    infoValueText = [weekDayList componentsJoinedByString:@","];
    return infoValueText;
}

@end
