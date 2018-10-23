//
//  CustomerJourneyStartDateTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 06/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "WidgetFactory.h"

@protocol CustomerJourneyStartDateTableCellDelegate <NSObject>

-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;

@end

@interface CustomerJourneyStartDateTableCell : UITableViewCell <WidgetFactoryDelegate> {
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
    BOOL _isEventSet;
    NSMutableDictionary* _cellData;
    NSIndexPath* _indexPath;
    id<CustomerJourneyStartDateTableCellDelegate> _delegate;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic,retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, assign) BOOL isEventSet;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, retain) id<CustomerJourneyStartDateTableCellDelegate> delegate;

- (void)configCellWithData:(NSMutableDictionary*)theData;

@end
