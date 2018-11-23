//
//  MeetingExpenseDetailsBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingExpenseDetailsBaseTableViewCellDelegate.h"
#import "WidgetFactory.h"

@interface MeetingExpenseDetailsBaseTableViewCell : UITableViewCell<UIPopoverControllerDelegate> {
    id<MeetingExpenseDetailsBaseTableViewCellDelegate> _baseDelegate;
    NSMutableDictionary* _cellData;
    NSIndexPath* _myIndexPath;
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, assign) id<MeetingExpenseDetailsBaseTableViewCellDelegate> baseDelegate;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* myIndexPath;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;
- (void)clearPopoverCacheData;

@end

