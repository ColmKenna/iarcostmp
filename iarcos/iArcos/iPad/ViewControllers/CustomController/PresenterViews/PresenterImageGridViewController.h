//
//  PresenterImageGridViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterGridCell.h"
#import "PresenterViewController.h"

@interface PresenterImageGridViewController : PresenterViewController <PresenterGridCellDelegate>{
    IBOutlet UITableView* myTableView;
}
@property(nonatomic,retain)    IBOutlet UITableView* myTableView;

@end
