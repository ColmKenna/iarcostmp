//
//  DetailingKMTableCell.h
//  Arcos
//
//  Created by Apple on 02/02/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "DetailingTableCell.h"

@interface DetailingKMTableCell : DetailingTableCell<WidgetFactoryDelegate,UIPopoverControllerDelegate> {
    IBOutlet UILabel* label;
    IBOutlet UILabel* statusLabel;
    
    //widget factory
    WidgetFactory* factory;
    UIPopoverController* _thePopover;
    NSMutableDictionary* _kmCellData;
    NSMutableArray* _answerObjectList;
    UISegmentedControl* _answerSegmentedControl;
}

@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* statusLabel;
@property(nonatomic,retain)    WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) NSMutableDictionary* kmCellData;
@property(nonatomic,retain) NSMutableArray* answerObjectList;
@property(nonatomic,retain) IBOutlet UISegmentedControl* answerSegmentedControl;

- (IBAction)segmentedValueChange:(id)sender;

@end
