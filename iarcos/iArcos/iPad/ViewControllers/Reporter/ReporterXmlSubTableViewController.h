//
//  ReporterXmlSubTableViewController.h
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReporterXmlSubTableHeaderView.h"
#import "ReporterXmlSubDataManager.h"
#import "ReporterXmlSubTableViewCell.h"
#import "ArcosUtils.h"
#import "ReporterXmlSubTableFooterView.h"
#import "ReporterXmlSubTableDelegate.h"

@interface ReporterXmlSubTableViewController : UITableViewController {
    id<ReporterXmlSubTableDelegate> _subTableDelegate;
    ReporterXmlSubTableHeaderView* _reporterXmlSubTableHeaderView;
    ReporterXmlSubDataManager* _reporterXmlSubDataManager;
    ReporterXmlSubTableFooterView* _reporterXmlSubTableFooterView;
}

@property(nonatomic, assign) id<ReporterXmlSubTableDelegate> subTableDelegate;
@property(nonatomic, retain) IBOutlet ReporterXmlSubTableHeaderView* reporterXmlSubTableHeaderView;
@property(nonatomic, retain) ReporterXmlSubDataManager* reporterXmlSubDataManager;
@property(nonatomic, retain) IBOutlet ReporterXmlSubTableFooterView* reporterXmlSubTableFooterView;


@end

