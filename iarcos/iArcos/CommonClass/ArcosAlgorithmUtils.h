//
//  ArcosAlgorithmUtils.h
//  Arcos
//
//  Created by David Kilmartin on 15/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"

@interface ArcosAlgorithmUtils : NSObject {

}

- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict dictKey:(NSString*)aDictKey keyword:(NSNumber*)aKeyword;
- (NSRange)getBSRangeWithArrayOfDict:(NSMutableArray*)anArrayOfDict dictKey:(NSString*)aDictKey keyword:(NSNumber*)aKeyword location:(int)aLocation;
- (NSMutableDictionary*)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList fieldName:(NSString*)aFieldName;

@end
