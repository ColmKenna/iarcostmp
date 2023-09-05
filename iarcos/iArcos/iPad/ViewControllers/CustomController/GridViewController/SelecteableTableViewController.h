//
//  SelecteableTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionPopoverViewController.h"
#import "ModelViewDelegate.h"
#import "SelectedableTableCell.h"
@interface SelecteableTableViewController : UITableViewController <SelectionPopoverDelegate,ModelViewDelegate> {
    NSMutableArray* tableData;
//    UIPopoverController* selectionPopover;
//    UIPopoverController* searchPopover;
    
    BOOL isCellEditable;

}
@property (nonatomic,assign)     BOOL isCellEditable;

@property (nonatomic,retain)  NSMutableArray* tableData;

- (IBAction) EditTable:(id)sender;

- (IBAction)DeleteButtonAction:(id)sender;
-(NSMutableDictionary*)selectionTotal;

@end
