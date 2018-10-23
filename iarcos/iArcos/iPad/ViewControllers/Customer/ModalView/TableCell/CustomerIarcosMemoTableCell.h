//
//  CustomerIarcosMemoTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerMemoInputDelegate.h"

@interface CustomerIarcosMemoTableCell : UITableViewCell<UITextViewDelegate> {
    UILabel* date;
    UILabel* employee;
    UILabel* contact;
    UITextView* memo;
    UILabel* memoType;
    NSIndexPath* indexPath;
    id<CustomerMemoInputDelegate> delegate;
}

@property(nonatomic,retain) IBOutlet UILabel* date;
@property(nonatomic,retain) IBOutlet UILabel* employee;
@property(nonatomic,retain) IBOutlet UILabel* contact;
@property(nonatomic,retain) IBOutlet UITextView* memo;
@property(nonatomic,retain) IBOutlet UILabel* memoType;
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign) id<CustomerMemoInputDelegate> delegate;

-(void)configCellWithIndexPath:(NSIndexPath*) anIndexPath;

@end
