//
//  CustomerOrderDetailTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerOrderDetailTableCell : UITableViewCell {
    IBOutlet UILabel* qty;
    IBOutlet UILabel* bon;
    IBOutlet UILabel* discount;
    IBOutlet UILabel* description;
    IBOutlet UILabel* price;
    IBOutlet UILabel* value;
}

@property (nonatomic,retain) IBOutlet UILabel* qty;
@property (nonatomic,retain) IBOutlet UILabel* bon;
@property (nonatomic,retain) IBOutlet UILabel* discount;
@property (nonatomic,retain) IBOutlet UILabel* description;
@property (nonatomic,retain) IBOutlet UILabel* price;
@property (nonatomic,retain) IBOutlet UILabel* value;

@end
