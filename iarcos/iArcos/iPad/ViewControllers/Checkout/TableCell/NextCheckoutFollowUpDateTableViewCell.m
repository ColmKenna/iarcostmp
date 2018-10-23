//
//  NextCheckoutFollowUpDateTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutFollowUpDateTableViewCell.h"

@implementation NextCheckoutFollowUpDateTableViewCell

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
    @try {
        NSMutableArray* dataList = [aCellData objectForKey:@"FieldData"];
        self.fieldValueLabel.text = [dataList objectAtIndex:[[aCellData objectForKey:@"Index"] intValue]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    self.thePopover = [self.widgetFactory CreateDateWidgetWithDataSource:2 defaultPickerDate:[ArcosUtils dateFromString:self.fieldValueLabel.text format:[GlobalSharedClass shared].dateFormat]];
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
    [self.baseDelegate inputFinishedWithData:self.fieldValueLabel.text forIndexPath:self.indexPath index:[self.cellData objectForKey:@"Index"]];
    [self clearPopoverCacheData];
}

@end
