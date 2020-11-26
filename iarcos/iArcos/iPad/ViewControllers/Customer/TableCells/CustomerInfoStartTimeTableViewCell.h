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

@interface CustomerInfoStartTimeTableViewCell : UITableViewCell <WidgetFactoryDelegate, UIPopoverControllerDelegate>{
    UILabel* _infoTitle;
    UILabel* _infoValue;
    UIButton* _actionBtn;
    NSMutableDictionary* _cellData;
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UILabel* infoTitle;
@property(nonatomic, retain) IBOutlet UILabel* infoValue;
@property(nonatomic, retain) IBOutlet UIButton* actionBtn;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;

- (void)configCellWithoutData;
- (IBAction)resetStartTime;

@end

