//
//  NextCheckoutFollowUpEmployeeTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutFollowUpEmployeeTableViewCell.h"

@implementation NextCheckoutFollowUpEmployeeTableViewCell

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    @try {
        NSMutableArray* dataList = [aCellData objectForKey:@"FieldData"];
        NSNumber* employeeIUR = [dataList objectAtIndex:[[aCellData objectForKey:@"Index"] intValue]];
        NSString* employeeName = @"";
        if ([employeeIUR intValue] != 0) {
            NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
            if (employeeDict != nil) {
                employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
            }
        }
        self.fieldValueLabel.text = employeeName;
    } @catch (NSException *exception) {
        
    } @finally {
        
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
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    self.thePopover = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:employeeList title:@"Employee"];
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    [self.baseDelegate inputFinishedWithData:[data objectForKey:@"IUR"] forIndexPath:self.indexPath index:[self.cellData objectForKey:@"Index"]];
    [self clearPopoverCacheData];
}

@end
