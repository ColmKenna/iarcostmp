//
//  DashboardJourneyHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 08/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface DashboardJourneyHeaderView : UIView {
    UILabel* _customerName;
    LeftBlueSeparatorUILabel* _status;
    HorizontalBlueSeparatorUILabel* _horizontalSeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* customerName;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* status;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* horizontalSeparator;

@end
