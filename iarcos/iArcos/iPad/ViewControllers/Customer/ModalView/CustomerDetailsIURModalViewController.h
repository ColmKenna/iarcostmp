//
//  CustomerDetailsIURModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 04/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailsIURDelegate.h"
#import "ArcosCoreData.h"
#import "CustomerDetailsIURTableCell.h"
#import "ArcosUtils.h"

@interface CustomerDetailsIURModalViewController : UITableViewController {
    id<CustomerDetailsIURDelegate> delegate;
    NSMutableArray* displayList;
    IBOutlet UITableView* iurListView;
    NSString* parentContentString;
    NSString* descrTypeCode;
    NSString* parentActualContent;
    NSIndexPath* accessoryIndexPath;
}

@property (nonatomic,assign) id<CustomerDetailsIURDelegate> delegate;
@property (nonatomic,retain) NSMutableArray* displayList;
@property (nonatomic,retain) IBOutlet UITableView* iurListView;
@property (nonatomic,retain) NSString* parentContentString;
@property (nonatomic,retain) NSString* descrTypeCode;
@property (nonatomic,retain) NSString* parentActualContent;
@property (nonatomic,retain) NSIndexPath* accessoryIndexPath;

- (void)handleDoubleTap:(id)sender;

@end
