//
//  OrderDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"

@interface OrderDetailViewController : UITableViewController<UISplitViewControllerDelegate,SubstitutableDetailViewController> {
    UIPopoverController* groupPopover;
    
//    IBOutlet UITableViewCell* tableViewCell;
    
    //hold the bar button
    UIBarButtonItem* myBarButtonItem;
}
@property(nonatomic,retain) UIBarButtonItem* myBarButtonItem;

@end
