//
//  OrderDetailDateHourMinTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 03/07/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderDetailDateHourMinTableCell.h"

@implementation OrderDetailDateHourMinTableCell

@synthesize widgetFactory = _widgetFactory;
@synthesize thePopover = _thePopover;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize isEventSet = _isEventSet;

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

- (void)dealloc {
    if (self.widgetFactory != nil) { self.widgetFactory = nil; }
    if (self.thePopover != nil) { self.thePopover = nil; }
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueLabel != nil) { self.fieldValueLabel = nil; }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    NSString* myDateFormat = [GlobalSharedClass shared].dateFormat;
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].includeCallTimeFlag) {
        myDateFormat = [GlobalSharedClass shared].datetimehmFormat;
    }
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:[theData objectForKey:@"FieldData"] format:myDateFormat];
    if (self.isNotEditable) {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blueColor];
    }
    if (!self.isEventSet) {
        self.isEventSet = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.fieldValueLabel addGestureRecognizer:singleTap];
        [singleTap release];
    }
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.isNotEditable) return;
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    //    NSLog(@"%@",self.cellData);
    NSNumber* writeType = [self.cellData objectForKey:@"WriteType"];
    self.thePopover = [self.widgetFactory CreateDateWidgetWithDataSource:[writeType intValue] pickerFormatType:DatePickerFormatDateTime defaultPickerDate:[self.cellData objectForKey:@"FieldData"]];
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    NSString* myDateFormat = [GlobalSharedClass shared].dateFormat;
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].includeCallTimeFlag) {
        myDateFormat = [GlobalSharedClass shared].datetimehmFormat;
    }
    self.fieldValueLabel.text = [ArcosUtils stringFromDate:data format:myDateFormat];
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
}

@end
