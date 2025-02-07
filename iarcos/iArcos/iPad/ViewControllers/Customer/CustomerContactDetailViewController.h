//
//  CustomerContactDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 25/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseDetailViewController.h"
#import "CustomerInfoTableViewController.h"
#import "CustomerContactDetailTableCell.h"
#import "CustomerContactDetailTableCellGenerator.h"
#import "CustomerContactDetailCallTableCellGenerator.h"
#import "CustomerContactDetailCallDataManager.h"

@interface CustomerContactDetailViewController : CustomerBaseDetailViewController <UISearchBarDelegate, GenericRefreshParentContentDelegate, CheckLocationIURTemplateDelegate>{
    NSMutableArray* myCustomers;
    NSMutableArray* customerNames;
    CustomerInfoTableViewController* myCustomerInfoViewController;
//    UIPopoverController* groupPopover;
    
    NSMutableArray* sortKeys;
    NSMutableDictionary* _customerSections;
    
    IBOutlet UISearchBar* mySearchBar;
    NSMutableArray* _tableData;//will be storing data that will be displayed in table
    NSMutableArray *searchedData;//will be storing data matching with the search string
    BOOL searching;
    BOOL letUserSelectRow;
    BOOL needIndexView;
    
    //hold the bar button
    //    UIBarButtonItem* myBarButtonItem;        
    CheckLocationIURTemplateProcessor* _checkLocationIURTemplateProcessor;
    id<CustomerContactDetailTableCellGeneratorDelegate> _customerContactDetailTableCellGeneratorDelegate;
    CustomerContactDetailCallDataManager* _customerContactDetailCallDataManager;
}
@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;

@property(nonatomic,retain) NSMutableArray* myCustomers;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,retain) NSMutableArray* tableData;
@property(nonatomic,retain) NSMutableArray *searchedData;
@property (nonatomic, retain) CheckLocationIURTemplateProcessor* checkLocationIURTemplateProcessor;
@property (nonatomic, retain) id<CustomerContactDetailTableCellGeneratorDelegate> customerContactDetailTableCellGeneratorDelegate;
@property (nonatomic, retain) CustomerContactDetailCallDataManager* customerContactDetailCallDataManager;


//-(void)resetCustomer:(NSMutableArray*)customers;
-(void)resetList:(NSMutableArray*)aList;
-(void)sortCustomers:(NSMutableArray*)customers;
-(NSMutableDictionary*)objectFromName:(NSString*)name;
-(NSMutableArray*)objectsFromName:(NSString*)name;

@end
