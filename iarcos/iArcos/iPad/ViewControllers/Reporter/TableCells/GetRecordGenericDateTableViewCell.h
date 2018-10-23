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

@interface GetRecordGenericDateTableViewCell : GetRecordGenericBaseTableViewCell <WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    UILabel* _contentString;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UILabel* contentString;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;

@end
