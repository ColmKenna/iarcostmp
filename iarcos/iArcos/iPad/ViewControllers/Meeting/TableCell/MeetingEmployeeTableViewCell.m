//
//  MeetingEmployeeTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingEmployeeTableViewCell.h"

@implementation MeetingEmployeeTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;
@synthesize searchButton = _searchButton;
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
    self.fieldValueTextField = nil;
    self.searchButton = nil;
    self.widgetFactory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
    NSMutableDictionary* fieldDataDict = [aCellData objectForKey:@"FieldData"];
    self.fieldValueTextField.text = [fieldDataDict objectForKey:@"Title"];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (IBAction)searchButtonPressed:(id)sender {
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    self.thePopover = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:employeeList title:@"Employee"];
    [self.thePopover presentPopoverFromRect:self.searchButton.bounds inView:self.searchButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    self.fieldValueTextField.text = [data objectForKey:@"Title"];
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
