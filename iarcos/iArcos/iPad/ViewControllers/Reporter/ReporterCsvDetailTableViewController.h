//
//  ReporterCsvDetailTableViewController.h
//  iArcos
//
//  Created by Richard on 11/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideAcrossViewAnimationDelegate.h"
#import "GenericUITableDetailTableCell.h"
#import "ArcosUtils.h"

@interface ReporterCsvDetailTableViewController : UITableViewController {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    NSArray* _attrNameList;
    NSArray* _bodyFieldList;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) NSArray* attrNameList;
@property(nonatomic, retain) NSArray* bodyFieldList;
@end

