//
//  GetRecordGenericIURTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBaseTableViewCell.h"
#import "WidgetFactory.h"

@interface GetRecordGenericIURTableViewCell : GetRecordGenericBaseTableViewCell <UITextFieldDelegate, WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    UITextField* _contentString;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UITextField* contentString;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;

@end
