//
//  CustomerIarcosSavedOrderTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "CustomerIarcosSavedOrderDelegate.h"

@interface CustomerIarcosSavedOrderTableCell : UITableViewCell {
    id<CustomerIarcosSavedOrderDelegate> _delegate;
    UILabel* _orderDate;
    UILabel* _deliveryDate;
    UILabel* _name;
    UILabel* _typeDesc;
    UILabel* _value;
    UILabel* _employeeName;
    UIButton* _sendButton;
    UIImageView* _myImageViewType;
    UIActivityIndicatorView* _indicator;
    NSMutableDictionary* _cellData;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<CustomerIarcosSavedOrderDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* orderDate;
@property(nonatomic, retain) IBOutlet UILabel* deliveryDate;
@property(nonatomic, retain) IBOutlet UILabel* name;
@property(nonatomic, retain) IBOutlet UILabel* typeDesc;
@property(nonatomic, retain) IBOutlet UILabel* value;
@property(nonatomic, retain) IBOutlet UILabel* employeeName;
@property(nonatomic, retain) IBOutlet UIButton* sendButton;
@property(nonatomic, retain) IBOutlet UIImageView* myImageViewType;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)cellData;
- (IBAction)sendOrder:(id)sender;
- (void)animate;
- (void)inSending:(BOOL)sending;
- (void)stopAnimateWithStatus:(BOOL)status;
- (void)needEditable:(BOOL)editable;

@end
