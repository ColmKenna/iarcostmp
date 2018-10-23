//
//  CustomerSurveySegmentedControlTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 30/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySegmentedControlTableCell.h"

@implementation CustomerSurveySegmentedControlTableCell
@synthesize narrative = _narrative;
@synthesize responseSegmentedControl = _responseSegmentedControl;
@synthesize segmentItemList = _segmentItemList;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.narrative = nil;
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
    
    NSString* aResponse = [theData objectForKey:@"Answer"];
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseSegmentedControl.selectedSegmentIndex = [self retrieveIndexByTitle:aResponse];
        
    } else {
        self.responseSegmentedControl.selectedSegmentIndex = [self.segmentItemList count] - 1;
    }
    
    [self.delegate inputFinishedWithData:[self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex] forIndexpath:self.indexPath];
    [self configNarrativeWithLabel:self.narrative];
}

- (IBAction)segmentedValueChange:(id)sender {    
    NSString* selectedSegmentTitle = [self.segmentItemList objectAtIndex:self.responseSegmentedControl.selectedSegmentIndex];
    [self.delegate inputFinishedWithData:selectedSegmentTitle forIndexpath:self.indexPath];
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
