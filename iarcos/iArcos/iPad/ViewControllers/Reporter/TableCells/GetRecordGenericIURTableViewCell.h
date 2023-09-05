//
//  GetRecordGenericIURTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBaseTableViewCell.h"
#import "WidgetFactory.h"

@interface GetRecordGenericIURTableViewCell : GetRecordGenericBaseTableViewCell <UITextFieldDelegate, WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate> {
    UITextField* _contentString;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, retain) IBOutlet UITextField* contentString;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

@end
