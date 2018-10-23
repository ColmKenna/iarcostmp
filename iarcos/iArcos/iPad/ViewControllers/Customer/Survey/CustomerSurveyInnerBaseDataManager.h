//
//  CustomerSurveyInnerBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 16/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerSurveyInnerBaseDataManager : NSObject

- (NSMutableArray*)retrieveResponseWithLocationIUR:(NSNumber*)aLocationIUR surveyIUR:(NSNumber*)aSurveyIUR contactIUR:(NSNumber*)aContactIUR questionIURList:(NSMutableArray*)aQuestionIURList;
- (void)manipulateResponseWithDataList:(NSMutableDictionary*)aQuestionDict originalDataDict:(NSMutableDictionary*)anOriginalQuestionDict contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR;

@end
