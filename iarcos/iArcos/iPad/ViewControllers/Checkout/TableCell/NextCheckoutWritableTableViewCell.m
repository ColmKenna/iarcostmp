//
//  NextCheckoutWritableTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutWritableTableViewCell.h"

@implementation NextCheckoutWritableTableViewCell

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag] && [[self.cellData objectForKey:@"CellKey"] isEqualToString:@"wholesaler"]) {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blueColor];
    }
    self.fieldValueLabel.text = [[aCellData objectForKey:@"FieldData"] objectForKey:@"Title"];
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag] && [[self.cellData objectForKey:@"CellKey"] isEqualToString:@"wholesaler"]) {
        return;
    }
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    NSNumber* writableType = [self.cellData objectForKey:@"WritableType"];
    self.globalWidgetViewController = [self.widgetFactory CreateCategoryWidgetWithDataSource:[writableType intValue]];
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
