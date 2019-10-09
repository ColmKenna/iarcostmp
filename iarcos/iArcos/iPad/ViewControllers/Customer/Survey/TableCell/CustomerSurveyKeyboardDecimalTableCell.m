//
//  CustomerSurveyKeyboardDecimalTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyKeyboardDecimalTableCell.h"

@implementation CustomerSurveyKeyboardDecimalTableCell
//@synthesize narrative;
@synthesize responseLimits;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    if (self.narrative != nil) { self.narrative = nil; }
    if (self.responseLimits != nil) { self.responseLimits = nil; }        
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    [self processIndicatorButton];
    self.narrative.text = [theData objectForKey:@"Narrative"];
    NSString* aResponse = [theData objectForKey:@"Answer"];
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseLimits.text = aResponse;
    } else {
        self.responseLimits.text = @"";
    }
    self.responseLimits.delegate = self;
//    for (UIGestureRecognizer* recognizer in self.narrative.gestureRecognizers) {
//        [self.narrative removeGestureRecognizer:recognizer];
//    }
//    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
//    [self.narrative addGestureRecognizer:singleTap2];
//    [singleTap2 release];
    [self configNarrativeSingleTapGesture];
    [self configNarrativeWithLabel:self.narrative];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"textFieldDidEndEditing");
    if (![self.responseLimits.text isEqualToString:@""] && ![ArcosValidator isInteger:self.responseLimits.text]) {
        [ArcosUtils showMsg:-1 message:[NSString stringWithFormat:@"%@ is only allowed to input an integer.", self.narrative.text] delegate:nil];
    }
    NSString* returnValue = self.responseLimits.text;
    if ([self.responseLimits.text isEqualToString:@""]) {
        returnValue = [GlobalSharedClass shared].unknownText;
    }
    [self.delegate inputFinishedWithData:returnValue forIndexpath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { 
//    NSLog(@"%@, %@", textField.text, string);
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
}

//-(void)handleSingleTapGesture4Narrative:(id)sender {
//    [ArcosUtils showMsg:[self.cellData objectForKey:@"tooltip"] delegate:nil];
//}


@end
