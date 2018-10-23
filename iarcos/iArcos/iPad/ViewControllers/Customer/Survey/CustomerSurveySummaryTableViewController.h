//
//  CustomerSurveySummaryTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 20/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ArcosStackedController.h"
#import "CustomerSurveySummaryDataManager.h"
#import "CallGenericServices.h"
#import "CustomerSurveySummaryTableViewCell.h"
#import "CustomerSurveyDetailsTableViewController.h"

@interface CustomerSurveySummaryTableViewController : UITableViewController {
    CustomerSurveySummaryDataManager* _customerSurveySummaryDataManager;
    CallGenericServices* _callGenericServices;
    NSNumber* _locationIUR;
}

@property(nonatomic, retain) CustomerSurveySummaryDataManager* customerSurveySummaryDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSNumber* locationIUR;

@end
