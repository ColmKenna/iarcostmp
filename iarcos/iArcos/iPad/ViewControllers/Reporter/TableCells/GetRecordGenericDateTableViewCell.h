//
//  GetRecordGenericDateTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBaseTableViewCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "WidgetFactory.h"

@interface GetRecordGenericDateTableViewCell : GetRecordGenericBaseTableViewCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate> {
    UILabel* _contentString;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, retain) IBOutlet UILabel* contentString;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

@end
