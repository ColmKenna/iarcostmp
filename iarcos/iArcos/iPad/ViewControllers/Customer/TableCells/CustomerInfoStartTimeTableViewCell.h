//
//  CustomerInfoStartTimeTableViewCell.h
//  iArcos
//
//  Created by Richard on 25/11/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "WidgetFactory.h"
#import "CustomerInfoButtonCellDelegate.h"

@interface CustomerInfoStartTimeTableViewCell : UITableViewCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    id<CustomerInfoButtonCellDelegate> _actionDelegate;
    UILabel* _infoTitle;
    UILabel* _infoValue;
    UIButton* _actionBtn;
    NSMutableDictionary* _cellData;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic,assign) id<CustomerInfoButtonCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* infoTitle;
@property(nonatomic, retain) IBOutlet UILabel* infoValue;
@property(nonatomic, retain) IBOutlet UIButton* actionBtn;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

- (void)configCellWithoutData;
- (IBAction)resetStartTime;

@end

