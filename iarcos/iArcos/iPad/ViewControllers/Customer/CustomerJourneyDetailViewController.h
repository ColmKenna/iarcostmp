//
//  CustomerJourneyDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 16/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseDetailViewController.h"
#import "CustomerJourneyDataManager.h"
#import "CustomerInfoTableViewController.h"
#import "CustomerJourneyStartDateViewController.h"
#import "CustomerJourneyDetailTableViewCell.h"
#import "CustomerJourneyDetailDateViewController.h"
#import "CustomerJourneyDetailTableCellGenerator.h"
#import "CustomerJourneyDetailCallTableCellGenerator.h"
#import "CustomerJourneyDetailCallDataManager.h"

@interface CustomerJourneyDetailViewController : CustomerBaseDetailViewController <ModelViewDelegate, GenericRefreshParentContentDelegate, CustomerJourneyStartDateDelegate,CheckLocationIURTemplateDelegate, CustomerJourneyDetailDateViewControllerDelegate>{
    CustomerJourneyDataManager* _customerJourneyDataManager;
//    UIPopoverController* _actionPopoverController;
    CustomerJourneyStartDateViewController* _cjsdvc;
    UIBarButtonItem* _actionButton;
    UINavigationController* _auxNavigationController;
    CheckLocationIURTemplateProcessor* _checkLocationIURTemplateProcessor;
    id<CustomerListingTableCellGeneratorDelegate> _customerListingTableCellGeneratorDelegate;
    CustomerJourneyDetailCallDataManager* _customerJourneyDetailCallDataManager;
}

@property (nonatomic, retain) CustomerJourneyDataManager* customerJourneyDataManager;
//@property (nonatomic, retain) UIPopoverController* actionPopoverController;
@property (nonatomic, retain) CustomerJourneyStartDateViewController* cjsdvc;
@property (nonatomic, retain) UIBarButtonItem* actionButton;
@property (nonatomic, retain) UINavigationController* auxNavigationController;
@property (nonatomic, retain) CheckLocationIURTemplateProcessor* checkLocationIURTemplateProcessor;
@property (nonatomic, retain) id<CustomerListingTableCellGeneratorDelegate> customerListingTableCellGeneratorDelegate;
@property (nonatomic, retain) CustomerJourneyDetailCallDataManager* customerJourneyDetailCallDataManager;

-(void)resetTableList:(NSString*)aJourneyDate;
//-(NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)resetTableListFromDateWheels:(NSString*)aJourneyDate journeyIUR:(NSNumber*)aJourneyIUR;
- (void)resetTableListFromDateWheelsRemoveButton:(NSString*)aJourneyDate;
- (void)callHeaderProcessor;

@end
