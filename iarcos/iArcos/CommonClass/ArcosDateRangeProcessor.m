//
//  ArcosDateRangeProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 22/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "ArcosDateRangeProcessor.h"

@implementation ArcosDateRangeProcessor

+ (NSNumber*)retrieveRightRangeNumberWithCode:(NSString*)aCode {
    NSNumber* rightRangeNumber = [NSNumber numberWithInt:12];
    if ([ArcosSystemCodesUtils optionExistenceWithCode:aCode]) {
        rightRangeNumber = [ArcosSystemCodesUtils retrieveNumberInOptionWithCode:aCode];
    } else {
        NSString* descrTypeCode = [ArcosSystemCodesUtils retrieveDescrTypeCodeWithCode:aCode];
        NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:descrTypeCode];
        if ([objectList count] > 0) {
            NSDictionary* descrDetailDict = [objectList objectAtIndex:0];
            NSString* detail = [descrDetailDict objectForKey:@"Detail"];
            if ([ArcosValidator isInteger:detail]) {
                rightRangeNumber = [ArcosUtils convertStringToNumber:detail];
            }
        }
    }
    
    
    
    return rightRangeNumber;
}

@end
