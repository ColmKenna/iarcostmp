//
//  DashboardVanStocksDetailActionTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVanStocksDetailBaseTableCell.h"

@interface DashboardVanStocksDetailActionTableCell : DashboardVanStocksDetailBaseTableCell {
    UIButton* _actionButton;
}

@property(nonatomic, retain) IBOutlet UIButton* actionButton;

- (IBAction)updateButtonPressed:(id)sender;

@end
