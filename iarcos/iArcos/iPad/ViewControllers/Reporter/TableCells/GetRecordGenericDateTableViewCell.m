//
//  GetRecordGenericDateTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericDateTableViewCell.h"
@interface GetRecordGenericDateTableViewCell()

- (void)removePopoverObject;

@end

@implementation GetRecordGenericDateTableViewCell
@synthesize contentString = _contentString;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;

- (void)dealloc {
    self.contentString = nil;
    self.factory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aData {
    [super configCellWithData:aData];
    GetRecordTypeGenericBaseObject* auxActualContentObject = [aData objectForKey:@"actualContent"];
    self.contentString.text = [auxActualContentObject retrieveStringValue];
    NSArray* recognizerList = self.contentString.gestureRecognizers;
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[recognizerList count]] - 1; i >= 0; i--) {
        UITapGestureRecognizer* tmpRecognizer = [recognizerList objectAtIndex:i];
        if ([tmpRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.contentString removeGestureRecognizer:tmpRecognizer];
        }
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentString addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(id)sender {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    GetRecordTypeGenericBaseObject* auxActualContentObject = [self.cellData objectForKey:@"actualContent"];
    NSDate* tmpMeetingDate = auxActualContentObject.resultContent;
    self.thePopover = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceNormalDate pickerFormatType:DatePickerFormatForceDateTime defaultPickerDate:tmpMeetingDate];
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.contentString.bounds inView:self.contentString permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.contentString.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].datetimehmFormat];
    [self.delegate inputFinishedWithData:self.contentString.text actualData:data indexPath:self.indexPath];
    [self removePopoverObject];
}

- (void)dismissPopoverController {
    [self.thePopover dismissPopoverAnimated:YES];
    [self removePopoverObject];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self removePopoverObject];
}

- (void)removePopoverObject {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
