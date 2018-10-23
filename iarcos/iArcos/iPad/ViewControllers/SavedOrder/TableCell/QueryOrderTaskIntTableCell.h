//
//  QueryOrderTaskIntTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"

@interface QueryOrderTaskIntTableCell : QueryOrderTMBaseTableCell {
    UILabel* _fieldDesc;
    UITextField* _contentString;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextField* contentString;

@end
