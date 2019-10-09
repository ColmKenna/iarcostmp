//
//  CustomerSurveyBooleanTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface CustomerSurveyBooleanTableCell : CustomerSurveyBaseTableCell {
//    IBOutlet UILabel* narrative;
    IBOutlet UISegmentedControl* responseSegmentedControl;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UISegmentedControl* responseSegmentedControl;

-(IBAction)switchValueChange:(id)sender;
//-(void)handleSingleTapGesture4Narrative:(id)sender;
-(NSString*)responseActualValueWithSelectedIndex:(NSInteger)selectedIndex;

@end
