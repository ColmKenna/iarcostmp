//
//  ReportMeetingWrapperViewController.h
//  iArcos
//
//  Created by David Kilmartin on 18/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportMeetingTableViewController.h"

@interface ReportMeetingWrapperViewController : UIViewController <CustomisePresentViewControllerDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    UIScrollView* _customiseScrollContentView;
    UIView* _customiseContentView;
    UINavigationController* _globalNavigationController;
    NSNumber* _iUR;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic,retain) IBOutlet UIScrollView* customiseScrollContentView;
@property (nonatomic,retain) IBOutlet UIView* customiseContentView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) NSNumber* iUR;

@end
