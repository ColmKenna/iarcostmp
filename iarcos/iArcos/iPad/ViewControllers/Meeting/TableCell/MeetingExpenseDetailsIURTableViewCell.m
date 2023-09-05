//
//  MeetingExpenseDetailsIURTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsIURTableViewCell.h"

@implementation MeetingExpenseDetailsIURTableViewCell
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
    NSMutableDictionary* exTypeDict = [aCellData objectForKey:@"FieldData"];
    self.fieldValueLabel.text = [exTypeDict objectForKey:@"Title"];
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
    NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:@"EX"];
    NSDictionary* descrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"EX"];
    NSString* myTitle = [ArcosUtils convertNilToEmpty:[descrTypeDict objectForKey:@"Details"]];
    self.globalWidgetViewController = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:descrDetailList title:myTitle];
//    self.thePopover.delegate = self;
//    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    if (self.globalWidgetViewController != nil) {
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.fieldValueLabel;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.fieldValueLabel.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.baseDelegate retrieveMeetingExpenseDetailsParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

- (void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.baseDelegate retrieveMeetingExpenseDetailsParentViewController] dismissViewControllerAnimated:YES completion:nil];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    [self.baseDelegate inputFinishedWithData:data atIndexPath:self.myIndexPath];
    [self clearPopoverCacheData];
}

@end
