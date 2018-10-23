//
//  CustomerStringTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseTableCell.h"

@interface CustomerStringTableCell : CustomerBaseTableCell {
    IBOutlet UILabel* fieldDesc;
    IBOutlet UITextField* contentString;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextField* contentString;

-(IBAction)textInputEnd:(id)sender;

@end
