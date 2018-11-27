//
//  MeetingExpenseDetailsViewController.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingExpenseDetailsDataManager.h"
#import "MeetingExpenseDetailsTableCellFactory.h"
#import "ModalPresentViewControllerDelegate.h"
#import "MeetingExpenseDetailsViewControllerDelegate.h"

@interface MeetingExpenseDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MeetingExpenseDetailsBaseTableViewCellDelegate> {
    id<ModalPresentViewControllerDelegate> _modalDelegate;
    id<MeetingExpenseDetailsViewControllerDelegate> _actionDelegate;
    MeetingExpenseDetailsDataManager* _meetingExpenseDetailsDataManager;
    MeetingExpenseDetailsTableCellFactory* _tableCellFactory;
    UITableView* _myTableView;
    UINavigationBar* _myNavigationBar;
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> modalDelegate;
@property(nonatomic, assign) id<MeetingExpenseDetailsViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) MeetingExpenseDetailsDataManager* meetingExpenseDetailsDataManager;
@property(nonatomic, retain) MeetingExpenseDetailsTableCellFactory* tableCellFactory;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;

@end

