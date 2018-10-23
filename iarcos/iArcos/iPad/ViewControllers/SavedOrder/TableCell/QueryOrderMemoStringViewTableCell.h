//
//  QueryOrderMemoStringViewTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 30/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"

@interface QueryOrderMemoStringViewTableCell : QueryOrderTMBaseTableCell {
    UILabel* _fieldDesc;
    UITextView* _contentString;
    BOOL _isMaxCalculated;
    int _maximum;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextView* contentString;
@property(nonatomic,assign) BOOL isMaxCalculated;
@property(nonatomic,assign) int maximum;

@end
