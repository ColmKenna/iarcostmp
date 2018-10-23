//
//  CustomerSurveySliderBarTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "ArcosUtils.h"
#import "ArcosValidator.h"

@interface CustomerSurveySliderBarTableCell : CustomerSurveyBaseTableCell {
    IBOutlet UILabel* narrative;
    IBOutlet UILabel* sliderValue;
    IBOutlet UISlider* responseLimitSlider;
    IBOutlet UILabel* lowRangeValue;
    IBOutlet UILabel* highRangeValue;
    
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UILabel* sliderValue;
@property(nonatomic, retain) IBOutlet UISlider* responseLimitSlider;
@property(nonatomic, retain) IBOutlet UILabel* lowRangeValue;
@property(nonatomic, retain) IBOutlet UILabel* highRangeValue;

-(IBAction)sliderBarValueChange:(id)sender;
-(void)handleSingleTapGesture4Narrative:(id)sender;

@end
