//
//  MeetingExpenseDetailsViewController.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingExpenseDetailsDataManager.h"

@interface MeetingExpenseDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    MeetingExpenseDetailsDataManager* _meetingExpenseDetailsDataManager;
}

@property(nonatomic, retain) MeetingExpenseDetailsDataManager* meetingExpenseDetailsDataManager;

@end

