//
//  MeetingCostingsViewController.h
//  iArcos
//
//  Created by David Kilmartin on 16/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingCostingsDataManager.h"

@interface MeetingCostingsViewController : UIViewController {
    UIView* _budgetTemplateView;
    UIView* _expensesTemplateView;
    UINavigationBar* _budgetNavigationBar;
    UINavigationBar* _expensesNavigationBar;
    UITableView* _budgetTableView;
    UITableView* _expensesTableView;
    MeetingCostingsDataManager* _meetingCostingsDataManager;
    NSArray* _templateViewList;
}

@property(nonatomic, retain) IBOutlet UIView* budgetTemplateView;
@property(nonatomic, retain) IBOutlet UIView* expensesTemplateView;
@property(nonatomic, retain) IBOutlet UINavigationBar* budgetNavigationBar;
@property(nonatomic, retain) IBOutlet UINavigationBar* expensesNavigationBar;
@property(nonatomic, retain) IBOutlet UITableView* budgetTableView;
@property(nonatomic, retain) IBOutlet UITableView* expensesTableView;
@property(nonatomic, retain) MeetingCostingsDataManager* meetingCostingsDataManager;
@property(nonatomic, retain) NSArray* templateViewList;

@end

