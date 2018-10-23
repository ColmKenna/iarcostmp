//
//  GetRecordTypeGenericBaseObject.m
//  iArcos
//
//  Created by David Kilmartin on 30/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordTypeGenericBaseObject.h"

@implementation GetRecordTypeGenericBaseObject
@synthesize resultContent = _resultContent;

- (instancetype)initWithTypeObjectValue:(id)anObjectValue {
    self = [super init];
    if (self != nil) {
        self.resultContent = anObjectValue;
    }
    return self;
}

- (void)dealloc {
    self.resultContent = nil;
    
    [super dealloc];
}

- (NSString*)retrieveStringValue {
    return @"";
}

- (BOOL)compareGenericBaseObject:(GetRecordTypeGenericBaseObject*)aGenericBaseObject {
    NSLog(@"%@ -- %@", [self retrieveStringValue], [aGenericBaseObject retrieveStringValue]);
    return [[self retrieveStringValue] isEqualToString:[aGenericBaseObject retrieveStringValue]];
}

@end
