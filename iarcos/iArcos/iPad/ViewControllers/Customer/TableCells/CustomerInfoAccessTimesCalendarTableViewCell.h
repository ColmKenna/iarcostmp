//
//  CustomerInfoAccessTimesCalendarTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBorderUILabel.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "CustomerInfoAccessTimesCalendarTableViewCellDelegate.h"

@interface CustomerInfoAccessTimesCalendarTableViewCell : UITableViewCell {
    id<CustomerInfoAccessTimesCalendarTableViewCellDelegate> _actionDelegate;
    UILabel* _timeLabel;
    LeftBorderUILabel* _sunLabel;
    LeftBorderUILabel* _monLabel;
    LeftBorderUILabel* _tueLabel;
    LeftBorderUILabel* _wedLabel;
    LeftBorderUILabel* _thuLabel;
    LeftBorderUILabel* _friLabel;
    LeftBorderUILabel* _satLabel;
    NSMutableArray* _labelList;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<CustomerInfoAccessTimesCalendarTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* sunLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* monLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* tueLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* wedLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* thuLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* friLabel;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* satLabel;
@property(nonatomic, retain) NSMutableArray* labelList;
@property(nonatomic, retain) NSIndexPath* indexPath;


- (void)configCellWithData:(NSMutableDictionary*)aGroupData sectionData:(NSMutableDictionary*)aSectionData;

@end
