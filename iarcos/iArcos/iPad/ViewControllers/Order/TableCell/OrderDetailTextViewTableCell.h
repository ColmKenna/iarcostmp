//
//  OrderDetailTextViewTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ArcosUtils.h"

@interface OrderDetailTextViewTableCell : OrderDetailBaseTableCell<UITextViewDelegate> {
    UILabel* _fieldNameLabel;
    UITextView* _fieldValueTextView;
    BOOL _isStyleSet;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextView* fieldValueTextView;
@property(nonatomic, assign) BOOL isStyleSet;

@end
