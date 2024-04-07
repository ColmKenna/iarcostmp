//
//  CustomerBaseDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 16/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "ControllNavigationBarDelegate.h"
#import "GenericMasterTemplateDelegate.h"
#import "UIViewController+ArcosStackedController.h"
#import "CheckLocationIURTemplateProcessor.h"

@interface CustomerBaseDetailViewController : UITableViewController<SubstitutableDetailViewController, GenericMasterTemplateDelegate> {
    UIBarButtonItem* myBarButtonItem;    
    id<ControllNavigationBarDelegate> _navigationDelegate;
    NSIndexPath* _currentIndexPath;
    NSString* _requestSourceName;
}

@property(nonatomic,retain) UIBarButtonItem* myBarButtonItem;
@property(nonatomic,retain) id<ControllNavigationBarDelegate> navigationDelegate;
@property (nonatomic, retain) NSIndexPath* currentIndexPath;
@property (nonatomic, retain) NSString* requestSourceName;

-(NSMutableDictionary*)getSelectedCellData;
-(void)resetCurrentOrderAndWholesaler:(NSNumber*)locationIUR;
-(NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath;
-(void)resetCustomer:(NSMutableArray*)customers;
- (void)configWholesalerLogo;
- (void)syncCustomerContactViewController;
- (void)filterPressed:(id)sender;

@end
