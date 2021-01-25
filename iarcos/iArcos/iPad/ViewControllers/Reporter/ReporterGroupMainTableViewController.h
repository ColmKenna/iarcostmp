//
//  ReporterGroupMainTableViewController.h
//  iArcos
//
//  Created by Richard on 18/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReporterGroupMainDataManager.h"
#import "CallGenericServices.h"
#import "MainPresenterTableViewCell.h"
#import "ReporterMainViewController.h"


@interface ReporterGroupMainTableViewController : UITableViewController <MainPresenterTableViewCellDelegate> {
    ReporterGroupMainDataManager* _reporterGroupMainDataManager;
    CallGenericServices* _callGenericServices;
    BOOL _isReportSet;
}

@property(nonatomic, retain) ReporterGroupMainDataManager* reporterGroupMainDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, assign) BOOL isReportSet;

@end


