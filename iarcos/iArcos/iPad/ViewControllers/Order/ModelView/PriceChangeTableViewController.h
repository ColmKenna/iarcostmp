//
//  PriceChangeTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceChangeDataManager.h"
#import "PriceChangeTableCellFactory.h"
#import "PriceChangeTableViewControllerDelegate.h"
#import "ArcosUtils.h"

@interface PriceChangeTableViewController : UITableViewController <PriceChangeBaseTableCellDelegate> {
    id<PriceChangeTableViewControllerDelegate> _delegate;
    PriceChangeDataManager* _priceChangeDataManager;
    PriceChangeTableCellFactory* _tableCellFactory;
}

@property(nonatomic, assign) id<PriceChangeTableViewControllerDelegate> delegate;
@property(nonatomic, retain) PriceChangeDataManager* priceChangeDataManager;
@property(nonatomic, retain) PriceChangeTableCellFactory* tableCellFactory;

@end
