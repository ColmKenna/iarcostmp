//
//  OrderFormTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormSelectionTableViewController.h"
#import "FormRowsTableViewController.h"
#import "OrderTableViewHeader.h"
#import "MATFormRowsTableViewController.h"
#import "ImageFormRowsDataManager.h"
#import "ImageFormRowsTableViewController.h"

@interface OrderFormTableViewController : UITableViewController <UISplitViewControllerDelegate,UIActionSheetDelegate, SlideAcrossViewAnimationDelegate,ModelViewDelegate>{
    NSMutableDictionary* myGroups;
    NSMutableArray* groupName;
    NSMutableArray* sortKeys;
    NSMutableDictionary* groupSelections;
    
    NSMutableDictionary* tableData;
    
    IBOutlet UIView* headerView;
    
    FormRowsTableViewController* frtvc;
    FormSelectionTableViewController* fstvc;
    
    //code from master 
    
    UISplitViewController *splitViewController;
    
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    
    //header view outlet
    OrderTableViewHeader* orderTableViewHeader;
    
    //action sheet
    UIActionSheet *theActionSheet;
    
    //current indexpath
    NSIndexPath* currentIndexPath;
    
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ImageFormRowsDataManager* _imageFormRowsDataManager;
}
@property(nonatomic,retain) NSMutableDictionary* myGroups;
@property(nonatomic,retain) NSMutableArray* groupName;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* groupSelections;

@property(nonatomic,retain) NSMutableDictionary* tableData;

@property(nonatomic,retain) IBOutlet UIView* headerView;

@property(nonatomic,retain) FormRowsTableViewController* frtvc;

//code from master 

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
//header view outlet
@property (nonatomic, retain) OrderTableViewHeader* orderTableViewHeader;

@property (nonatomic, retain) NSIndexPath* currentIndexPath;

@property(nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) ImageFormRowsDataManager* imageFormRowsDataManager;

-(void)sortGroups;
-(void)selectDefaultForm;
-(void)selectFormWithIndexpath:(NSIndexPath*)indexPath;
-(void)selectCurrentForm;
-(BOOL)showMATFormRow:(NSString*)aGroupName;
-(BOOL)showImageFormRow:(NSString*)aGroupName;
-(void)oneOrderFormBranch:(NSString*)name;
-(void)multipleOrderFormBranch:(NSString*)name;

@end
