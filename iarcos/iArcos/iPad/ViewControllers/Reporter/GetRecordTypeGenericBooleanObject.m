//
//  GetRecordTypeGenericBooleanObject.m
//  iArcos
//
//  Created by David Kilmartin on 30/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordTypeGenericBooleanObject.h"

@implementation GetRecordTypeGenericBooleanObject

- (NSString*)retrieveStringValue {
    return [ArcosUtils convertNumberToIntString:self.resultContent];
}

@end
