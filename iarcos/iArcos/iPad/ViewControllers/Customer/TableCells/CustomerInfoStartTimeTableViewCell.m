//
//  CustomerInfoStartTimeTableViewCell.m
//  iArcos
//
//  Created by Richard on 25/11/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoStartTimeTableViewCell.h"

@implementation CustomerInfoStartTimeTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;
@synthesize actionBtn = _actionBtn;
@synthesize cellData = _cellData;
@synthesize widgetFactory = _widgetFactory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.infoValue.gestureRecognizers) {
        [self.infoValue removeGestureRecognizer:recognizer];
    }
    self.infoTitle = nil;
    self.infoValue = nil;
    self.actionBtn = nil;
    self.cellData = nil;
    self.widgetFactory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

- (void)configCellWithoutData {
    self.infoValue.text = [ArcosUtils stringFromDate:[GlobalSharedClass shared].startRecordingDate format:[GlobalSharedClass shared].datetimeFormat];
    UIImage* anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:153]];
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    [self.actionBtn setImage:anImage forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIGestureRecognizer* recognizer in self.infoValue.gestureRecognizers) {
        [self.infoValue removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.infoValue addGestureRecognizer:singleTap];
    [singleTap release];
}

- (IBAction)resetStartTime {
    NSDate* currentDate = [NSDate date];
    self.infoValue.text = [ArcosUtils stringFromDate:currentDate format:[GlobalSharedClass shared].datetimeFormat];
    [GlobalSharedClass shared].startRecordingDate = currentDate;
}

- (void)handleSingleTapGesture {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    self.globalWidgetViewController = [self.widgetFactory createDateHourMinuteWidgetWithType:DatePickerHourMinuteNormalType datePickerValue:[GlobalSharedClass shared].startRecordingDate minDate:nil maxDate:[NSDate date]];
//    if (self.thePopover != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.infoValue.bounds inView:self.infoValue permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.infoValue;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = self.infoValue.bounds;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.globalWidgetViewController.popoverPresentationController.delegate = self;
    [[self.actionDelegate retrieveCustomerInfoButtonParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.actionDelegate retrieveCustomerInfoButtonParentViewController] dismissViewControllerAnimated:YES completion:nil];
    [GlobalSharedClass shared].startRecordingDate = data;
    self.infoValue.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].datetimeFormat];
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
