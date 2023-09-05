//
//  GetRecordGenericIURTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericIURTableViewCell.h"
@interface GetRecordGenericIURTableViewCell()

- (void)removePopoverObject;

@end

@implementation GetRecordGenericIURTableViewCell
@synthesize contentString = _contentString;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;

- (void)dealloc {
    self.contentString = nil;
    self.factory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSString* descrTypeCode = [self.cellData objectForKey:@"descrTypeCode"];
    NSMutableArray* dataList = nil;
    NSString* navigationBarTitle = nil;
    
    dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:descrTypeCode];
    navigationBarTitle = [[[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:descrTypeCode] objectForKey:@"Details"];
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.globalWidgetViewController = [self.factory CreateTableWidgetWithData:dataList withTitle:navigationBarTitle withParentContentString:[self.cellData objectForKey:@"contentString"]];
    
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.contentString.bounds inView:self.contentString permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.contentString;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.contentString.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveGetRecordGenericTypeParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
    return NO;
}

- (void)configCellWithData:(NSMutableDictionary *)aData {
    [super configCellWithData:aData];
    self.contentString.text = [aData objectForKey:@"contentString"];
    
}

- (void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.delegate retrieveGetRecordGenericTypeParentViewController] dismissViewControllerAnimated:YES completion:nil];
//    [self.cellData setObject:[data objectForKey:@"Title"] forKey:@"contentString"];
//    [self.cellData setObject:[data objectForKey:@"DescrDetailIUR"] forKey:@"actualContent"];
    self.contentString.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[data objectForKey:@"Title"] actualData:[data objectForKey:@"DescrDetailIUR"] indexPath:self.indexPath];
    [self removePopoverObject];
}

- (void)dismissPopoverController {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.delegate retrieveGetRecordGenericTypeParentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self removePopoverObject];
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    [self removePopoverObject];
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    [self removePopoverObject];
}

- (void)removePopoverObject {
    self.globalWidgetViewController = nil;
}

@end
