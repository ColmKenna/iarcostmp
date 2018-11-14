//
//  MeetingCostingsTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingCostingsDataManager.h"

@interface MeetingCostingsTableViewController : UITableViewController {
    UIView* _budgetTemplateView;
    UIView* _separatorTemplateView;
    UIView* _expensesTemplateView;
    MeetingCostingsDataManager* _meetingCostingsDataManager;
}

@property(nonatomic, retain) IBOutlet UIView* budgetTemplateView;
@property(nonatomic, retain) IBOutlet UIView* separatorTemplateView;
@property(nonatomic, retain) IBOutlet UIView* expensesTemplateView;
@property(nonatomic, retain) MeetingCostingsDataManager* meetingCostingsDataManager;



@end

