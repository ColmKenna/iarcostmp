//
//  MeetingIURTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingIURTableViewCell.h"

@implementation MeetingIURTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize widgetFactory = _widgetFactory;
@synthesize thePopover = _thePopover;

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
    self.widgetFactory.popoverController = nil;
    self.widgetFactory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
    NSMutableDictionary* iurTypeDict = [aCellData objectForKey:@"FieldData"];
    self.fieldValueLabel.text = [iurTypeDict objectForKey:@"Title"];
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
    NSString* descrTypeCode = [self.cellData objectForKey:@"DescrTypeCode"];
    NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:descrTypeCode];
    NSDictionary* descrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:descrTypeCode];
    NSString* myTitle = [ArcosUtils convertNilToEmpty:[descrTypeDict objectForKey:@"Details"]];
    self.thePopover = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:descrDetailList title:myTitle];
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    [self.actionDelegate meetingBaseInputFinishedWithData:data atIndexPath:self.myIndexPath];
    [self clearPopoverCacheData];
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self clearPopoverCacheData];
}

- (void)clearPopoverCacheData {
    self.thePopover = nil;
    self.widgetFactory.popoverController = nil;
}



@end
