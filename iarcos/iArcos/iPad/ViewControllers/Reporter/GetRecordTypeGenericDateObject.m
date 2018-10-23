//
//  GetRecordTypeGenericDateObject.m
//  iArcos
//
//  Created by David Kilmartin on 30/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordTypeGenericDateObject.h"

@implementation GetRecordTypeGenericDateObject

- (NSString*)retrieveStringValue {
    return [ArcosUtils stringFromDate:self.resultContent format:[GlobalSharedClass shared].datetimehmFormat];
}

@end
