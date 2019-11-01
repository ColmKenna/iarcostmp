//
//  CustomerSurveyTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 12/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyTableCellFactory.h"

@interface CustomerSurveyTableCellFactory (Private)

-(CustomerSurveyBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation CustomerSurveyTableCellFactory
@synthesize surveyListTableCellId;
@synthesize surveyContactTableCellId;
@synthesize surveyBooleanTableCellId;
@synthesize surveyNumberWheelTableCellId;
@synthesize surveyWheelTableCellId;
@synthesize surveyKeyboardTableCellId;
@synthesize surveySlideTableCellId;
@synthesize surveySliderBarTableCellId;
@synthesize surveyKeyboardDecimalTableCellId;
@synthesize surveyKeyboardDecimalTwoPlacesTableCellId;
@synthesize surveyTableMSTableCellId;
@synthesize surveyPhotoTableCellId;
@synthesize surveySegmentedControlTableCellId = _surveySegmentedControlTableCellId;
@synthesize surveySegmentedControlTextFieldTableCellId = _surveySegmentedControlTextFieldTableCellId;
@synthesize surveyRankingTableCellId = _surveyRankingTableCellId;
@synthesize surveySubHeaderTableCellId = _surveySubHeaderTableCellId;
@synthesize surveyMainSummaryTableCellId = _surveyMainSummaryTableCellId;
@synthesize surveySignatureTableCellId = _surveySignatureTableCellId;

-(id)init {
    if(self = [super init]) {
        self.surveyListTableCellId = @"IdCustomerSurveyListTableCell";
        self.surveyContactTableCellId = @"IdCustomerSurveyContactTableCell";
        self.surveyBooleanTableCellId = @"IdCustomerSurveyBooleanTableCell";
        self.surveyNumberWheelTableCellId = @"IdCustomerSurveyNumberWheelTableCell";
        self.surveyWheelTableCellId = @"IdCustomerSurveyWheelTableCell";
        self.surveyKeyboardTableCellId = @"IdCustomerSurveyKeyboardTableCell";
        self.surveySlideTableCellId = @"IdCustomerSurveySlideTableCell";
        self.surveySliderBarTableCellId = @"IdCustomerSurveySliderBarTableCell";
        self.surveyKeyboardDecimalTableCellId = @"IdCustomerSurveyKeyboardDecimalTableCell";
        self.surveyKeyboardDecimalTwoPlacesTableCellId = @"IdCustomerSurveyKeyboardDecimalTwoPlacesTableCell";
        self.surveyTableMSTableCellId = @"IdCustomerSurveyTableMSTableCell";
        self.surveyPhotoTableCellId = @"IdCustomerSurveyPhotoTableCell";
        self.surveySegmentedControlTableCellId = @"IdCustomerSurveySegmentedControlTableCell";
        self.surveySegmentedControlTextFieldTableCellId = @"IdCustomerSurveySegmentedControlTextFieldTableCell";
        self.surveyRankingTableCellId = @"IdCustomerSurveyRankingTableCell";        
        self.surveySubHeaderTableCellId = @"IdCustomerSurveySubHeaderTableCell";
        self.surveyMainSummaryTableCellId = @"IdCustomerSurveyMainSummaryTableCell";
        self.surveySignatureTableCellId = @"IdCustomerSurveySignatureTableCell";
    }
    return self;
}

- (void)dealloc {
    self.surveyListTableCellId = nil;
    self.surveyContactTableCellId = nil;
    self.surveyBooleanTableCellId = nil;
    self.surveyNumberWheelTableCellId = nil;
    self.surveyWheelTableCellId = nil;
    self.surveyKeyboardTableCellId = nil;
    self.surveySlideTableCellId = nil;
    self.surveySliderBarTableCellId = nil;
    self.surveyKeyboardDecimalTableCellId = nil;
    self.surveyKeyboardDecimalTwoPlacesTableCellId = nil;
    self.surveyTableMSTableCellId = nil;
    self.surveyPhotoTableCellId = nil;
    self.surveySegmentedControlTableCellId = nil;    
    self.surveySegmentedControlTextFieldTableCellId = nil;
    self.surveyRankingTableCellId = nil;
    self.surveySubHeaderTableCellId = nil;
    self.surveyMainSummaryTableCellId = nil;
    self.surveySignatureTableCellId = nil;
    
    [super dealloc];
}

+(id)factory{
    return [[[self alloc]init]autorelease];
}

-(CustomerSurveyBaseTableCell*)createCustomerSurveyBaseTableCellWithData:(NSMutableDictionary*)data {
    int questionType = [[data objectForKey:@"QuestionType"] intValue];
    CustomerSurveyBaseTableCell* cell = nil;
    switch (questionType) {
        case 90:
            cell = [self createCustomerSurveyListTableCell];
            break;
        case 91:
            cell = [self createCustomerSurveyContactTableCell];
            break;
        case 1:
            cell = [self createCustomerSurveyBooleanTableCell];
            break;
        case 2:
            cell = [self createCustomerSurveyNumberWheelTableCell];
            break;
        case 3:
            cell = [self createCustomerSurveyWheelTableCell];
            break;
        case 4:
            cell = [self createCustomerSurveyKeyboardTableCell];
            break;
        case 5:
        case 6:
            cell = [self createCustomerSurveySlideTableCell];
            break;
        case 8:
            cell = [self createCustomerSurveySliderBarTableCell];
            break;
        case 9:
            cell = [self createCustomerSurveyKeyboardDecimalTwoPlacesTableCell];
            break;
        case 10:
            cell = [self createCustomerSurveyKeyboardDecimalTableCell];
            break;
        case 11:
            cell = [self createCustomerSurveyTableMSTableCell];
            break;
        case 12:
            cell = [self createCustomerSurveyPhotoTableCell];
            break;
        case 13:
            cell = [self createCustomerSurveySegmentedControlTableCell];
            break;
        case 14:
            cell = [self createCustomerSurveySegmentedControlTextFieldTableCell];
            break;
        case 15:
            cell = [self createCustomerSurveyRankingTableCell];
            break;        
        case 16:
            cell = [self createCustomerSurveySubHeaderTableCell];
            break;
        case 17:
            cell = [self createCustomerSurveyMainSummaryTableCell];
            break;
        case 18:
            cell = [self createCustomerSurveySignatureTableCell];
            break;
        default:
            cell = [self createCustomerSurveyContactTableCell];
            break;
    }
    return cell;
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyListTableCell {
    return [self getCellWithIdentifier:self.surveyListTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyContactTableCell {
    return [self getCellWithIdentifier:self.surveyContactTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyBooleanTableCell {
    return [self getCellWithIdentifier:self.surveyBooleanTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyNumberWheelTableCell {
    return [self getCellWithIdentifier:self.surveyNumberWheelTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyWheelTableCell {
    return [self getCellWithIdentifier:self.surveyWheelTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyKeyboardTableCell {
    return [self getCellWithIdentifier:self.surveyKeyboardTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveySlideTableCell {
    return [self getCellWithIdentifier:self.surveySlideTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveySliderBarTableCell {
    return [self getCellWithIdentifier:self.surveySliderBarTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyKeyboardDecimalTwoPlacesTableCell {
    return [self getCellWithIdentifier:self.surveyKeyboardDecimalTwoPlacesTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyKeyboardDecimalTableCell {
    return [self getCellWithIdentifier:self.surveyKeyboardDecimalTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyTableMSTableCell {
    return [self getCellWithIdentifier:self.surveyTableMSTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyPhotoTableCell {
    return [self getCellWithIdentifier:self.surveyPhotoTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveySegmentedControlTableCell {
    return [self getCellWithIdentifier:self.surveySegmentedControlTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveySegmentedControlTextFieldTableCell {
    return [self getCellWithIdentifier:self.surveySegmentedControlTextFieldTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyRankingTableCell {
    return [self getCellWithIdentifier:self.surveyRankingTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveySubHeaderTableCell {
    return [self getCellWithIdentifier:self.surveySubHeaderTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveyMainSummaryTableCell {
    return [self getCellWithIdentifier:self.surveyMainSummaryTableCellId];
}
-(CustomerSurveyBaseTableCell*)createCustomerSurveySignatureTableCell {
    return [self getCellWithIdentifier:self.surveySignatureTableCellId];
}


-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    UITableViewCell* cell = nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerSurveyTypesTableCell" owner:self options:nil];
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;
            break;
        }
    }    
    return cell;
}

-(NSString*)identifierWithData:(NSMutableDictionary*)data {
    int QuestionType = [[data objectForKey:@"QuestionType"] intValue];
    NSString* identifier = nil;
    switch (QuestionType) {
        case 90:
            identifier = self.surveyListTableCellId;
            break;
        case 91:
            identifier = self.surveyContactTableCellId;
            break;
        case 1:
            identifier = self.surveyBooleanTableCellId;
            break;
        case 2:
            identifier = self.surveyNumberWheelTableCellId;
            break;
        case 3:
            identifier = self.surveyWheelTableCellId;
            break;
        case 4:
            identifier = self.surveyKeyboardTableCellId;
            break;
        case 5:
        case 6:
            identifier = self.surveySlideTableCellId;
            break;
        case 8:
            identifier = self.surveySliderBarTableCellId;
            break;
        case 9:
            identifier = self.surveyKeyboardDecimalTwoPlacesTableCellId;
            break;
        case 10:
            identifier = self.surveyKeyboardDecimalTableCellId;
            break;
        case 11:
            identifier = self.surveyTableMSTableCellId;
            break;
        case 12:
            identifier = self.surveyPhotoTableCellId;
            break;
        case 13:
            identifier = self.surveySegmentedControlTableCellId;
            break;        
        case 14:
            identifier = self.surveySegmentedControlTextFieldTableCellId;
            break;
        case 15:
            identifier = self.surveyRankingTableCellId;
            break;
        case 16:
            identifier = self.surveySubHeaderTableCellId;
            break;
        case 17:
            identifier = self.surveyMainSummaryTableCellId;
            break;
        case 18:
            identifier = self.surveySignatureTableCellId;
            break;
        default:
            identifier = self.surveyContactTableCellId;
            break;
    }
    return identifier;
}


@end
