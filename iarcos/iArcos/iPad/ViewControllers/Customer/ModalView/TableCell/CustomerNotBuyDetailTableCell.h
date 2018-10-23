//
//  CustomerNotBuyDetailTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerNotBuyDetailTableCell : UITableViewCell {
    UILabel* _myDescription;
    UILabel* _lastOrdered;
}

@property(nonatomic, retain) IBOutlet UILabel* myDescription;
@property(nonatomic, retain) IBOutlet UILabel* lastOrdered;

@end
