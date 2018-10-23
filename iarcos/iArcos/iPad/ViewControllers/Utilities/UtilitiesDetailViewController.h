//
//  UtilitiesDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "ControllNavigationBarDelegate.h"


@interface UtilitiesDetailViewController : UITableViewController<SubstitutableDetailViewController> {
    //hold the bar button
    UIBarButtonItem* myBarButtonItem;
    id<ControllNavigationBarDelegate> _navigationDelegate;
}
@property(nonatomic,retain) UIBarButtonItem* myBarButtonItem;
@property(nonatomic,assign) id<ControllNavigationBarDelegate> navigationDelegate;

@end
