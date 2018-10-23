//
//  CustomerInfoAccountBalanceDetailTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfoAccountBalanceDetailTableViewCell.h"
#import "GenericSelectionCancelDelegate.h"
#import "ArcosUtils.h"

@interface CustomerInfoAccountBalanceDetailTableViewController : UITableViewController {
    id<GenericSelectionCancelDelegate> _cancelDelegate;
    NSMutableArray* _displayList;
}

@property(nonatomic, assign) id<GenericSelectionCancelDelegate> cancelDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;

- (void)processRawData:(NSMutableDictionary*)custDict;

@end
