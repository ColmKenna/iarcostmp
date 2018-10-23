//
//  QueryOrderTaskControlMemoTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 25/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryOrderTaskControlMemoTableCell : UITableViewCell {
    UILabel* _myControlLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* myControlLabel;

@end
