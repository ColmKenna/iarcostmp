//
//  UtilitiesMemoryTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "UtilitiesMemoryTableCell.h"
#import "ArcosMemoryUtils.h"
#import "ArcosUtils.h"

@interface UtilitiesMemoryTableViewController : UtilitiesDetailViewController {
    NSMutableArray* _displayList;
    ArcosMemoryUtils* _arcosMemoryUtils;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) ArcosMemoryUtils* arcosMemoryUtils;

@end
