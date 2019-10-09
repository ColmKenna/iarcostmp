//
//  CustomerSurveyRankingTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyRankingTableCell.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@implementation CustomerSurveyRankingTableCell
//@synthesize narrative = _narrative;
@synthesize responseSegmentedControl = _responseSegmentedControl;
@synthesize segmentItemList = _segmentItemList;
@synthesize previousSegmentIndex = _previousSegmentIndex;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
//    self.narrative = nil;
    self.responseSegmentedControl = nil;
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
    [self processIndicatorButton];
    NSMutableDictionary* auxRankingHashMap = [self.delegate retrieveRankingHashMap];
    NSMutableDictionary* contentRankingHashMap = [auxRankingHashMap objectForKey:[self.cellData objectForKey:@"sectionNo"]];
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
    
    NSString* aResponse = [self.cellData objectForKey:@"Answer"];
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseSegmentedControl.selectedSegmentIndex = [self retrieveIndexByTitle:aResponse];
//        [contentRankingHashMap setObject:aResponse forKey:aResponse];
    } else {
        self.responseSegmentedControl.selectedSegmentIndex = [self.segmentItemList count] - 1;
    }
    self.previousSegmentIndex = self.responseSegmentedControl.selectedSegmentIndex;    
    [self.delegate inputFinishedWithData:[self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex] forIndexpath:self.indexPath];
    for (int i = 0; i < [self.segmentItemList count] - 1; i++) {
        NSString* tmpSegmentTitle = [self.segmentItemList objectAtIndex:i];
        NSString* contentRankingAnswer = [contentRankingHashMap objectForKey:tmpSegmentTitle];
        if (contentRankingAnswer != nil) {
            if (![contentRankingAnswer isEqualToString:[self.cellData objectForKey:@"Answer"]]) {
                [self.responseSegmentedControl setEnabled:NO forSegmentAtIndex:i];                
            }            
        }
    }
    [self configNarrativeSingleTapGesture];
    [self configNarrativeWithLabel:self.narrative];
}

- (IBAction)segmentedValueChange:(id)sender {    
    NSString* selectedSegmentTitle = [self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex];
    NSMutableDictionary* auxRankingHashMap = [self.delegate retrieveRankingHashMap];
    NSMutableDictionary* contentRankingHashMap = [auxRankingHashMap objectForKey:[self.cellData objectForKey:@"sectionNo"]];
    if (contentRankingHashMap == nil) {
        contentRankingHashMap = [NSMutableDictionary dictionary];
        [auxRankingHashMap setObject:contentRankingHashMap forKey:[self.cellData objectForKey:@"sectionNo"]];
    }
    if (![selectedSegmentTitle isEqualToString:[GlobalSharedClass shared].unknownText] && [contentRankingHashMap objectForKey:selectedSegmentTitle] == nil) {
        [contentRankingHashMap setObject:selectedSegmentTitle forKey:selectedSegmentTitle];
    } else {
        self.responseSegmentedControl.selectedSegmentIndex = [self.segmentItemList count] - 1;
    }
    NSString* previousSegmentTitle = [self.segmentItemList objectAtIndex:self.previousSegmentIndex];
    if (![previousSegmentTitle isEqualToString:[GlobalSharedClass shared].unknownText]) {
        [contentRankingHashMap removeObjectForKey:previousSegmentTitle];
    }
    selectedSegmentTitle = [self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex];
    self.previousSegmentIndex = self.responseSegmentedControl.selectedSegmentIndex;
    [self.delegate inputFinishedWithData:selectedSegmentTitle forIndexpath:self.indexPath];
    [self.delegate refreshSurveyList];
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

@end
