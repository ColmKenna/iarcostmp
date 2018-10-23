//
//  CustomerSurveyDetailsTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsTableCellFactory.h"
@interface CustomerSurveyDetailsTableCellFactory ()

- (CustomerSurveyDetailsResponseBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation CustomerSurveyDetailsTableCellFactory
//@synthesize surveyDetailsResponseTableCellId = _surveyDetailsResponseTableCellId;
@synthesize surveyDetailsSegmentedControlResponseTableCellId = _surveyDetailsSegmentedControlResponseTableCellId;
@synthesize surveyDetailsSubHeaderTableCellId = _surveyDetailsSubHeaderTableCellId;
@synthesize surveyDetailsResponseBooleanTableCellId = _surveyDetailsResponseBooleanTableCellId;
@synthesize surveyDetailsResponseWheelTableCellId = _surveyDetailsResponseWheelTableCellId;
@synthesize surveyDetailsResponseTextBoxTableCellId = _surveyDetailsResponseTextBoxTableCellId;

- (instancetype)init {
    if(self = [super init]) {
//        self.surveyDetailsResponseTableCellId = @"IdCustomerSurveyDetailsResponseTableCell";
        self.surveyDetailsSegmentedControlResponseTableCellId = @"IdCustomerSurveyDetailsSegmentedControlResponseTableCell";
        self.surveyDetailsSubHeaderTableCellId = @"IdCustomerSurveyDetailsSubHeaderTableCell";
        self.surveyDetailsResponseBooleanTableCellId = @"IdCustomerSurveyDetailsResponseBooleanTableCell";
        self.surveyDetailsResponseWheelTableCellId = @"IdCustomerSurveyDetailsResponseWheelTableCell";
        self.surveyDetailsResponseTextBoxTableCellId = @"IdCustomerSurveyDetailsResponseTextBoxTableCell";
    }
    return self;
}

- (void)dealloc {
//    self.surveyDetailsResponseTableCellId = nil;
    self.surveyDetailsSegmentedControlResponseTableCellId = nil;
    self.surveyDetailsSubHeaderTableCellId = nil;
    self.surveyDetailsResponseBooleanTableCellId = nil;
    self.surveyDetailsResponseWheelTableCellId = nil;
    self.surveyDetailsResponseTextBoxTableCellId = nil;
    
    [super dealloc];
}

+ (instancetype)factory {
    return [[[self alloc] init] autorelease];
}

- (CustomerSurveyDetailsResponseBaseTableCell*)createCustomerSurveyDetailsResponseBaseTableCellWithData:(ArcosGenericClass*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

- (CustomerSurveyDetailsResponseBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier {
    CustomerSurveyDetailsResponseBaseTableCell* cell = nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerSurveyDetailsTableCell" owner:self options:nil];
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[CustomerSurveyDetailsResponseBaseTableCell class]] && [[(CustomerSurveyDetailsResponseBaseTableCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell = (CustomerSurveyDetailsResponseBaseTableCell *) nibItem;
            break;
        }
    }    
    return cell;
}

- (NSString*)identifierWithData:(ArcosGenericClass*)aData {
    int questionType = [[ArcosUtils convertStringToNumber:[aData Field3]] intValue];
    NSString* identifier = @"";
    switch (questionType) {
        case 1:
            identifier = self.surveyDetailsResponseBooleanTableCellId;
            break;
        case 13:
        case 14:
            identifier = self.surveyDetailsSegmentedControlResponseTableCellId;
            break;
        case 16:
            identifier = self.surveyDetailsSubHeaderTableCellId;
            break;
            
        default:            
            break;
    }
    if ([identifier isEqualToString:@""]) {
        NSArray* responseLimitsArray = [[ArcosUtils convertNilToEmpty:aData.Field5] componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
        if ([responseLimitsArray count] > 1) {
            identifier = self.surveyDetailsResponseWheelTableCellId;
        } else {
            identifier = self.surveyDetailsResponseTextBoxTableCellId;
        }
    }
    
    return identifier;
}



@end
