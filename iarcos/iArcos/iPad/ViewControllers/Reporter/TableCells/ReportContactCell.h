//
//  ReportContactCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportCell.h"
@interface ReportContactCell : ReportCell{
    IBOutlet UILabel* name;
    IBOutlet UILabel* address;
    IBOutlet UILabel* type;
    IBOutlet UILabel* phoneNumber;
    IBOutlet UILabel* mobileNumber;
    IBOutlet UILabel* lastCall;

}


@property(nonatomic,retain) IBOutlet UILabel* name;
@property(nonatomic,retain) IBOutlet UILabel* address;
@property(nonatomic,retain) IBOutlet UILabel* type;
@property(nonatomic,retain) IBOutlet UILabel* phoneNumber;
@property(nonatomic,retain) IBOutlet UILabel* mobileNumber;
@property(nonatomic,retain) IBOutlet UILabel* lastCall;
@end
