//
//  CustomerSurveyDetailsSegmentedControlResponseTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsSegmentedControlResponseTableCell.h"

@implementation CustomerSurveyDetailsSegmentedControlResponseTableCell
@synthesize narrative = _narrative;
@synthesize templateView = _templateView;
//@synthesize response = _response;
@synthesize responseTextField = _responseTextField;
@synthesize score = _score;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.narrative = nil;
    self.responseTextField = nil;
    self.score = nil;
    self.templateView = nil;
    self.factory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    self.cellData = aCellData;
    self.narrative.text = aCellData.Field4;
//    ;
    NSArray* responseArray = [aCellData.Field6 componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
    NSString* scoreString = @"";
    NSString* responseString = @"";    
    if ([responseArray count] == 2) {
        scoreString = [responseArray objectAtIndex:0];
        responseString = [responseArray objectAtIndex:1];
    }
    if ([responseArray count] == 1) {
        scoreString = [responseArray objectAtIndex:0];
    }
    if ([scoreString isEqualToString:[GlobalSharedClass shared].unknownText]) {
        scoreString = @"";
    }
    self.score.text = scoreString;
    float alphaRatio = [[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:scoreString]] floatValue] / 99.0;
    if (alphaRatio <= 0.3) {
        alphaRatio = 0.3;
    }
    self.score.alpha = 1.0 * alphaRatio;
//    self.response.text = responseString;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.score addGestureRecognizer:singleTap];
    [singleTap release];
    
    self.responseTextField.text = responseString;
    if ([[ArcosUtils convertStringToNumber:[ArcosUtils trim:aCellData.Field7]] intValue] == 0) {
        self.responseTextField.enabled = NO;
        self.score.userInteractionEnabled = NO;
    } else {
        self.responseTextField.enabled = YES;
        self.score.userInteractionEnabled = YES;
    }    
    
}

-(void)handleSingleTapGesture:(id)sender {
    NSString* responseLimitsDataSource = self.cellData.Field5;
    NSArray* responseLimitsArray = [responseLimitsDataSource componentsSeparatedByString:@"|"];
    NSMutableArray* pickerData = [NSMutableArray array];
    for (int i = 0; i < [responseLimitsArray count]; i++) {
        NSMutableDictionary* responseLimitDict = [NSMutableDictionary dictionary];
        [responseLimitDict setObject:[responseLimitsArray objectAtIndex:i] forKey:@"Title"];
        [pickerData addObject:responseLimitDict];
    }    
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateGenericCategoryWidgetWithPickerValue:pickerData title:@"ResponseLimits"];
    
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.score.bounds inView:self.score permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    self.score.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[self retrieveCompositeResult:[data objectForKey:@"Title"] secondResult:[self retrieveTextFieldValue]] forIndexPath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSArray* responseArray = [self.cellData.Field6 componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
    NSString* scoreString = @"";
    if ([responseArray count] == 2 || [responseArray count] == 1) {
        scoreString = [responseArray objectAtIndex:0];        
    }
    [self.delegate inputFinishedWithData:[self retrieveCompositeResult:scoreString secondResult:[self retrieveTextFieldValue]] forIndexPath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return ![string isEqualToString:@"|"];
}

- (NSString*)retrieveCompositeResult:(NSString*)aFirstResult secondResult:(NSString*)aSecondResult {
    if ([aFirstResult isEqualToString:@""]) {
        aFirstResult = [GlobalSharedClass shared].unknownText;
    }
    return [ArcosUtils trimPipe:[ArcosUtils trim:[NSString stringWithFormat:@"%@%@%@", aFirstResult, [GlobalSharedClass shared].fieldDelimiter, aSecondResult]]];
}

- (NSString*)retrieveTextFieldValue {
    NSString* returnValue = self.responseTextField.text;
    return returnValue;
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
