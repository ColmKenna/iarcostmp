//
//  CustomerInvoiceTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerInvoiceTableCell : UITableViewCell {
    IBOutlet UILabel* date;
    IBOutlet UILabel* reference;
    IBOutlet UILabel* wholesaler;
    IBOutlet UILabel* type;
    IBOutlet UILabel* value;
    NSString* IUR;
}

@property (nonatomic,retain) IBOutlet UILabel* date;
@property (nonatomic,retain) IBOutlet UILabel* reference;
@property (nonatomic,retain) IBOutlet UILabel* wholesaler;
@property (nonatomic,retain) IBOutlet UILabel* type;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) NSString* IUR;

@end
