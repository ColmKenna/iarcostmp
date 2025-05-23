//
//  SettingSelectionInputCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingInputCell.h"
#import "WidgetFactory.h"

@interface SettingSelectionInputCell : SettingInputCell<WidgetFactoryDelegate,UIPopoverPresentationControllerDelegate> {
    
    IBOutlet UILabel* label;
    IBOutlet UILabel* statusLabel;
    
    //widget factory
    WidgetFactory* factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}
@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* statusLabel;
@property(nonatomic,retain)    WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;


-(void)valueChange:(id)data;

@end
