//
//  ReportLocationCell.h
//  Arcos
//
//  Created by David Kilmartin on 04/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportCell.h"

@interface ReportLocationCell : ReportCell{
    IBOutlet UILabel* name;
    IBOutlet UILabel* address;
    IBOutlet UILabel* county;
    IBOutlet UILabel* type;
    IBOutlet UILabel* lastCall;
    IBOutlet UILabel* lastOrderDate;
    IBOutlet UILabel* phoneNumber;
}
@property(nonatomic,retain) IBOutlet UILabel* name;
@property(nonatomic,retain) IBOutlet UILabel* address;
@property(nonatomic,retain) IBOutlet UILabel* county;
@property(nonatomic,retain) IBOutlet UILabel* type;
@property(nonatomic,retain) IBOutlet UILabel* lastCall;
@property(nonatomic,retain) IBOutlet UILabel* lastOrderDate;
@property(nonatomic,retain) IBOutlet UILabel* phoneNumber;


@end