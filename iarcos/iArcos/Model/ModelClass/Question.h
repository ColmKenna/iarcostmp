//
//  Question.h
//  iArcos
//
//  Created by David Kilmartin on 16/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * Narrative;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * QuestionType;
@property (nonatomic, retain) NSString * ResponseLimits;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * sectionNo;
@property (nonatomic, retain) NSNumber * Sequence;
@property (nonatomic, retain) NSNumber * SurveyIUR;
@property (nonatomic, retain) NSString * tooltip;
@property (nonatomic, retain) NSNumber * ViewAs;

@end
