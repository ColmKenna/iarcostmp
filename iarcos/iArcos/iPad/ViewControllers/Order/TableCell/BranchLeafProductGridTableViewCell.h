//
//  BranchLeafProductGridTableViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 03/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBorderUILabel.h"

@interface BranchLeafProductGridTableViewCell : UITableViewCell {
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
    UIButton* btn4;
    
    LeftBorderUILabel* labelDividerAfter1;
    LeftBorderUILabel* labelDividerAfter2;
    LeftBorderUILabel* labelDividerAfter3;
    
    NSMutableArray* _btnList;
    NSIndexPath* _indexPath;
}

@property(nonatomic, retain) IBOutlet UIButton* btn1;
@property(nonatomic, retain) IBOutlet UIButton* btn2;
@property(nonatomic, retain) IBOutlet UIButton* btn3;
@property(nonatomic, retain) IBOutlet UIButton* btn4;

@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter1;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter2;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter3;

@property(nonatomic, retain) NSMutableArray* btnList;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)createPopulatedLists;
- (void)clearAllInfo;
- (void)getCellReadyToUse;

@end
