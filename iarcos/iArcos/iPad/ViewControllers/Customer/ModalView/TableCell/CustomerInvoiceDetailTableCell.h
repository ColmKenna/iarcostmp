//
//  CustomerInvoiceDetailTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 29/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerInvoiceDetailTableCell : UITableViewCell {
    IBOutlet UILabel* qty;
    IBOutlet UILabel* bonusQty;
    IBOutlet UILabel* description;
    IBOutlet UILabel* value;    
}

@property (nonatomic,retain) IBOutlet UILabel* qty;
@property (nonatomic,retain) IBOutlet UILabel* bonusQty;
@property (nonatomic,retain) IBOutlet UILabel* description;
@property (nonatomic,retain) IBOutlet UILabel* value;

@end
