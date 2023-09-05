//
//  NextCheckoutEmployeeTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutEmployeeTableViewCell.h"

@implementation NextCheckoutEmployeeTableViewCell

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueLabel.text = [[aCellData objectForKey:@"FieldData"] objectForKey:@"Title"];
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
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    self.globalWidgetViewController = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:employeeList title:@"Employee"];
//    self.thePopover.delegate = self;
//    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    if (self.globalWidgetViewController != nil) {
        [self showPopoverProcessor];
    }
}

-(void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.baseDelegate retrieveMainViewController] dismissViewControllerAnimated:YES completion:nil];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    
    [self.baseDelegate inputFinishedWithData:data forIndexPath:self.indexPath];
    [self.baseDelegate inputFinishedWithTitleKey:[self.cellData objectForKey:@"TitleKey"] data:[data objectForKey:@"Title"]];
    [self clearPopoverCacheData];
}

@end
