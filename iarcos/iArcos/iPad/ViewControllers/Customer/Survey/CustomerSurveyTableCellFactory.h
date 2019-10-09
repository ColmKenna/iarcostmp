//
//  CustomerSurveyTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 12/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerSurveyBaseTableCell.h"
#import "ArcosUtils.h"

@interface CustomerSurveyTableCellFactory : NSObject {
    NSString* surveyListTableCellId;
    NSString* surveyContactTableCellId;
    NSString* surveyBooleanTableCellId;
    NSString* surveyNumberWheelTableCellId;
    NSString* surveyWheelTableCellId;
    NSString* surveyKeyboardTableCellId;
    NSString* surveySlideTableCellId;
    NSString* surveySliderBarTableCellId;
    NSString* surveyKeyboardDecimalTableCellId;
    NSString* surveyKeyboardDecimalTwoPlacesTableCellId;
    NSString* surveyTableMSTableCellId;
    NSString* surveyPhotoTableCellId;
    NSString* _surveySegmentedControlTableCellId;    
    NSString* _surveySegmentedControlTextFieldTableCellId;
    NSString* _surveyRankingTableCellId;
    NSString* _surveySubHeaderTableCellId;
    NSString* _surveyMainSummaryTableCellId;
}

@property(nonatomic, retain) NSString* surveyListTableCellId;
@property(nonatomic, retain) NSString* surveyContactTableCellId;
@property(nonatomic, retain) NSString* surveyBooleanTableCellId;
@property(nonatomic, retain) NSString* surveyNumberWheelTableCellId;
@property(nonatomic, retain) NSString* surveyWheelTableCellId;
@property(nonatomic, retain) NSString* surveyKeyboardTableCellId;
@property(nonatomic, retain) NSString* surveySlideTableCellId;
@property(nonatomic, retain) NSString* surveySliderBarTableCellId;
@property(nonatomic, retain) NSString* surveyKeyboardDecimalTableCellId;
@property(nonatomic, retain) NSString* surveyKeyboardDecimalTwoPlacesTableCellId;
@property(nonatomic, retain) NSString* surveyTableMSTableCellId;
@property(nonatomic, retain) NSString* surveyPhotoTableCellId;
@property(nonatomic, retain) NSString* surveySegmentedControlTableCellId;
@property(nonatomic, retain) NSString* surveySegmentedControlTextFieldTableCellId;
@property(nonatomic, retain) NSString* surveyRankingTableCellId;
@property(nonatomic, retain) NSString* surveySubHeaderTableCellId;
@property(nonatomic, retain) NSString* surveyMainSummaryTableCellId;

+(id)factory;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyBaseTableCellWithData:(NSMutableDictionary*)data;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyListTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyContactTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyBooleanTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyNumberWheelTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyWheelTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyKeyboardTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveySlideTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveySliderBarTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyKeyboardDecimalTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyKeyboardDecimalTwoPlacesTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyTableMSTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyPhotoTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveySegmentedControlTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveySegmentedControlTextFieldTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyRankingTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveySubHeaderTableCell;
-(CustomerSurveyBaseTableCell*)createCustomerSurveyMainSummaryTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;

@end
