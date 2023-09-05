//
//  DetailingQATableCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "DetailingTableCell.h"
@interface DetailingQATableCell : DetailingTableCell<WidgetFactoryDelegate,UIPopoverPresentationControllerDelegate> {
    IBOutlet UILabel* label;
    IBOutlet UILabel* statusLabel;
    
    //widget factory
    WidgetFactory* factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    NSMutableDictionary* _qaCellData;
    NSMutableArray* _answerObjectList;
    UISegmentedControl* _answerSegmentedControl;
}
@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* statusLabel;
@property(nonatomic,retain)    WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic,retain) NSMutableDictionary* qaCellData;
@property(nonatomic,retain) NSMutableArray* answerObjectList;
@property(nonatomic,retain) IBOutlet UISegmentedControl* answerSegmentedControl;

- (IBAction)segmentedValueChange:(id)sender;


@end
