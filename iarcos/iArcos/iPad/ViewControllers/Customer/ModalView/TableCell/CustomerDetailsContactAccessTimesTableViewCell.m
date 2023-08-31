//
//  CustomerDetailsContactAccessTimesTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 30/09/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsContactAccessTimesTableViewCell.h"

@implementation CustomerDetailsContactAccessTimesTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;
@synthesize actionBtn = _actionBtn;
@synthesize cellData = _cellData;
//@synthesize accessTimesCalendarPopover = _accessTimesCalendarPopover;
@synthesize typeCode = _typeCode;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.infoTitle = nil;
    self.infoValue = nil;
    self.actionBtn = nil;
    self.cellData = nil;
//    self.accessTimesCalendarPopover = nil;
    self.typeCode = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCustDict code:(NSString*)aCode {
    self.typeCode = aCode;
    self.cellData = aCustDict;
    UIImage* anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:141]];
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    [self.actionBtn setImage:anImage forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)showAccessTimesCalendar {
//    if (self.accessTimesCalendarPopover != nil) {
//        self.accessTimesCalendarPopover = nil;
//    }
    CustomerInfoAccessTimesCalendarTableViewController* CIATCTVC = [[CustomerInfoAccessTimesCalendarTableViewController alloc] initWithStyle:UITableViewStylePlain];
    CIATCTVC.cancelDelegate = self;
    CIATCTVC.actionDelegate = self;
    CIATCTVC.calendarDataManager.recordDataDict = self.cellData;
    [CIATCTVC.calendarDataManager processRawDataWithAccessTimes:[self.cellData objectForKey:@"Access Times"] code:self.typeCode];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CIATCTVC];
//    self.accessTimesCalendarPopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];
//    self.accessTimesCalendarPopover.delegate = self;
//    self.accessTimesCalendarPopover.popoverContentSize = CGSizeMake(370, 968);
//    [self.accessTimesCalendarPopover presentPopoverFromRect:self.actionBtn.bounds inView:self.actionBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    tmpNavigationController.preferredContentSize = CGSizeMake(370, 968);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.sourceView = self.actionBtn;
    tmpNavigationController.popoverPresentationController.sourceRect = self.actionBtn.bounds;
    tmpNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    tmpNavigationController.popoverPresentationController.delegate = self;
    [[self.actionDelegate retrieveCustomerInfoAccessTimesCalendarParentViewController] presentViewController:tmpNavigationController animated:YES completion:nil];
    
    [CIATCTVC release];
    CIATCTVC = nil;
    [tmpNavigationController release];
    tmpNavigationController = nil;
}

- (void)didDismissSelectionCancelPopover {
//    if (self.accessTimesCalendarPopover != nil && [self.accessTimesCalendarPopover isPopoverVisible]) {
//        [self.accessTimesCalendarPopover dismissPopoverAnimated:YES];
//        self.accessTimesCalendarPopover = nil;
//    }
    [[self.actionDelegate retrieveCustomerInfoAccessTimesCalendarParentViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
}

- (void)closeCalendarPopoverViewController {
//    if (self.accessTimesCalendarPopover != nil && [self.accessTimesCalendarPopover isPopoverVisible]) {
//        [self.accessTimesCalendarPopover dismissPopoverAnimated:YES];
//        self.accessTimesCalendarPopover = nil;
//    }
    [[self.actionDelegate retrieveCustomerInfoAccessTimesCalendarParentViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.accessTimesCalendarPopover = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
}

@end
