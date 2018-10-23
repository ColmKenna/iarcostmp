//
//  CustomerMemoModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
//#import "CustomerMemoTableCell.h"
#import "ArcosUtils.h"
#import "CustomerMemoDataManager.h"
#import "ArcosCoreData.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "CustomerIarcosMemoTableCell.h"
#import "UIViewController+ArcosStackedController.h"
#import "ArcosConfigDataManager.h"

@interface CustomerMemoModalViewController : UITableViewController <GetDataGenericDelegate, CustomerMemoInputDelegate, UIAlertViewDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UITableView* memoListView;    
    NSMutableArray* displayList;
    NSNumber* locationIUR;
    CallGenericServices* callGenericServices;
    CustomerMemoDataManager* customerMemoDataManager;
    NSMutableArray* _changedDataList;
    int rowPointer;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic,retain)  IBOutlet UITableView* memoListView;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property (nonatomic,retain) NSMutableArray* changedDataList;


-(void)closePressed:(id)sender;
-(void)saveChangedDataList:(NSMutableArray*)aChangedDataList;


@end
