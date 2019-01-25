//
//  MeetingCostingsViewController.h
//  iArcos
//
//  Created by David Kilmartin on 16/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingCostingsDataManager.h"
#import "MeetingExpenseDetailsViewController.h"
#import "MeetingExpenseTableViewController.h"
#import "MeetingBudgetTableCellFactory.h"

@interface MeetingCostingsViewController : UIViewController <ModalPresentViewControllerDelegate, MeetingExpenseDetailsViewControllerDelegate, MeetingExpenseTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MeetingBaseTableViewCellDelegate>{
    UIView* _budgetTemplateView;
    UIView* _expensesTemplateView;
    UINavigationBar* _budgetNavigationBar;
    UINavigationBar* _expensesNavigationBar;
    UITableView* _budgetTableView;
    UITableView* _expensesTableView;
    MeetingCostingsDataManager* _meetingCostingsDataManager;
    NSArray* _templateViewList;
    UIBarButtonItem* _addBarButtonItem;
    MeetingExpenseTableViewController* _meetingExpenseTableViewController;
    MeetingBudgetTableCellFactory* _meetingBudgetTableCellFactory;
}

@property(nonatomic, retain) IBOutlet UIView* budgetTemplateView;
@property(nonatomic, retain) IBOutlet UIView* expensesTemplateView;
@property(nonatomic, retain) IBOutlet UINavigationBar* budgetNavigationBar;
@property(nonatomic, retain) IBOutlet UINavigationBar* expensesNavigationBar;
@property(nonatomic, retain) IBOutlet UITableView* budgetTableView;
@property(nonatomic, retain) IBOutlet UITableView* expensesTableView;
@property(nonatomic, retain) MeetingCostingsDataManager* meetingCostingsDataManager;
@property(nonatomic, retain) NSArray* templateViewList;
@property(nonatomic, retain) UIBarButtonItem* addBarButtonItem;
@property(nonatomic, retain) MeetingExpenseTableViewController* meetingExpenseTableViewController;
@property(nonatomic, retain) MeetingBudgetTableCellFactory* meetingBudgetTableCellFactory;

- (void)reloadCustomiseTableView;

@end

