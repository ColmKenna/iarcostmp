//
//  ArcosMailBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosMailTableViewCellDelegate.h"

@interface ArcosMailBaseTableViewCell : UITableViewCell {
    id<ArcosMailTableViewCellDelegate> _myDelegate;
    NSMutableDictionary* _cellData;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<ArcosMailTableViewCellDelegate> myDelegate;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)aDataDict;

@end
