//
//  MeetingDateTimeTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingDateTimeTableViewCell.h"

@implementation MeetingDateTimeTableViewCell
@synthesize dateFieldNameLabel = _dateFieldNameLabel;
@synthesize dateFieldValueLabel = _dateFieldValueLabel;
@synthesize timeFieldNameLabel = _timeFieldNameLabel;
@synthesize timeFieldValueLabel = _timeFieldValueLabel;
@synthesize durationFieldNameLabel = _durationFieldNameLabel;
@synthesize durationFieldValueTextField = _durationFieldValueTextField;
@synthesize currentSelectedLabel = _currentSelectedLabel;
@synthesize widgetFactory = _widgetFactory;
@synthesize thePopover = _thePopover;

- (void)dealloc {
    self.dateFieldNameLabel = nil;
    self.dateFieldValueLabel = nil;
    self.timeFieldNameLabel = nil;
    self.timeFieldValueLabel = nil;
    self.durationFieldNameLabel = nil;
    self.durationFieldValueTextField = nil;
    self.currentSelectedLabel = nil;
    self.widgetFactory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSMutableDictionary* fieldDataDict = [aCellData objectForKey:@"FieldData"];
    NSDate* dateObject = [fieldDataDict objectForKey:self.meetingCellKeyDefinition.dateKey];
    self.dateFieldValueLabel.text = [ArcosUtils stringFromDate:dateObject format:[GlobalSharedClass shared].dateFormat];
    NSDate* timeObject = [fieldDataDict objectForKey:self.meetingCellKeyDefinition.timeKey];
    self.timeFieldValueLabel.text = [ArcosUtils stringFromDate:timeObject format:[GlobalSharedClass shared].hourMinuteFormat];
    self.durationFieldValueTextField.text = [fieldDataDict objectForKey:self.meetingCellKeyDefinition.durationKey];
    
    for (UIGestureRecognizer* recognizer in self.dateFieldValueLabel.gestureRecognizers) {
        [self.dateFieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.dateFieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
    
    for (UIGestureRecognizer* recognizer in self.timeFieldValueLabel.gestureRecognizers) {
        [self.timeFieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.timeFieldValueLabel addGestureRecognizer:singleTap2];
    [singleTap2 release];
}

- (void)handleSingleTapGesture:(id)sender {
    UITapGestureRecognizer* tmpRecognizer = (UITapGestureRecognizer*)sender;
    UILabel* tmpLabel = (UILabel*)tmpRecognizer.view;
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    self.currentSelectedLabel = tmpLabel;
    NSMutableDictionary* fieldDataDict = [self.cellData objectForKey:@"FieldData"];
    switch (tmpLabel.tag) {
        case 50: {
            self.thePopover = [self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceNormalDate defaultPickerDate:[fieldDataDict objectForKey:self.meetingCellKeyDefinition.dateKey]];
            self.thePopover.delegate = self;
            [self.thePopover presentPopoverFromRect:self.currentSelectedLabel.bounds inView:self.currentSelectedLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
            break;
        case 60: {
            self.thePopover = [self.widgetFactory createDateHourMinuteWidgetWithType:DatePickerHourMinuteNormalType datePickerValue:[fieldDataDict objectForKey:self.meetingCellKeyDefinition.timeKey] minDate:nil maxDate:nil];
            self.thePopover.delegate = self;
            [self.thePopover presentPopoverFromRect:self.currentSelectedLabel.bounds inView:self.currentSelectedLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    NSMutableDictionary* fieldDataDict = [self.cellData objectForKey:@"FieldData"];
    switch (self.currentSelectedLabel.tag) {
        case 50: {
            self.currentSelectedLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
            [fieldDataDict setObject:data forKey:self.meetingCellKeyDefinition.dateKey];
        }
            break;
        case 60: {
            self.currentSelectedLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].hourMinuteFormat];
            [fieldDataDict setObject:data forKey:self.meetingCellKeyDefinition.timeKey];
        }
            break;
            
        default:
            break;
    }
    
    [self.actionDelegate meetingBaseInputFinishedWithData:fieldDataDict atIndexPath:self.myIndexPath];
    [self clearPopoverCacheData];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableDictionary* fieldDataDict = [self.cellData objectForKey:@"FieldData"];
    [fieldDataDict setObject:textField.text forKey:self.meetingCellKeyDefinition.durationKey];
    [self.actionDelegate meetingBaseInputFinishedWithData:fieldDataDict atIndexPath:self.myIndexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* assembledString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return ([ArcosValidator isInteger:assembledString] || [assembledString isEqualToString:@""]);
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self clearPopoverCacheData];
}

- (void)clearPopoverCacheData {
    self.thePopover = nil;
    self.widgetFactory.popoverController = nil;
}

@end
