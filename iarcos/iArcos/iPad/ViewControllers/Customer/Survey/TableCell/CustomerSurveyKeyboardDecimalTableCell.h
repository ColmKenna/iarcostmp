//
//  CustomerSurveyKeyboardDecimalTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "ArcosValidator.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface CustomerSurveyKeyboardDecimalTableCell : CustomerSurveyBaseTableCell <UITextFieldDelegate>{
    IBOutlet UILabel* narrative;
    IBOutlet UITextField* responseLimits;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UITextField* responseLimits;

-(void)handleSingleTapGesture4Narrative:(id)sender;

@end
