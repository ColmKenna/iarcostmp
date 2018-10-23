//
//  GetRecordTypeGenericDecimalObject.m
//  iArcos
//
//  Created by David Kilmartin on 30/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordTypeGenericDecimalObject.h"

@implementation GetRecordTypeGenericDecimalObject

- (NSString*)retrieveStringValue {
    return [NSString stringWithFormat:@"%.2f", [self.resultContent floatValue]];
}

@end
