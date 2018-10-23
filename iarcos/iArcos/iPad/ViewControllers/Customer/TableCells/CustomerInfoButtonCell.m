//
//  CustomerInfoButtonCell.m
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoButtonCell.h"
#import "ArcosCoreData.h"

@implementation CustomerInfoButtonCell
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;
@synthesize actionBtn = _actionBtn;
@synthesize cellData = _cellData;
@synthesize accountDetailPopover = _accountDetailPopover;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
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
    self.accountDetailPopover = nil;
    
    [super dealloc];
}

- (IBAction)showAccountBalanceDetail {
    if (self.accountDetailPopover != nil) {
        self.accountDetailPopover = nil;
    }
    CustomerInfoAccountBalanceDetailTableViewController* CIABDTC = [[CustomerInfoAccountBalanceDetailTableViewController alloc] initWithNibName:@"CustomerInfoAccountBalanceDetailTableViewController" bundle:nil];
    CIABDTC.cancelDelegate = self;
    [CIABDTC processRawData:self.cellData];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CIABDTC];
    self.accountDetailPopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];
    self.accountDetailPopover.delegate = self;
    self.accountDetailPopover.popoverContentSize = CGSizeMake(410, 290);
    [self.accountDetailPopover presentPopoverFromRect:self.actionBtn.bounds inView:self.actionBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [CIABDTC release];
    CIABDTC = nil;
    [tmpNavigationController release];
    tmpNavigationController = nil;
}

#pragma mark GenericSelectionCancelDelegate
- (void)didDismissSelectionCancelPopover {
    if (self.accountDetailPopover != nil && [self.accountDetailPopover isPopoverVisible]) {
        [self.accountDetailPopover dismissPopoverAnimated:YES];
        self.accountDetailPopover = nil;
    }
}

- (void)configCellWithData:(NSMutableDictionary*)aCustDict {
    self.cellData = aCustDict;
    UIImage* anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:138]];
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    [self.actionBtn setImage:anImage forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.accountDetailPopover = nil;
}

@end
