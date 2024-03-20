//
//  DetailingCalendarEventBoxListingViewController.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "DetailingCalendarEventBoxListingDataManager.h"


@interface DetailingCalendarEventBoxListingViewController : UIViewController {
    UITableView* _myTableView;
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    DetailingCalendarEventBoxListingDataManager* _detailingCalendarEventBoxListingDataManager;
    
}

@property (nonatomic, retain) IBOutlet UITableView* myTableView;
@property (nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic, retain) DetailingCalendarEventBoxListingDataManager* detailingCalendarEventBoxListingDataManager;


@end


