//
//  QueryOrderMemoBooleanTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"

@interface QueryOrderMemoBooleanTableCell : QueryOrderTMBaseTableCell {
    UILabel* _fieldDesc;
    UISwitch* _contentString;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UISwitch* contentString;

-(IBAction)switchValueChange:(id)sender;

@end
