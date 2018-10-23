//
//  DashboardJourneyTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 08/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface DashboardJourneyTableViewCell : UITableViewCell {
    UILabel* _customerName;
    UILabel* _customerAddress;
    LeftBlueSeparatorUILabel* _customerStatus;
    HorizontalBlueSeparatorUILabel* _mySeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* customerName;
@property(nonatomic, retain) IBOutlet UILabel* customerAddress;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* customerStatus;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* mySeparator;

@end
