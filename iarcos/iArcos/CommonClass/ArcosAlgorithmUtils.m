//
//  ArcosAlgorithmUtils.m
//  Arcos
//
//  Created by David Kilmartin on 15/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosAlgorithmUtils.h"

@implementation ArcosAlgorithmUtils

- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict dictKey:(NSString*)aDictKey keyword:(NSNumber*)aKeyword {
    int loc = 0;
    int start = 0;
    unsigned int lengthOfArrayOfDict = [ArcosUtils convertNSUIntegerToUnsignedInt:anArrayOfDict.count];
    int end = lengthOfArrayOfDict - 1;
    int mid = lengthOfArrayOfDict / 2;
    @try {
        while(start <= end && [[[anArrayOfDict objectAtIndex:mid] objectForKey:aDictKey] intValue] != [aKeyword intValue]) {
            if([aKeyword intValue] < [[[anArrayOfDict objectAtIndex:mid] objectForKey:aDictKey] intValue]) {
                end = mid - 1;
            }else{
                start = mid + 1;
            }
            mid = (start + end) / 2;
        }
        if([[[anArrayOfDict objectAtIndex:mid] objectForKey:aDictKey] intValue] == [aKeyword intValue]) {
            loc = mid;
        }else{
            loc = -1;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), [exception reason]);
        return -1;
    }
//        NSLog(@"%@ location is at: %d", aKeyword, loc);
    return loc;
}

/*
 * used when location is not equal to -1
 */
- (NSRange)getBSRangeWithArrayOfDict:(NSMutableArray*)anArrayOfDict dictKey:(NSString*)aDictKey keyword:(NSNumber*)aKeyword location:(int)aLocation {
    int startIndex = aLocation;
    int forwardLength = 0;
    for (int i = aLocation - 1; i >= 0; i--) {//backward
        if ([aKeyword isEqualToNumber:[[anArrayOfDict objectAtIndex:i] objectForKey:aDictKey]]) {
            startIndex = i;
        } else {
            break;
        }            
    }
    for (int i = aLocation + 1; i < [anArrayOfDict count]; i++) {//forward
        if ([aKeyword isEqualToNumber:[[anArrayOfDict objectAtIndex:i] objectForKey:aDictKey]]) {
            forwardLength++;
        } else {
            break;
        }
    }
    return NSMakeRange(startIndex, aLocation - startIndex + 1 + forwardLength);
}

- (NSMutableDictionary*)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList fieldName:(NSString*)aFieldName {
//    NSLog(@"aSortedList: %@",aSortedList);
    NSMutableDictionary* sortedSectionDict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary* productSectionDict = [NSMutableDictionary dictionary];
    NSMutableArray* sortKeyList = [NSMutableArray array];
    [sortedSectionDict setObject:productSectionDict forKey:@"ProductSectionDict"];
    [sortedSectionDict setObject:sortKeyList forKey:@"SortKeyList"];
    if ([aSortedList count] == 0) {
        return sortedSectionDict;
    }
    //get the first char of the  list
    NSString* currentChar = @"";
    if ([aSortedList count] > 0) {
        NSMutableDictionary* aDescrDetailDict = [aSortedList objectAtIndex:0];        
        NSString* detail = [aDescrDetailDict objectForKey:aFieldName];
        
        if (detail != nil) {
            if ([detail length] >= 1) {
                currentChar = [detail substringToIndex:1];
            } else {
                currentChar = @" ";
            }            
        }        
        //add first Char
        [sortKeyList addObject:currentChar];
    }
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=1;
    
    //start sorting the customer in to the sections
    for (int i = 1; i < [aSortedList count]; i++) {
        //sotring the name into the array
        NSMutableDictionary* aDescrDetailDict = [aSortedList objectAtIndex:i];
        NSString* detail = [aDescrDetailDict objectForKey:aFieldName];        
        
        if (detail == nil || [detail isEqualToString:@""]) {
            detail = @" ";
        }
        
        //sorting
        if ([currentChar caseInsensitiveCompare:[detail substringToIndex:1]]==NSOrderedSame) {
            
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [productSectionDict setObject:tempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=location+length;//bug fit to duplicate outlet entry
            length=0;
            //get the current char
            currentChar = [detail substringToIndex:1];
            //add char to sort key
            [sortKeyList addObject:currentChar];
        }
        length++;
    }
    //the last loop or length == 1    
    NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    [productSectionDict setObject:tempArray forKey:currentChar];
    [tempArray release];
//    NSLog(@"sortKeyList:%@, productSectionDict:%@", sortKeyList, productSectionDict);
    return sortedSectionDict;
}


@end
