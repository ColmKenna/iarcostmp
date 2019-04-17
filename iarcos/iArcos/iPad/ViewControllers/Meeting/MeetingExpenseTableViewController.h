//
//  MeetingExpenseTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 23/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingExpenseTableViewCell.h"
#import "MeetingExpenseDetailsDataManager.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "MeetingExpenseTableViewControllerDelegate.h"
#import "ArcosMeetingWithDetails.h"
#import "ArcosMeetingWithDetailsDownload.h"
#import "ArcosExpenses.h"
#import "ArcosCoreData.h"


@interface MeetingExpenseTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    id<MeetingExpenseTableViewControllerDelegate> _accessDelegate;
    NSMutableArray* _displayList;
    NSMutableArray* _deleteDisplayList;
    MeetingExpenseDetailsDataManager* _meetingExpenseDetailsDataManager;
    NSIndexPath* _currentSelectDeleteIndexPath;
}

@property(nonatomic, assign) id<MeetingExpenseTableViewControllerDelegate> accessDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* deleteDisplayList;
@property(nonatomic, retain) MeetingExpenseDetailsDataManager* meetingExpenseDetailsDataManager;
@property(nonatomic, retain) NSIndexPath* currentSelectDeleteIndexPath;

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetails*)anArcosMeetingWithDetails;
- (void)meetingExpenseDetailsSaveButtonProcessorWithData:(NSMutableDictionary*)aHeadOfficeDataObjectDict;
- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload;

@end

