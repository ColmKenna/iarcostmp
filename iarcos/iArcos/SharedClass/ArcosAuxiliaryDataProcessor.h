//
//  ArcosAuxiliaryDataProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 30/11/2015.
//  Copyright © 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface ArcosAuxiliaryDataProcessor : NSObject

+ (ArcosAuxiliaryDataProcessor *)sharedArcosAuxiliaryDataProcessor;

- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString *)aDescrTypeCode activeOnly:(BOOL)activeFlag;

- (void)runTransaction;

@end
