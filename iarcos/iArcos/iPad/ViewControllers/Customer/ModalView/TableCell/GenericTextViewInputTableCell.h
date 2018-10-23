//
//  GenericTextViewInputTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTextViewInputTableCellDelegate.h"

@interface GenericTextViewInputTableCell : UITableViewCell {
    id<GenericTextViewInputTableCellDelegate> _delegate;
    NSMutableDictionary* _cellData;
    NSIndexPath* _indexPath;
}

@property(nonatomic, retain) id<GenericTextViewInputTableCellDelegate> delegate;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;

-(void)configCellWithData:(NSMutableDictionary*)theData;

@end
