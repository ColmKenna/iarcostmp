//
//  ReportMeetingTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 18/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "CallGenericServices.h"
#import "ReportMeetingDataManager.h"
//GetRecordGenericTableCellFactory
#import "GetRecordGenericTableCellFactory.h"

@interface ReportMeetingTableViewController : UITableViewController <GetDataGenericDelegate, GetRecordGenericTypeTableCellDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    NSNumber* _iUR;
    CallGenericServices* _callGenericServices;
    BOOL _isNotFirstLoaded;
    ReportMeetingDataManager* _reportMeetingDataManager;
    GetRecordGenericTableCellFactory* _cellFactory;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, retain) NSNumber* iUR;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) ReportMeetingDataManager* reportMeetingDataManager;
@property(nonatomic, retain) GetRecordGenericTableCellFactory* cellFactory;

@end
