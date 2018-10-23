//
//  QueryOrderTaskStringViewTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"
#import <QuartzCore/QuartzCore.h>

@interface QueryOrderTaskStringViewTableCell : QueryOrderTMBaseTableCell<UITextViewDelegate> {
    UILabel* _fieldDesc;
    UITextView* _contentString;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextView* contentString;

@end
