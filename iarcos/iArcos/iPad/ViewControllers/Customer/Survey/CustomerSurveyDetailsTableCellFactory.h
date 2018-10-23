//
//  CustomerSurveyDetailsTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"

@interface CustomerSurveyDetailsTableCellFactory : NSObject {
//    NSString* _surveyDetailsResponseTableCellId;
    NSString* _surveyDetailsSegmentedControlResponseTableCellId;
    NSString* _surveyDetailsSubHeaderTableCellId;
    NSString* _surveyDetailsResponseBooleanTableCellId;
    NSString* _surveyDetailsResponseWheelTableCellId;
    NSString* _surveyDetailsResponseTextBoxTableCellId;
}

//@property(nonatomic, retain) NSString* surveyDetailsResponseTableCellId;
@property(nonatomic, retain) NSString* surveyDetailsSegmentedControlResponseTableCellId;
@property(nonatomic, retain) NSString* surveyDetailsSubHeaderTableCellId;
@property(nonatomic, retain) NSString* surveyDetailsResponseBooleanTableCellId;
@property(nonatomic, retain) NSString* surveyDetailsResponseWheelTableCellId;
@property(nonatomic, retain) NSString* surveyDetailsResponseTextBoxTableCellId;

+ (instancetype)factory;
- (CustomerSurveyDetailsResponseBaseTableCell*)createCustomerSurveyDetailsResponseBaseTableCellWithData:(ArcosGenericClass*)aData;
- (NSString*)identifierWithData:(ArcosGenericClass*)aData;

@end
