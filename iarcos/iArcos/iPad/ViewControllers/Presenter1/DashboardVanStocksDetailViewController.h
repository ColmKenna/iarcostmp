//
//  DashboardVanStocksDetailViewController.h
//  iArcos
//
//  Created by David Kilmartin on 05/09/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVanStocksDetailTableCellFactory.h"
#import "ArcosUtils.h"
#import "DashboardVanStocksDetailTableViewControllerDelegate.h"
#import "ArcosCoreData.h"

@interface DashboardVanStocksDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DashboardVanStocksDetailTableCellDelegate> {
    UINavigationBar* _myNavigationBar;
    UILabel* _productCodeLabel;
    UILabel* _descriptionLabel;
    UITableView* _myTableView;
    id<DashboardVanStocksDetailTableViewControllerDelegate> _presentDelegate;
    NSDictionary* _cellData;
    NSString* _dataTitle;
    NSString* _actionTitle;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    DashboardVanStocksDetailTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) IBOutlet UILabel* productCodeLabel;
@property(nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, assign) id<DashboardVanStocksDetailTableViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) NSDictionary* cellData;
@property(nonatomic, retain) NSString* dataTitle;
@property(nonatomic, retain) NSString* actionTitle;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) DashboardVanStocksDetailTableCellFactory* tableCellFactory;

@end
