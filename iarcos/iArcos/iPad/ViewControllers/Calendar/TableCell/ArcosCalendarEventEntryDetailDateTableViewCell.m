//
//  ArcosCalendarEventEntryDetailDateTableViewCell.m
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailDateTableViewCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@implementation ArcosCalendarEventEntryDetailDateTableViewCell
@synthesize fieldDescLabel = _fieldDescLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize fieldTimeValueLabel = _fieldTimeValueLabel;
@synthesize widgetFactory = _widgetFactory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize currentSelectedLabel = _currentSelectedLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.fieldTimeValueLabel.gestureRecognizers) {
        [self.fieldTimeValueLabel removeGestureRecognizer:recognizer];
    }
    self.fieldDescLabel = nil;
    self.fieldValueLabel = nil;
    self.fieldTimeValueLabel = nil;
    self.widgetFactory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    self.currentSelectedLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    self.fieldDescLabel.text = [aCellData objectForKey:@"FieldDesc"];
    NSMutableDictionary* fieldData = [aCellData objectForKey:@"FieldData"];
    NSDate* auxDate = [fieldData objectForKey:@"Date"];
    NSDate* auxTime = [fieldData objectForKey:@"Time"];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:auxDate format:[GlobalSharedClass shared].dateFormat];
    self.fieldTimeValueLabel.text = [ArcosUtils stringFromDate:auxTime format:[GlobalSharedClass shared].hourMinuteFormat];
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.fieldTimeValueLabel.gestureRecognizers) {
        [self.fieldTimeValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* dateSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:dateSingleTap];
    [dateSingleTap release];
    UITapGestureRecognizer* timeSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldTimeValueLabel addGestureRecognizer:timeSingleTap];
    [timeSingleTap release];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UILabel* tapLabel = (UILabel*)sender.view;
        if (self.widgetFactory == nil) {
            self.widgetFactory = [WidgetFactory factory];
            self.widgetFactory.delegate = self;
        }
        self.currentSelectedLabel = tapLabel;
        NSMutableDictionary* fieldDataDict = [self.cellData objectForKey:@"FieldData"];
        switch (tapLabel.tag) {
            case 50: {
                self.globalWidgetViewController = [self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceNormalDate defaultPickerDate:[fieldDataDict objectForKey:@"Date"]];
//                self.thePopover.delegate = self;
//                [self.thePopover presentPopoverFromRect:self.currentSelectedLabel.bounds inView:self.currentSelectedLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
                break;
            case 60: {
//                self.thePopover = [self.widgetFactory createDateHourMinuteWidgetWithType:DatePickerHourMinuteAccessTimesType datePickerValue:[fieldDataDict objectForKey:@"Time"] minDate:nil maxDate:nil];
                self.globalWidgetViewController = [self.widgetFactory createDateHourMinuteWidgetWithType:DatePickerHourMinuteAccessTimesType datePickerValue:[fieldDataDict objectForKey:@"Time"] minDate:nil maxDate:nil];
//                self.thePopover.delegate = self;
//                [self.thePopover presentPopoverFromRect:self.currentSelectedLabel.bounds inView:self.currentSelectedLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.currentSelectedLabel;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = self.currentSelectedLabel.bounds;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.globalWidgetViewController.popoverPresentationController.delegate = self;
    [[self.actionDelegate retrieveCalendarEventEntryDetailParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.actionDelegate retrieveCalendarEventEntryDetailParentViewController] dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary* fieldDataDict = [self.cellData objectForKey:@"FieldData"];
    switch (self.currentSelectedLabel.tag) {
        case 50: {
            self.currentSelectedLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
            [fieldDataDict setObject:data forKey:@"Date"];
        }
            break;
        case 60: {
            self.currentSelectedLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].hourMinuteFormat];
            [fieldDataDict setObject:data forKey:@"Time"];
        }
            break;
            
        default:
            break;
    }
    [self clearPopoverCacheData];
}

#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    [self clearPopoverCacheData];
//}

#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    [self clearPopoverCacheData];
}

- (void)clearPopoverCacheData {
//    self.thePopover = nil;
//    self.widgetFactory.popoverController = nil;
    self.globalWidgetViewController = nil;
}

@end
