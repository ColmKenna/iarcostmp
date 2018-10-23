//
//  DetailingSampleTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "DetailingTableCell.h"


@interface DetailingSampleTableCell : DetailingTableCell <WidgetFactoryDelegate,UIPopoverControllerDelegate> {
    IBOutlet UILabel* label;
    IBOutlet UILabel* qantity;
    IBOutlet UILabel* batch;
    NSInteger currentLabelIndex;

    
    //widget factory
    WidgetFactory* factory;
    UIPopoverController* _thePopover;
    
}
@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* qantity;
@property(nonatomic,retain) IBOutlet UILabel* batch;
@property(nonatomic,retain)    WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;

@end
