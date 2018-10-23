//
//  CustomerSurveySliderBarTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySliderBarTableCell.h"

@implementation CustomerSurveySliderBarTableCell
@synthesize narrative;
@synthesize sliderValue;
@synthesize responseLimitSlider;
@synthesize lowRangeValue;
@synthesize highRangeValue;

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
    if (self.sliderValue != nil) { self.sliderValue = nil; }
    if (self.responseLimitSlider != nil) { self.responseLimitSlider = nil; }    
    if (self.lowRangeValue != nil) { self.lowRangeValue = nil; }
    if (self.highRangeValue != nil) { self.highRangeValue = nil; }    
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    [self processIndicatorButton];
    self.narrative.text = [theData objectForKey:@"Narrative"];
    NSString* responseLimitsDataSource = [theData objectForKey:@"ResponseLimits"];
    NSArray* responseLimitsArray = [responseLimitsDataSource componentsSeparatedByString:@"|"];
    //sample data format Apples|Oranges|300|600
    //new sample data format 300|600|Apples|Oranges
    if ([responseLimitsArray count] != 4) {
        [ArcosUtils showMsg:[NSString stringWithFormat:@"%@ is not correctly configured.", self.narrative.text] delegate:nil];
        return;
    }
    if (![ArcosValidator isDecimalWithUnlimitedPlaces:[responseLimitsArray objectAtIndex:0]] || ![ArcosValidator isDecimalWithUnlimitedPlaces:[responseLimitsArray objectAtIndex:1]]) {
        [ArcosUtils showMsg:[NSString stringWithFormat:@"%@ is not correctly configured.", self.narrative.text] delegate:nil];
        return;
    }
    NSNumber* lowRange = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[responseLimitsArray objectAtIndex:0]]];
    NSNumber* highRange = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[responseLimitsArray objectAtIndex:1]]];
    self.responseLimitSlider.minimumValue = [lowRange floatValue];
    self.responseLimitSlider.maximumValue = [highRange floatValue];
    self.lowRangeValue.text = [responseLimitsArray objectAtIndex:2];
    self.highRangeValue.text = [responseLimitsArray objectAtIndex:3];
    
    NSString* aResponse = [theData objectForKey:@"Answer"];
//    NSLog(@"slider bar value is %@", aResponse);
    if (aResponse != nil && ![aResponse isEqualToString:@""]) {
//        NSLog(@"2 slider bar value is  %f", [aResponse floatValue]);
        self.responseLimitSlider.value = [aResponse floatValue];
    } else {        
        self.responseLimitSlider.value = ([lowRange floatValue] + [highRange floatValue]) / 2.0;
    } 
    
    //set the default value
    NSString* returnValue = [ArcosUtils convertIntToString:(int)(self.responseLimitSlider.value+0.5)];
    [self.delegate inputFinishedWithData:returnValue forIndexpath:self.indexPath];
    
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
    [self.narrative addGestureRecognizer:singleTap2];
    [singleTap2 release];
}

-(IBAction)sliderBarValueChange:(id)sender {
    UISlider* sliderBar = (UISlider*)sender;
//    NSString* returnValue = sw.on ? @"1" : @"0";
    [self.delegate inputFinishedWithData:[ArcosUtils convertIntToString:(int)(sliderBar.value+0.5)] forIndexpath:self.indexPath];
}

-(void)handleSingleTapGesture4Narrative:(id)sender {
    [ArcosUtils showMsg:[self.cellData objectForKey:@"tooltip"] delegate:nil];
}

@end
