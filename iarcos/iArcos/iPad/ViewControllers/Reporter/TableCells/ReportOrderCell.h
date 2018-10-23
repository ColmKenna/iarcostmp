//
//  ReportOrderCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportCell.h"

@interface ReportOrderCell : ReportCell{
    IBOutlet UILabel* name;
    IBOutlet UILabel* address;
    IBOutlet UILabel* type;
    IBOutlet UILabel* value;
    IBOutlet UILabel* orderDate;
    IBOutlet UILabel* employee;
    IBOutlet UILabel* deliveryDate;

 
}


@property(nonatomic,retain) IBOutlet UILabel* name;
@property(nonatomic,retain) IBOutlet UILabel* address;
@property(nonatomic,retain) IBOutlet UILabel* type;
@property(nonatomic,retain) IBOutlet UILabel* value;
@property(nonatomic,retain) IBOutlet UILabel* orderDate;
@property(nonatomic,retain) IBOutlet UILabel* employee;
@property(nonatomic,retain) IBOutlet UILabel* deliveryDate;
@end
