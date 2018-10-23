//
//  UtilitiesDescriptionDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 24/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "UtilitiesDescriptionDetailTableCell.h"
#import "UtilitiesDescriptionDetailEditWrapperViewController.h"

@interface UtilitiesDescriptionDetailViewController : UITableViewController<ModelViewDelegate, ControllNavigationBarDelegate, GenericRefreshParentContentDelegate,CustomisePresentViewControllerDelegate> {
    id<ControllNavigationBarDelegate> _navigationDelegate;
    NSString* _descrTypeCode;
    NSMutableArray* _displayList;
    UILabel* _codeLabel;
    UILabel* _detailLabel;
    UIView* tableHeader;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}

@property(nonatomic, assign) id<ControllNavigationBarDelegate> navigationDelegate;
@property(nonatomic, retain) NSString* descrTypeCode;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) IBOutlet UILabel* codeLabel;
@property(nonatomic, retain) IBOutlet UILabel* detailLabel;
@property(nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;

@end
