//
//  CustomerNotBuyTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 14/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerNotBuyTableCell : UITableViewCell {    
    IBOutlet UILabel* productCode;
    IBOutlet UILabel* description;
    IBOutlet UILabel* lastOrdered;
}

@property(nonatomic,retain) IBOutlet UILabel* productCode;
@property(nonatomic,retain) IBOutlet UILabel* description;
@property(nonatomic,retain) IBOutlet UILabel* lastOrdered;
    

@end
