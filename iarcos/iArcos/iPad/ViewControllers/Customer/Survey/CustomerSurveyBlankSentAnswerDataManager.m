//
//  CustomerSurveyBlankSentAnswerDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 16/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyBlankSentAnswerDataManager.h"

@implementation CustomerSurveyBlankSentAnswerDataManager

- (NSMutableArray*)retrieveResponseWithLocationIUR:(NSNumber*)aLocationIUR surveyIUR:(NSNumber*)aSurveyIUR contactIUR:(NSNumber*)aContactIUR questionIURList:(NSMutableArray*)aQuestionIURList {
    return [[ArcosCoreData sharedArcosCoreData] responseWithLocationIUR:aLocationIUR surveyIUR:aSurveyIUR contactIUR:aContactIUR questionIURList:aQuestionIURList unsendOnly:YES];
}

- (void)manipulateResponseWithDataList:(NSMutableDictionary*)aQuestionDict originalDataDict:(NSMutableDictionary*)anOriginalQuestionDict contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR {
    [[ArcosCoreData sharedArcosCoreData] insertResponseWithDataList:aQuestionDict originalDataDict:anOriginalQuestionDict contactIUR:aContactIUR locationIUR:aLocationIUR unsendOnly:YES];
}

@end
