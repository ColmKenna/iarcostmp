//
//  CustomerOrderTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerOrderTableCell : UITableViewCell {
    IBOutlet UILabel* orderNumber;
    IBOutlet UILabel* date;
    IBOutlet UILabel* wholesaler;
    IBOutlet UILabel* value;
    IBOutlet UILabel* delivery;
    IBOutlet UILabel* employee;
    NSString* orderIUR;
}

@property (nonatomic,retain) IBOutlet UILabel* orderNumber;
@property (nonatomic,retain) IBOutlet UILabel* date;
@property (nonatomic,retain) IBOutlet UILabel* wholesaler;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) IBOutlet UILabel* delivery;
@property (nonatomic,retain) IBOutlet UILabel* employee;
@property (nonatomic,retain) NSString* orderIUR;

@end
