//
//  ArcosDescriptionTrManager.m
//  Arcos
//
//  Created by David Kilmartin on 18/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosDescriptionTrManager.h"
#import "GlobalSharedClass.h"

@implementation ArcosDescriptionTrManager

- (CompositeErrorResult*)copySurveyFileToPhotosWithFileName:(NSString*)aFileName {
//    BOOL resultFlag = NO;
    NSString* srcFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon surveyPath], aFileName];
    NSString* destFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon photosPath], aFileName];
//    NSError* tmpError = nil;
    return [FileCommon testCopyItemAtPath:srcFilePath toPath:destFilePath];
//    return resultFlag;
}

- (NSMutableDictionary*)createUnAssignedDescrDetailDict {
    NSArray* keys = [NSArray arrayWithObjects:@"Detail", @"DescrDetailIUR", @"Active", nil];
    NSArray* objs = [NSArray arrayWithObjects:[GlobalSharedClass shared].unassignedText, [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
    return [NSMutableDictionary dictionaryWithObjects:objs forKeys:keys];
}

- (NSMutableDictionary*)createIndependentGroupDescrDetailDict {
    NSArray* keys = [NSArray arrayWithObjects:@"Detail", @"DescrDetailIUR", @"Active", nil];
    NSArray* objs = [NSArray arrayWithObjects:@"Independent Group", [NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil];
    return [NSMutableDictionary dictionaryWithObjects:objs forKeys:keys];
}

@end
