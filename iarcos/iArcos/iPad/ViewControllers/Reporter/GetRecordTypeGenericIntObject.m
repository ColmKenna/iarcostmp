//
//  GetRecordTypeGenericIntObject.m
//  iArcos
//
//  Created by David Kilmartin on 30/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordTypeGenericIntObject.h"

@implementation GetRecordTypeGenericIntObject

- (NSString*)retrieveStringValue {
    return [ArcosUtils convertNumberToIntString:self.resultContent];
}

@end
