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

@interface ReporterXmlSubTableViewController : UITableViewController {
    ReporterXmlSubTableHeaderView* _reporterXmlSubTableHeaderView;
    ReporterXmlSubDataManager* _reporterXmlSubDataManager;
}

@property(nonatomic, retain) IBOutlet ReporterXmlSubTableHeaderView* reporterXmlSubTableHeaderView;
@property(nonatomic, retain) ReporterXmlSubDataManager* reporterXmlSubDataManager;


@end

