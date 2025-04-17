//
//  MasterViewController.h
//  iArcos
//
//  Created by Colm Kenna on 21/03/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) NSArray<NSDictionary *> *sectionIndexList;
@property (nonatomic, weak) UITableView *detailTableView;

@end
