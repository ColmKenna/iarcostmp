//
//  CustomerSurveyBooleanTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyBooleanTableCell.h"

@implementation CustomerSurveyBooleanTableCell
//@synthesize narrative;
@synthesize responseSegmentedControl;

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

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    [self processIndicatorButton];
//    NSLog(@"aResponse from boolean dict is : %@", theData);
    self.narrative.text = [theData objectForKey:@"Narrative"];
    NSString* aResponse = [theData objectForKey:@"Answer"];
//    NSLog(@"aResponse from boolean is %@", aResponse);
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        self.responseSegmentedControl.selectedSegmentIndex = [aResponse isEqualToString:@"1"] ? 0 : 1;
        
    } else {
        self.responseSegmentedControl.selectedSegmentIndex = 2;
    }
    
    //set the default value
    NSString* returnValue = [self responseActualValueWithSelectedIndex:self.responseSegmentedControl.selectedSegmentIndex];
    [self.delegate inputFinishedWithData:returnValue forIndexpath:self.indexPath];
//    for (UIGestureRecognizer* recognizer in self.narrative.gestureRecognizers) {
//        [self.narrative removeGestureRecognizer:recognizer];
//    }
//    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
//    [self.narrative addGestureRecognizer:singleTap2];
//    [singleTap2 release];
    [self configNarrativeSingleTapGesture];
    [self configNarrativeWithLabel:self.narrative];
    int questionType = [[self.cellData objectForKey:@"QuestionType"] intValue];
    if (questionType == 1) {
        NSMutableAttributedString* attributedNarrativeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.cellData objectForKey:@"Narrative"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
        CGRect rect = [attributedNarrativeString boundingRectWithSize:CGSizeMake([self.delegate retrieveSurveyTableView].frame.size.width - 25 - 206, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [attributedNarrativeString release];
        if (rect.size.height < 21.0) {
            rect.size.height = 21.0;
        }
        self.narrative.frame = CGRectMake(self.narrative.frame.origin.x, self.narrative.frame.origin.y, self.narrative.frame.size.width, rect.size.height);
    }
}

-(IBAction)switchValueChange:(id)sender {
    UISegmentedControl* segment = (UISegmentedControl*)sender;
    NSString* returnValue = [self responseActualValueWithSelectedIndex:segment.selectedSegmentIndex];
    [self.delegate inputFinishedWithData:returnValue forIndexpath:self.indexPath];
}

-(void)dealloc {
//    if (self.narrative != nil) { self.narrative = nil; }
    if (self.responseSegmentedControl != nil) { self.responseSegmentedControl = nil; }
    
    [super dealloc];
}

//-(void)handleSingleTapGesture4Narrative:(id)sender {
//    [ArcosUtils showMsg:[self.cellData objectForKey:@"tooltip"] delegate:nil];
//}

-(NSString*)responseActualValueWithSelectedIndex:(NSInteger)selectedIndex {
    NSString* returnValue = @"";
    switch (selectedIndex) {
        case 0: {
            returnValue = @"1";
        }
            break;
        case 1: {
            returnValue = @"0";
        }
            break;
        case 2: {
            returnValue = [GlobalSharedClass shared].unknownText;
        }
            break;
            
        default:
            break;
    }
    return returnValue;
}
@end
