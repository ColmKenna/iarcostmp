//
//  NextCheckoutBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NextCheckoutBaseTableViewCellDelegate.h"
#import "WidgetFactory.h"

@interface NextCheckoutBaseTableViewCell : UITableViewCell <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate> {
    id<NextCheckoutBaseTableViewCellDelegate> _baseDelegate;
    UIButton* _fieldImageButton;
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
    NSMutableDictionary* _cellData;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<NextCheckoutBaseTableViewCellDelegate> baseDelegate;
@property(nonatomic, retain) IBOutlet UIButton* fieldImageButton;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;
- (void)clearPopoverCacheData;
- (void)showPopoverProcessor;

@end
