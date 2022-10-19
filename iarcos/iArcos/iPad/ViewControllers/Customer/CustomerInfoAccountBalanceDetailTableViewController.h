//
//  CustomerInfoAccountBalanceDetailTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfoAccountBalanceDetailTableViewCell.h"
#import "GenericSelectionCancelDelegate.h"
#import "ArcosUtils.h"
#import "ArcosCoreData.h"

@interface CustomerInfoAccountBalanceDetailTableViewController : UITableViewController {
    id<GenericSelectionCancelDelegate> _cancelDelegate;
    NSMutableArray* _displayList;
    NSString* _oneMthKey;
    NSString* _twoMthKey;
    NSString* _threeMthKey;
    NSString* _fourMthKey;
    NSMutableDictionary* _descrDetailHashMap;
}

@property(nonatomic, assign) id<GenericSelectionCancelDelegate> cancelDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* oneMthKey;
@property(nonatomic, retain) NSString* twoMthKey;
@property(nonatomic, retain) NSString* threeMthKey;
@property(nonatomic, retain) NSString* fourMthKey;
@property(nonatomic, retain) NSMutableDictionary* descrDetailHashMap;

- (void)processRawData:(NSMutableDictionary*)custDict;

@end
