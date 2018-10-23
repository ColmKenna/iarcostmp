//
//  CustomerInfoAccessTimesTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesTableViewCell.h"

@implementation CustomerInfoAccessTimesTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;
@synthesize actionBtn = _actionBtn;
@synthesize cellData = _cellData;
@synthesize accessTimesCalendarPopover = _accessTimesCalendarPopover;

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
    self.accessTimesCalendarPopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCustDict {
    self.cellData = aCustDict;
    UIImage* anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:141]];
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    [self.actionBtn setImage:anImage forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)showAccessTimesCalendar {
    if (self.accessTimesCalendarPopover != nil) {
        self.accessTimesCalendarPopover = nil;
    }
    CustomerInfoAccessTimesCalendarTableViewController* CIATCTVC = [[CustomerInfoAccessTimesCalendarTableViewController alloc] initWithStyle:UITableViewStylePlain];
    CIATCTVC.cancelDelegate = self;
    CIATCTVC.actionDelegate = self;
    CIATCTVC.calendarDataManager.recordDataDict = self.cellData;
//    CIATCTVC.accessTimesCalendarType = AccessTimesCalendarTypeHomePage;
    [CIATCTVC.calendarDataManager processRawDataWithAccessTimes:[self.cellData objectForKey:@"Access Times"] code:@"Location"];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CIATCTVC];
    self.accessTimesCalendarPopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];
    self.accessTimesCalendarPopover.delegate = self;
    self.accessTimesCalendarPopover.popoverContentSize = CGSizeMake(370, 968);
    [self.accessTimesCalendarPopover presentPopoverFromRect:self.actionBtn.bounds inView:self.actionBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [CIATCTVC release];
    CIATCTVC = nil;
    [tmpNavigationController release];
    tmpNavigationController = nil;
}

- (void)didDismissSelectionCancelPopover {
    if (self.accessTimesCalendarPopover != nil && [self.accessTimesCalendarPopover isPopoverVisible]) {
        [self.accessTimesCalendarPopover dismissPopoverAnimated:YES];
        self.accessTimesCalendarPopover = nil;
    }
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
}

- (void)closeCalendarPopoverViewController {
    if (self.accessTimesCalendarPopover != nil && [self.accessTimesCalendarPopover isPopoverVisible]) {
        [self.accessTimesCalendarPopover dismissPopoverAnimated:YES];
        self.accessTimesCalendarPopover = nil;
    }
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.accessTimesCalendarPopover = nil;
}

@end
