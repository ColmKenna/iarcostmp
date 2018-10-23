//
//  CustomerSurveySegmentedControlTextFieldTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySegmentedControlTextFieldTableCell.h"

@implementation CustomerSurveySegmentedControlTextFieldTableCell
@synthesize narrative = _narrative;
@synthesize responseSegmentedControl = _responseSegmentedControl;
@synthesize responseTextField = _responseTextField;
@synthesize segmentItemList = _segmentItemList;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.narrative = nil;
    self.responseSegmentedControl = nil;
    self.responseTextField = nil;
    self.segmentItemList = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.narrative.text = [self.cellData objectForKey:@"Narrative"];
    NSString* responseLimits = [self.cellData objectForKey:@"ResponseLimits"];
    NSArray* responseLimitArray = [responseLimits componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
    self.segmentItemList = [NSMutableArray arrayWithCapacity:[responseLimitArray count]];
    for (int i = 0; i < [responseLimitArray count]; i++) {
        [self.segmentItemList addObject:[ArcosUtils trim:[responseLimitArray objectAtIndex:i]]];
    }
    [self.segmentItemList addObject:[GlobalSharedClass shared].unknownText];
    [self.responseSegmentedControl removeAllSegments];
    
    for (int i = 0; i < [self.segmentItemList count]; i++) {
        [self.responseSegmentedControl insertSegmentWithTitle:[self.segmentItemList objectAtIndex:i] atIndex:i animated:NO];
    }
    
    NSString* tmpResponse = [theData objectForKey:@"Answer"];
    NSArray* tmpResponseArray = [tmpResponse componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
    NSString* aResponse = [GlobalSharedClass shared].unknownText;
    NSString* secondResponse = @"";
    if ([tmpResponseArray count] >= 2) {
        aResponse = [tmpResponseArray objectAtIndex:0];
        secondResponse = [tmpResponseArray objectAtIndex:1]; 
    }
    if ([tmpResponseArray count] == 1) {
        aResponse = [tmpResponseArray objectAtIndex:0];
    }
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseSegmentedControl.selectedSegmentIndex = [self retrieveIndexByTitle:aResponse];        
    } else {
        self.responseSegmentedControl.selectedSegmentIndex = [self.segmentItemList count] - 1;
    }
    if (secondResponse != nil && ![secondResponse isEqualToString:@""] && ![secondResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseTextField.text = secondResponse;
    } else {
        self.responseTextField.text = @"";
    }
    [self.delegate inputFinishedWithData:[self retrieveCompositeResult:[self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex] secondResult:[self retrieveTextFieldValue]] forIndexpath:self.indexPath];    
    self.narrative.textColor = [UIColor blackColor];
    if ([[self.cellData objectForKey:@"Highlight"] boolValue] && [[self.cellData objectForKey:@"active"] boolValue]) {
        NSString* auxAnswer = [self.cellData objectForKey:@"Answer"];
        NSArray* tmpAnswerArray = [auxAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
        if ([tmpAnswerArray count] == 2) {
            NSString* firstTmpAnswer = [tmpAnswerArray objectAtIndex:0];
            NSString* secondTmpAnswer = [tmpAnswerArray objectAtIndex:1];
            if (([firstTmpAnswer isEqualToString:@""] || [firstTmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) && ([secondTmpAnswer isEqualToString:@""] || [secondTmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText])) {
                self.narrative.textColor = [UIColor redColor];
            }
        }
        if ([tmpAnswerArray count] == 1) {
            NSString* firstTmpAnswer = [tmpAnswerArray objectAtIndex:0];
            if ([firstTmpAnswer isEqualToString:@""] || [firstTmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) {
                self.narrative.textColor = [UIColor redColor];
            }
        }
    }
}

- (IBAction)segmentedValueChange:(id)sender {    
    NSString* selectedSegmentTitle = [self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex];
    [self.delegate inputFinishedWithData:[self retrieveCompositeResult:selectedSegmentTitle secondResult:[self retrieveTextFieldValue]] forIndexpath:self.indexPath];
}

- (int)retrieveIndexByTitle:(NSString*)aTitle {
    int auxIndex = -1;
    for (int i = 0; i < [self.segmentItemList count]; i++) {
        if ([aTitle isEqualToString:[self.segmentItemList objectAtIndex:i]]) {
            auxIndex = i;
            break;
        }
    }
    return auxIndex;
}

- (NSString*)retrieveCompositeResult:(NSString*)aFirstResult secondResult:(NSString*)aSecondResult {
    return [ArcosUtils trimPipe:[ArcosUtils trim:[NSString stringWithFormat:@"%@%@%@", aFirstResult, [GlobalSharedClass shared].fieldDelimiter, aSecondResult]]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:[self retrieveCompositeResult:[self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex] secondResult:[self retrieveTextFieldValue]] forIndexpath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return ![string isEqualToString:@"|"];
}

- (NSString*)retrieveTextFieldValue {
    NSString* returnValue = self.responseTextField.text;
//    if ([self.responseTextField.text isEqualToString:@""]) {
//        returnValue = [GlobalSharedClass shared].unknownText;
//    }
    return returnValue;
}

@end
