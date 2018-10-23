//
//  DashboardVanStocksDetailTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVanStocksDetailTableCellFactory.h"
#import "ArcosUtils.h"
#import "DashboardVanStocksDetailTableViewControllerDelegate.h"
#import "ArcosCoreData.h"

@interface DashboardVanStocksDetailTableViewController : UITableViewController <DashboardVanStocksDetailTableCellDelegate>{
    id<DashboardVanStocksDetailTableViewControllerDelegate> _presentDelegate;
    NSDictionary* _cellData;
    NSString* _dataTitle;
    NSString* _actionTitle;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    DashboardVanStocksDetailTableCellFactory* _tableCellFactory;
}

@property(nonatomic, assign) id<DashboardVanStocksDetailTableViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) NSDictionary* cellData;
@property(nonatomic, retain) NSString* dataTitle;
@property(nonatomic, retain) NSString* actionTitle;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) DashboardVanStocksDetailTableCellFactory* tableCellFactory;



@end
