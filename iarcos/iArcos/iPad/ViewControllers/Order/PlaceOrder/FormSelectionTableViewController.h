//
//  FormSelectionTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormRowsTableViewController.h"
#import "OrderTableViewHeader.h"

@interface FormSelectionTableViewController : UITableViewController {
    NSNumber* formIUR;
    NSString* formName;
    
    NSMutableDictionary* myGroups;
    NSMutableArray* mySelecitons;
    NSMutableArray* groupName;
    NSMutableArray* sortKeys;
    NSMutableDictionary* groupSelections;
    
    NSMutableDictionary* tableData;
    
    IBOutlet UIView* headerView;
    
    FormRowsTableViewController* frtvc;
    
    NSIndexPath* selectedIndexPath;
    
    //header view outlet
    OrderTableViewHeader* orderTableViewHeader;

}
@property(nonatomic,retain) NSNumber* formIUR;
@property(nonatomic,retain) NSString* formName;

@property(nonatomic,retain) NSMutableDictionary* myGroups;
@property(nonatomic,retain) NSMutableArray* mySelecitons;

@property(nonatomic,retain) NSMutableArray* groupName;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* groupSelections;

@property(nonatomic,retain) NSMutableDictionary* tableData;

@property(nonatomic,retain) IBOutlet UIView* headerView;

@property(nonatomic,retain) FormRowsTableViewController* frtvc;
//header view outlet
@property (nonatomic, retain) OrderTableViewHeader* orderTableViewHeader;

@property(nonatomic,retain)    NSIndexPath* selectedIndexPath;

-(void)sortGroups;
-(void)selectDefaultSelection;
@end
