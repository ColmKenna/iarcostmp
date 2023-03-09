//
//  DetailingTreeTableViewController.h
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailingTreeTableCellFactory.h"
#import "ModalPresentViewControllerDelegate.h"

@interface DetailingTreeTableViewController : UITableViewController {
    id<ModalPresentViewControllerDelegate> _presentDelegate;
    DetailingTreeTableCellFactory* _cellFactory;
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
    NSMutableDictionary* _branchLeafHashMap;
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) DetailingTreeTableCellFactory* cellFactory;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* originalDisplayList;
@property(nonatomic, retain) NSMutableDictionary* branchLeafHashMap;

@end


