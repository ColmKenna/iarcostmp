//
//  MeetingExpenseDetailsBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsBaseTableViewCell.h"

@implementation MeetingExpenseDetailsBaseTableViewCell
@synthesize baseDelegate = _baseDelegate;
@synthesize cellData = _cellData;
@synthesize myIndexPath = _myIndexPath;
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
    self.cellData = nil;
    self.myIndexPath = nil;
//    self.widgetFactory.popoverController = nil;
    self.widgetFactory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.cellData = aCellData;
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
