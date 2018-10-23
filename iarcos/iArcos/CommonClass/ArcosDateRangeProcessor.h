//
//  ArcosDateRangeProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 22/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosSystemCodesUtils.h"
#import "ArcosCoreData.h"

@interface ArcosDateRangeProcessor : NSObject

+ (NSNumber*)retrieveRightRangeNumberWithCode:(NSString*)aCode;

@end
