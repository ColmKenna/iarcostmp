//
//  OrderDetailLocationLabelTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "OrderDetailLocationLabelTableCell.h"

@implementation OrderDetailLocationLabelTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueLabel != nil) { self.fieldValueLabel = nil; }
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    NSMutableDictionary* tmpDataDict = [theData objectForKey:@"FieldData"];
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    NSNumber* showLocationCode = [configDict objectForKey:@"ShowlocationCode"];
    NSString* locationName = [tmpDataDict objectForKey:@"Name"];
    if ([showLocationCode boolValue]) {
        NSString* locationCode = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[tmpDataDict objectForKey:@"LocationCode"]]];
        locationName = [NSString stringWithFormat:@"%@ [%@]",locationName, locationCode];
    }
    self.fieldValueLabel.text = locationName;
    if (self.isNotEditable) {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blueColor];
    }
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateEnded) return;
    if (self.isNotEditable) return;
    CustomerSelectionListingTableViewController* CSLTVC = [[CustomerSelectionListingTableViewController alloc] initWithNibName:@"CustomerSelectionListingTableViewController" bundle:nil];
    CSLTVC.selectionDelegate = self;
    CSLTVC.isNotShowingAllButton = YES;
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
    [CSLTVC resetCustomer:locationList];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSLTVC];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.sourceView = self.fieldValueLabel;
    [[self.delegate retrieveParentViewController] presentViewController:tmpNavigationController animated:YES completion:nil];
    [CSLTVC release];
    [tmpNavigationController release];
}

#pragma mark CustomerSelectionListingDelegate
- (void)didDismissSelectionPopover {
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
    [self.delegate locationInputFinishedWithData:aCustDict forIndexpath:self.indexPath];
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
