//
//  CustomerFlagTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTextViewInputTableCell.h"

@interface CustomerFlagTableCell : GenericTextViewInputTableCell {
    UILabel* _flagText;
    UIImageView* _myImageView;
}

@property(nonatomic, retain) IBOutlet UILabel* flagText;
@property(nonatomic, retain) IBOutlet UIImageView* myImageView;

@end
