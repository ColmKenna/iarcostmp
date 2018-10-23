//
//  NextCheckoutAccountTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutAccountTableViewCell.h"

@implementation NextCheckoutAccountTableViewCell
@synthesize checkoutDataManager = _checkoutDataManager;

- (void)dealloc {
    self.checkoutDataManager = nil;
    
    [super dealloc];
}

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
    if (![self.baseDelegate checkWholesalerAppliedStatus]) {
        return;
    }
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    if (self.checkoutDataManager == nil) {
        self.checkoutDataManager = [[[CheckoutDataManager alloc] init] autorelease];
    }
    NSMutableDictionary* myOrderHeader = [self.baseDelegate retrieveOrderHeaderData];
    NSNumber* wholesalerIUR = [[myOrderHeader objectForKey:@"wholesaler"] objectForKey:@"LocationIUR"];
    NSNumber* locationIUR = [NSNumber numberWithInt:0];
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    }
    NSMutableArray* accountNoList = [self.checkoutDataManager getAccountNoList:locationIUR fromLocationIUR:wholesalerIUR];
    NSMutableDictionary* miscDataDict = [self.checkoutDataManager getAcctNoMiscDataDict:locationIUR fromLocationIUR:wholesalerIUR];
    self.thePopover = [self.widgetFactory CreateTargetGenericCategoryWidgetWithUncheckedPickerValue:accountNoList miscDataDict:miscDataDict];
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    
    [self.baseDelegate inputFinishedWithData:data forIndexPath:self.indexPath];
    [self.baseDelegate inputFinishedWithTitleKey:[self.cellData objectForKey:@"TitleKey"] data:[data objectForKey:@"Title"]];
    [self clearPopoverCacheData];
}

-(BOOL)allowToShowAddContactButton {
    return NO;
}

-(BOOL)allowToShowAddAccountNoButton {
    return YES;
}

@end
