//
//  CustomerSurveyMainSummaryTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 04/10/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyMainSummaryTableCell.h"
#import "ArcosUtils.h"
#import "ArcosValidator.h"

@implementation CustomerSurveyMainSummaryTableCell
//@synthesize narrative = _narrative;
@synthesize responseLimits = _responseLimits;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    self.narrative = nil;
    self.responseLimits = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    [self.responseLimits.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.responseLimits.layer setBorderWidth:0.5];
    [self.responseLimits.layer setCornerRadius:5.0f];
    self.cellData = theData;
    self.narrative.text = [theData objectForKey:@"Narrative"];
    [self processIndicatorButton];
    NSString* aResponse = [theData objectForKey:@"Answer"];
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseLimits.text = aResponse;
    } else {
        self.responseLimits.text = @"";
    }
//    for (UIGestureRecognizer* recognizer in self.narrative.gestureRecognizers) {
//        [self.narrative removeGestureRecognizer:recognizer];
//    }
//    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
//    [self.narrative addGestureRecognizer:singleTap2];
//    [singleTap2 release];
    [self configNarrativeSingleTapGesture];
    [self configNarrativeWithLabel:self.narrative];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString* returnValue = textView.text;
    if ([textView.text isEqualToString:@""]) {
        returnValue = [GlobalSharedClass shared].unknownText;
    }
    [self.delegate inputFinishedWithData:returnValue forIndexpath:self.indexPath];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UIViewController* tmpTarget = nil;
    if ([self.delegate respondsToSelector:@selector(retrieveParentViewController)]) {
        tmpTarget = [self.delegate retrieveParentViewController];
    }
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:tmpTarget maxLength:2000];
}

@end
