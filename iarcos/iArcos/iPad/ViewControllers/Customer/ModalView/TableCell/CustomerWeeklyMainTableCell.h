//
//  CustomerWeeklyMainTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 07/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTextViewInputTableCellDelegate.h"

@interface CustomerWeeklyMainTableCell : UITableViewCell<UITextViewDelegate> {
    id<GenericTextViewInputTableCellDelegate> delegate;
    IBOutlet UITextView* contentString;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
}

@property(nonatomic,assign) id<GenericTextViewInputTableCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UITextView* contentString;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;

-(void)configCellWithData:(NSMutableDictionary*)theCellData;


@end
