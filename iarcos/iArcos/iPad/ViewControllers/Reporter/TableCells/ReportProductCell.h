//
//  ReportProductCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportCell.h"

@interface ReportProductCell : ReportCell{
    IBOutlet UILabel* code;
    IBOutlet UILabel* description;
    IBOutlet UILabel* EAN;
    IBOutlet UILabel* catalog;
    IBOutlet UILabel* active;
    IBOutlet UILabel* lastorderdate;
}


@property(nonatomic,retain) IBOutlet UILabel* code;
@property(nonatomic,retain) IBOutlet UILabel* description;
@property(nonatomic,retain) IBOutlet UILabel* EAN;
@property(nonatomic,retain) IBOutlet UILabel* catalog;
@property(nonatomic,retain) IBOutlet UILabel* active;
@property(nonatomic,retain) IBOutlet UILabel* lastorderdate;

@end
