//
//  MeetingExpenseTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 26/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingExpenseTableViewControllerDelegate <NSObject>

- (UITableView*)retrieveExpenseTableView;
- (UIViewController*)retrieveMeetingCostingViewController;

@end

