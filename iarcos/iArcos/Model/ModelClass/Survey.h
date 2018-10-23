//
//  Survey.h
//  Arcos
//
//  Created by David Kilmartin on 08/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Survey : NSManagedObject

@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * UseorderPad;
@property (nonatomic, retain) NSString * SurveyTargetGroup;
@property (nonatomic, retain) NSString * Narrative;
@property (nonatomic, retain) NSDate * StartDate;
@property (nonatomic, retain) NSDate * EndDate;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * SurveyTargetTypes;
@property (nonatomic, retain) NSNumber * rowguid;

@end
