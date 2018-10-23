//
//  NextCheckoutFollowUpWritableTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutFollowUpWritableTableViewCell.h"

@implementation NextCheckoutFollowUpWritableTableViewCell

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
        NSNumber* taskTypeIUR = [dataList objectAtIndex:[[aCellData objectForKey:@"Index"] intValue]];
        NSString* taskTypeDesc = @"";
        if ([taskTypeIUR intValue] != 0) {
            NSDictionary* taskTypeDescrDetail = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:taskTypeIUR];
            taskTypeDesc = [ArcosUtils convertNilToEmpty:[taskTypeDescrDetail objectForKey:@"Detail"]];
        }
        self.fieldValueLabel.text = taskTypeDesc;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:@"TY"];
    NSDictionary* descrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"TY"];
    NSString* myTitle = [ArcosUtils convertNilToEmpty:[descrTypeDict objectForKey:@"Details"]];
    self.thePopover = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:descrDetailList title:myTitle];
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    [self.baseDelegate inputFinishedWithData:[data objectForKey:@"DescrDetailIUR"] forIndexPath:self.indexPath index:[self.cellData objectForKey:@"Index"]];
    [self clearPopoverCacheData];
}

@end
