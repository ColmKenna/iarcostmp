//
//  QueryOrderTaskDateTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"

@interface QueryOrderTaskDateTableCell : QueryOrderTMBaseTableCell {
    UILabel* _fieldDesc;
    UILabel* _contentString;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UILabel* contentString;

@end
