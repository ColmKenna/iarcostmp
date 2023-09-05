//
//  NextCheckoutDateTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutDateTableViewCell.h"

@implementation NextCheckoutDateTableViewCell


- (void)dealloc {
    
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:[aCellData objectForKey:@"FieldData"] format:[GlobalSharedClass shared].dateFormat];
    if ([[aCellData objectForKey:@"BgColor"] boolValue]) {
        self.fieldValueLabel.backgroundColor = [UIColor yellowColor];
    } else {
        self.fieldValueLabel.backgroundColor = [UIColor clearColor];
    }
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    NSNumber* writableType = [self.cellData objectForKey:@"WritableType"];
    self.globalWidgetViewController = [self.widgetFactory CreateDateWidgetWithDataSource:[writableType intValue] defaultPickerDate:[self.cellData objectForKey:@"FieldData"]];
//    self.thePopover.delegate = self;
//    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self showPopoverProcessor];
}

-(void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.baseDelegate retrieveMainViewController] dismissViewControllerAnimated:YES completion:nil];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
    [self.baseDelegate inputFinishedWithData:data forIndexPath:self.indexPath];
    [self clearPopoverCacheData];
}


@end
