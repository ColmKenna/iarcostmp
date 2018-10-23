//
//  GenericUITableDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 26/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericUITableDetailTableCell.h"
#import "ArcosUtils.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface GenericUITableDetailViewController : UITableViewController {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    NSMutableArray* _displayList;
    NSArray* _attrNameList;
    NSArray* _attrNameTypeList;
    NSDictionary* _attrDict;
    
    NSMutableDictionary* _recordCellData;
    
    
    
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSArray* attrNameList;
@property(nonatomic, retain) NSArray* attrNameTypeList;
@property(nonatomic, retain) NSDictionary* attrDict;
@property(nonatomic, retain) NSMutableDictionary* recordCellData;

@end
