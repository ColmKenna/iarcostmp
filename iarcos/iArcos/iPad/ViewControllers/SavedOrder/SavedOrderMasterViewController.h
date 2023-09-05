//
//  SavedOrderMasterViewController.h
//  Arcos
//
//  Created by David Kilmartin on 18/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "SavedOrderTableCell.h"
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "SavedOrderDetailViewController.h"
#import "SavedOrderMasterDataManager.h"
#import "GenericPlainTableCell.h"
#import "QueryOrderTemplateSplitViewController.h"

@interface SavedOrderMasterViewController : UITableViewController <UISplitViewControllerDelegate,SavedOrderDetailViewDelegate>{
    UISplitViewController *splitViewController;
    
//    UIPopoverController *popoverController;
    UIBarButtonItem *rootPopoverButtonItem;
    
    NSArray* tableRows;
    
    NSIndexPath* currentIndexPath;
    SavedOrderMasterDataManager* _savedOrderMasterDataManager;
}
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

//@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic,retain)     NSArray* tableRows;
@property (nonatomic,retain)    NSIndexPath* currentIndexPath;
@property (nonatomic,retain) SavedOrderMasterDataManager* savedOrderMasterDataManager;

-(void)selectOnIndexPath:(NSIndexPath*)indexPath;
-(void)selectSecondSectionOnIndexPath:(NSIndexPath*)indexPath;
-(void)highlightSelectRow;
-(void)refreshCurrentIndexpath;
@end
