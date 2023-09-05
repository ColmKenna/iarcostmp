//
//  NextCheckoutBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutBaseTableViewCell.h"

@implementation NextCheckoutBaseTableViewCell
@synthesize baseDelegate = _baseDelegate;
@synthesize fieldImageButton = _fieldImageButton;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize cellData = _cellData;
@synthesize widgetFactory = _widgetFactory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize indexPath = _indexPath;

- (void)dealloc {
    self.fieldImageButton = nil;
    self.fieldNameLabel = nil;
    self.fieldValueLabel = nil;
    self.cellData = nil;
    self.widgetFactory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.cellData = aCellData;
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
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

- (void)showPopoverProcessor {
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.fieldValueLabel;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = self.fieldValueLabel.bounds;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.globalWidgetViewController.popoverPresentationController.delegate = self;
    [[self.baseDelegate retrieveMainViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

@end
