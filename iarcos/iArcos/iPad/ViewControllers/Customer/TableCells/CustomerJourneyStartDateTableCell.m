//
//  CustomerJourneyStartDateTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 06/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyStartDateTableCell.h"

@implementation CustomerJourneyStartDateTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize widgetFactory = _widgetFactory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize isEventSet = _isEventSet;
@synthesize cellData = _cellData;
@synthesize indexPath = _indexPath;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueLabel != nil) { self.fieldValueLabel = nil; }
    if (self.widgetFactory != nil) { self.widgetFactory = nil; }
//    if (self.thePopover != nil) { self.thePopover = nil; }
    self.globalWidgetViewController = nil;
    if (self.cellData != nil) { self.cellData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
    if (self.delegate != nil) { self.delegate = nil; }
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:[theData objectForKey:@"FieldData"] format:[GlobalSharedClass shared].dateFormat];
    
    if (!self.isEventSet) {
        self.isEventSet = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.fieldValueLabel addGestureRecognizer:singleTap];
        [singleTap release];
    }
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }

    NSNumber* writeType = [self.cellData objectForKey:@"WriteType"];
    NSDate* originalJourneyStartDate = [self.cellData objectForKey:@"OriginalJourneyStartDate"];
    self.globalWidgetViewController = [self.widgetFactory CreateDateWidgetWithDataSource:[writeType intValue] defaultPickerDate:originalJourneyStartDate];
//    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.fieldValueLabel;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = self.fieldValueLabel.bounds;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [[self.delegate retrieveCustomerJourneyStartDateParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

-(void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.delegate retrieveCustomerJourneyStartDateParentViewController] dismissViewControllerAnimated:YES completion:nil];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
}

@end
