//
//  MeetingExpenseDetailsDateTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsDateTableViewCell.h"

@implementation MeetingExpenseDetailsDateTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSDate* expDate = [aCellData objectForKey:@"FieldData"];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:expDate format:[GlobalSharedClass shared].dateFormat];
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(id)sender {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    self.thePopover = [self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceNormalDate defaultPickerDate:[self.cellData objectForKey:@"FieldData"]];
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
    [self.baseDelegate inputFinishedWithData:data atIndexPath:self.myIndexPath];
    [self clearPopoverCacheData];
}

@end
