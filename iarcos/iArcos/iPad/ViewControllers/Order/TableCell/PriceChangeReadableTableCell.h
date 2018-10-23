//
//  PriceChangeReadableTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceChangeBaseTableCell.h"

@interface PriceChangeReadableTableCell : PriceChangeBaseTableCell {
    UITextField* _fieldDataTextField;
}

@property(nonatomic, retain) IBOutlet UITextField* fieldDataTextField;

@end
