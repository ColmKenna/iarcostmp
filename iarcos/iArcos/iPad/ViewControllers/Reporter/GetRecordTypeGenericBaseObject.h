//
//  GetRecordTypeGenericBaseObject.h
//  iArcos
//
//  Created by David Kilmartin on 30/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"

@interface GetRecordTypeGenericBaseObject : NSObject {
    id _resultContent;
}

@property(nonatomic, retain) id resultContent;

- (instancetype)initWithTypeObjectValue:(id)anObjectValue;
- (NSString*)retrieveStringValue;
- (BOOL)compareGenericBaseObject:(GetRecordTypeGenericBaseObject*)aGenericBaseObject;

@end
