//
//  ReportInvoiceCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportCell.h"

@interface ReportInvoiceCell : ReportCell{
    IBOutlet UILabel* name;
    IBOutlet UILabel* address;
    IBOutlet UILabel* type;
    IBOutlet UILabel* value;
    IBOutlet UILabel* customerRef;
    IBOutlet UILabel* employee;
    IBOutlet UILabel* date;
    IBOutlet UILabel* wholesaler;
    IBOutlet UILabel* details;//means invoice type
}


@property(nonatomic,retain) IBOutlet UILabel* name;
@property(nonatomic,retain) IBOutlet UILabel* address;
@property(nonatomic,retain) IBOutlet UILabel* type;
@property(nonatomic,retain) IBOutlet UILabel* value;
@property(nonatomic,retain) IBOutlet UILabel* customerRef;
@property(nonatomic,retain) IBOutlet UILabel* employee;
@property(nonatomic,retain) IBOutlet UILabel* date;
@property(nonatomic,retain) IBOutlet UILabel* wholesaler;
@property(nonatomic,retain) IBOutlet IBOutlet UILabel* details;

@end
