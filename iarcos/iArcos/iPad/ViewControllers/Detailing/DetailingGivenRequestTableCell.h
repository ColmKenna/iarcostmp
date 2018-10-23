//
//  DetailingGivenRequestTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "DetailingTableCell.h"


@interface DetailingGivenRequestTableCell : DetailingTableCell<WidgetFactoryDelegate,UIPopoverControllerDelegate> {
    IBOutlet UILabel* label;
    IBOutlet UILabel* givenQantity;
    IBOutlet UILabel* requestQantity;
    NSInteger currentLabelIndex;

    
    //widget factory
    WidgetFactory* factory;
    UIPopoverController* _thePopover;
    UILabel* givenTitle;
    UILabel* requestTitle;
}
@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* givenQantity;
@property(nonatomic,retain) IBOutlet UILabel* requestQantity;
@property(nonatomic,retain)    WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) IBOutlet UILabel* givenTitle;
@property(nonatomic,retain) IBOutlet UILabel* requestTitle;

@end
