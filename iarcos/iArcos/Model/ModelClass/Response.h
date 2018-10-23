//
//  Response.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Response : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSString * Answer;
@property (nonatomic, retain) NSNumber * SurveyIUR;
@property (nonatomic, retain) NSNumber * rowgrid;
@property (nonatomic, retain) NSDate * ResponseDate;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * QuestionIUR;
@property (nonatomic, retain) NSString * ResponseInt;
@property (nonatomic, retain) NSNumber * CallIUR;

@end
