//
//  QueryOrderTaskIURTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskIURTableCell.h"

@implementation QueryOrderTaskIURTableCell
@synthesize fieldDesc = _fieldDesc;
@synthesize contentString = _contentString;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    self.fieldDesc = nil;
    self.contentString = nil;
    self.factory = nil;
//    if (self.thePopover != nil) { self.thePopover = nil; }
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
    self.contentString.text = [theData objectForKey:@"contentString"];
    
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
        self.contentString.textColor = [UIColor blueColor];
    } else {
        self.contentString.enabled = NO;
        self.contentString.textColor = [UIColor blackColor];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Make a new view, or do what you want here
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    if ([[self.delegate getFieldNameWithIndexPath:self.indexPath] isEqualToString:@"ContactIUR"]) {
        [self processContactDescrSelectionPopover];
        return NO;
    }
    [self processDescrSelectionPopover];
    return NO;
}

-(void)processDescrSelectionPopover {
    NSString* descrTypeCode = [self.cellData objectForKey:@"descrTypeCode"];
    NSMutableArray* dataList = nil;
    NSString* navigationBarTitle = nil;
    
    dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:descrTypeCode];
    navigationBarTitle = [[[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:descrTypeCode] objectForKey:@"Details"];
    [self processDescrSelectionCenter:navigationBarTitle dataList:dataList];
}

-(void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList {
    
    self.globalWidgetViewController = [self.factory CreateTableWidgetWithData:aDataList withTitle:aNavBarTitle withParentContentString:[self.cellData objectForKey:@"contentString"]];
    //do show the popover if there is no data
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.contentString.bounds inView:self.contentString permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.contentString;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.contentString.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveCustomerTypeParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
    
}

-(void)operationDone:(id)data {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveCustomerTypeParentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.cellData setObject:[data objectForKey:@"Title"] forKey:@"contentString"];
    if ([[self.delegate getFieldNameWithIndexPath:self.indexPath] isEqualToString:@"ContactIUR"]) {
        [self.cellData setObject:[data objectForKey:@"IUR"] forKey:@"actualContent"];
    } else {
        [self.cellData setObject:[data objectForKey:@"DescrDetailIUR"] forKey:@"actualContent"];
    }
    self.contentString.text = [self.cellData objectForKey:@"contentString"];
    [self.delegate inputFinishedWithData:[self.cellData objectForKey:@"contentString"] actualData:[self.cellData objectForKey:@"actualContent"] forIndexpath:self.indexPath];
}

-(void)dismissPopoverController {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveCustomerTypeParentViewController] dismissViewControllerAnimated:YES completion:^ {
        self.globalWidgetViewController = nil;
    }];
}

- (void)processContactDescrSelectionPopover {
    if (self.locationName == nil) {
        NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:self.locationIUR];
        if ([locationList count] > 0) {
            NSDictionary* locationDict = [locationList objectAtIndex:0];
            self.locationName = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]];
        } else {
            self.locationName = @"";
        }
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:self.locationIUR];
    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [miscDataDict setObject:@"Contact" forKey:@"Title"];
    [miscDataDict setObject:self.locationIUR forKey:@"LocationIUR"];
    [miscDataDict setObject:self.locationName forKey:@"Name"];
    self.globalWidgetViewController =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.contentString.bounds inView:self.contentString permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.contentString;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.contentString.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveCustomerTypeParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

-(BOOL)allowToShowAddContactButton {
    return YES;
}

#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

@end
