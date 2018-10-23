//
//  ArcosDescriptionTrManager.h
//  Arcos
//
//  Created by David Kilmartin on 18/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface ArcosDescriptionTrManager : NSObject

- (CompositeErrorResult*)copySurveyFileToPhotosWithFileName:(NSString*)aFileName;
- (NSMutableDictionary*)createUnAssignedDescrDetailDict;
- (NSMutableDictionary*)createIndependentGroupDescrDetailDict;

@end
