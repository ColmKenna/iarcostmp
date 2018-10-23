//
//  GenericUITableTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 18/07/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericUITableTableCell : UITableViewCell {
    NSMutableArray* _cellLabelList;
}

@property(nonatomic, retain) NSMutableArray* cellLabelList;

@end
