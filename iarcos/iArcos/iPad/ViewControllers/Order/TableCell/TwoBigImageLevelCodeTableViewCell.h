//
//  TwoBigImageLevelCodeTableViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBorderUILabel.h"
#import "TwoBigImageLevelCodeDelegate.h"

@interface TwoBigImageLevelCodeTableViewCell : UITableViewCell {
    id<TwoBigImageLevelCodeDelegate> _delegate;
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
    LeftBorderUILabel* labelDividerAfter1;
    LeftBorderUILabel* labelDividerAfter2;
    
    NSMutableArray* _btnList;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<TwoBigImageLevelCodeDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton* btn1;
@property(nonatomic, retain) IBOutlet UIButton* btn2;
@property(nonatomic, retain) IBOutlet UIButton* btn3;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter1;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter2;
@property(nonatomic, retain) NSMutableArray* btnList;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (IBAction)pressButton:(id)sender;
- (void)getCellReadyToUse;
- (void)createPopulatedLists;
- (void)clearAllInfo;

@end
