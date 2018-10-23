//
//  PresenterGridListViewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterDetailViewProtocol.h"
#import "PresenterGridCell.h"
#import "FileReaderViewController.h"
@interface PresenterGridListViewController : UITableViewController<PresenterDetailViewProtocol,UISplitViewControllerDelegate,PresenterGridCellDelegate> {
    NSMutableArray* sortedResource;
    NSMutableArray* theResource;
    
    UIPopoverController* groupPopover;
    FileReaderViewController* myFileReader;
    
    NSString* groupType;
    
    //hold the bar button
    UIBarButtonItem* myBarButtonItem;
}
@property(nonatomic,retain)    NSMutableArray* sortedResource;
@property(nonatomic,retain)    NSMutableArray* theResource;
@property(nonatomic,retain)    NSString* groupType;


@end
