//
//  CustomerSurveyKeyboardTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface CustomerSurveyKeyboardTableCell : CustomerSurveyBaseTableCell {
//    IBOutlet UILabel* narrative;
    IBOutlet UITextField* responseLimits;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UITextField* responseLimits;

-(IBAction)textInputEnd:(id)sender;
//-(void)handleSingleTapGesture4Narrative:(id)sender;

@end
