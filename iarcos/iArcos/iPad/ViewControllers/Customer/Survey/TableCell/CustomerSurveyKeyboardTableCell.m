//
//  CustomerSurveyKeyboardTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyKeyboardTableCell.h"

@implementation CustomerSurveyKeyboardTableCell
@synthesize narrative;
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
    if (self.narrative != nil) { self.narrative = nil; }
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
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
    [self.narrative addGestureRecognizer:singleTap2];
    [singleTap2 release];
    [self configNarrativeWithLabel:self.narrative];
}

-(IBAction)textInputEnd:(id)sender {
    NSString* returnValue = self.responseLimits.text;
    if ([self.responseLimits.text isEqualToString:@""]) {
        returnValue = [GlobalSharedClass shared].unknownText;
    }
    [self.delegate inputFinishedWithData:returnValue forIndexpath:self.indexPath];
}

-(void)handleSingleTapGesture4Narrative:(id)sender {
    [ArcosUtils showMsg:[self.cellData objectForKey:@"tooltip"] delegate:nil];
}

@end
