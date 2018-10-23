//
//  UtilitiesDescriptionDetailEditTextTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerContactBaseTableCell.h"

@interface UtilitiesDescriptionDetailEditTextTableCell : CustomerContactBaseTableCell {
    UILabel* _narrative;
    UITextField* contentString;
}

@property (nonatomic, retain) IBOutlet UILabel* narrative;
@property (nonatomic, retain) IBOutlet UITextField* contentString;

-(IBAction)textInputEnd:(id)sender;

@end
