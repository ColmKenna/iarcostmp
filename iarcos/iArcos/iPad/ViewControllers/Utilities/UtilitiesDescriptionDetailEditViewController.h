//
//  UtilitiesDescriptionDetailEditViewController.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "CustomerContactBaseTableCell.h"
#import "ControllNavigationBarDelegate.h"
#import "UtilitiesDescriptionDetailEditViewDataManager.h"
#import "ArcosCoreData.h"
#import "GenericRefreshParentContentDelegate.h"
#import "CustomisePresentViewControllerDelegate.h"

@interface UtilitiesDescriptionDetailEditViewController : UITableViewController <CustomerContactInputDelegate, UIAlertViewDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    id<ModelViewDelegate> _delegate;
    NSMutableArray* _tableCellList;
    CustomerContactBaseTableCell* _codeCell;
    CustomerContactBaseTableCell* _detailsCell;
    CustomerContactBaseTableCell* _activeCell;
    CustomerContactBaseTableCell* _forDetailingCell;
    NSString* _actionType;
    NSMutableDictionary* _tableCellData;
    UtilitiesDescriptionDetailEditViewDataManager* _dataManager;
    NSString* _descrTypecode;
    int rowPointer;
    BOOL isAllowedToShowForDetailing;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic, retain) NSMutableArray* tableCellList;   
@property(nonatomic, retain) NSString* actionType;
@property(nonatomic, retain) IBOutlet CustomerContactBaseTableCell* codeCell;
@property(nonatomic, retain) IBOutlet CustomerContactBaseTableCell* detailsCell;
@property(nonatomic, retain) IBOutlet CustomerContactBaseTableCell* activeCell;
@property(nonatomic, retain) IBOutlet CustomerContactBaseTableCell* forDetailingCell;
@property(nonatomic, retain) NSMutableDictionary* tableCellData;
@property(nonatomic, retain) UtilitiesDescriptionDetailEditViewDataManager* dataManager;
@property(nonatomic, retain) NSString* descrTypecode;

- (void)updateDescrDetailRecord;
- (void)submitProcessCenter;
- (void)createDescrDetailRecord;
- (BOOL)validateUpdateProcess;
- (BOOL)validateCreateProcess;

@end
