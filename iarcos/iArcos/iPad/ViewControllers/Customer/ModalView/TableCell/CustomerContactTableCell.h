//
//  CustomerContactTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 29/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerContactBaseTableCell.h"
#import "WidgetFactory.h"

@interface CustomerContactTableCell : CustomerContactBaseTableCell <WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    IBOutlet UITextField* contentString;
    WidgetFactory* _factory;
    UIPopoverController* thePopover;
}

@property(nonatomic,retain) IBOutlet UITextField* contentString;
@property(nonatomic,retain) WidgetFactory* factory;

-(IBAction)textInputEnd:(id)sender;
-(void)handleSingleTapGesture:(id)sender;

@end
