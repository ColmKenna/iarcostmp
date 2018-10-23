//
//  ArcosMailRecipientTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosMailBaseTableViewCell.h"
#import "HorizontalHalfDividerUILabel.h"

@interface ArcosMailRecipientTableViewCell : ArcosMailBaseTableViewCell <UITextFieldDelegate>{
    UILabel* _fieldDesc;
    UITextField* _fieldContent;
    HorizontalHalfDividerUILabel* _horizontalHalfDivider;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic, retain) IBOutlet UITextField* fieldContent;
@property(nonatomic, retain) IBOutlet HorizontalHalfDividerUILabel* horizontalHalfDivider;

@end
