//
//  SavedOrderTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedableTableCell.h"
#import "OrderSender.h"
@protocol SavedOrderTableCellDelegate;

@interface SavedOrderTableCell : UITableViewCell {
    IBOutlet UILabel* number;
    IBOutlet UILabel* date;
    IBOutlet UILabel* name;
    IBOutlet UILabel* address;
    IBOutlet UILabel* value;
    IBOutlet UILabel* point;
    IBOutlet UILabel* deliveryDate;
    IBOutlet UIButton* sendButton;
    IBOutlet UIImageView* selectIndicator;
    IBOutlet UIImageView* icon;
    
    BOOL isSelected;
    
    NSObject* data;
    NSIndexPath* theIndexPath;
    int type;
    
    //send
    IBOutlet UIActivityIndicatorView* indicator;
    BOOL isSent;
    //delegate
    id<SavedOrderTableCellDelegate>delegate;

}

@property (nonatomic,retain) IBOutlet UILabel* number;
@property (nonatomic,retain) IBOutlet UILabel* date;
@property (nonatomic,retain) IBOutlet UILabel* name;
@property (nonatomic,retain) IBOutlet UILabel* address;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) IBOutlet UILabel* point;
@property (nonatomic,retain) IBOutlet UILabel* deliveryDate;
@property (nonatomic,retain) IBOutlet UIButton* sendButton;
@property (nonatomic,retain) NSIndexPath* theIndexPath;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* indicator;
@property (nonatomic,assign) id<SavedOrderTableCellDelegate>delegate;
@property (nonatomic,assign) int type;
-(IBAction)sendOrder:(id)sender;
-(void)animate;
-(void)stopAnimateWithStatus:(BOOL)status;
@property (nonatomic,retain) IBOutlet UIImageView* selectIndicator;
@property (nonatomic,retain) IBOutlet UIImageView* icon;

@property (nonatomic,retain)     NSObject* data;


-(void)flipSelectStatus;
-(void)setSelectStatus:(BOOL)select;
-(void)needEditable:(BOOL)editable;
-(void)inSending:(BOOL)sending;
@end

//delegate
@protocol SavedOrderTableCellDelegate
//-(void)orderSendStatus:(BOOL)isSuccess withData:(id)aData;
//-(void)startSendOrder:(id)aData;
-(void)sendPressedForCell:(SavedOrderTableCell*)cell;
@end
