//
//  PreviousOrderDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 13/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewController.h"
#import "PreviousOrderTableCell.h"
#import "OrderProductViewController.h"
#import "SelectionPopoverViewController.h"
#import "OrderHeaderTotalViewController.h"
#import "OrderDetailModelViewController.h"
#import "ArcosCoreData.h"

@interface PreviousOrderDetailViewController : OrderDetailViewController<SelectionPopoverDelegate,ModelViewDelegate>{
    NSMutableArray* tableData;
    UIPopoverController* selectionPopover;
    UIPopoverController* searchPopover;
    IBOutlet UIView* headerView;

}
@property (nonatomic,retain)     IBOutlet UIView* headerView;
@property (nonatomic,retain)  NSMutableArray* tableData;

- (IBAction) EditTable:(id)sender;

- (IBAction)DeleteButtonAction:(id)sender;
-(NSMutableDictionary*)selectionTotal;
@end
