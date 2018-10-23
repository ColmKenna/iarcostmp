//
//  UtilitiesDescriptionDetailEditBoolTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerContactBaseTableCell.h"

@interface UtilitiesDescriptionDetailEditBoolTableCell : CustomerContactBaseTableCell {
    UILabel* _narrative;
    UISwitch* contentSwitch;
}

@property (nonatomic, retain) IBOutlet UILabel* narrative;
@property (nonatomic, retain) IBOutlet UISwitch* contentSwitch;

-(IBAction)switchValueChange:(id)sender;

@end
