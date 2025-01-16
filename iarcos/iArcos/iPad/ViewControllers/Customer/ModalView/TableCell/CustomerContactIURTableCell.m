//
//  CustomerContactIURTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactIURTableCell.h"

@implementation CustomerContactIURTableCell
@synthesize fieldDesc;
@synthesize contentString;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    if (self.fieldDesc != nil) { self.fieldDesc = nil; }            
    if (self.contentString != nil) { self.contentString = nil; }            
    if (self.factory != nil) { self.factory = nil; }            
//    if (self.thePopover != nil) { self.thePopover = nil; }
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.redAsterixLabel.hidden = YES;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
    self.contentString.text = [theData objectForKey:@"contentString"];    
    //    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;    
    /*
    self.contentString.inputView = [[[UIView alloc] init] autorelease];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentString addGestureRecognizer:singleTap];
    [singleTap release];
    */
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
//    NSLog(@"securityLevel: %@ %d employeeSecurityLevel: %d", securityLevel, [securityLevel intValue], self.employeeSecurityLevel);
    /*
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
        if ([self.fieldDesc.text isEqualToString:@"IUR"]) {
            self.contentString.enabled = NO;
        }
    } else {
        self.contentString.enabled = NO;
    }    
    if (self.contentString.isEnabled) {
        self.contentString.textColor = [UIColor blueColor];
    } else {
        self.contentString.textColor = [UIColor blackColor];
    }
     */
    self.contentString.enabled = YES;
    self.contentString.textColor = [UIColor blueColor];
    self.contentString.backgroundColor = [UIColor clearColor];
    if ([securityLevel intValue] == [GlobalSharedClass shared].blockedLevel || [[theData objectForKey:@"fieldDesc"] isEqualToString:@"IUR"]) {
        self.contentString.enabled = NO;
        self.contentString.textColor = [UIColor lightGrayColor];
    } else if ([securityLevel intValue] == [GlobalSharedClass shared].mandatoryLevel) {
        [self configRedAsterix];
    } else if ([securityLevel intValue] == [GlobalSharedClass shared].remindLevel) {
        self.contentString.backgroundColor = [UIColor yellowColor];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Make a new view, or do what you want here
    [self processDescrSelectionPopover];
    return NO;
}

-(void)handleSingleTapGesture:(id)sender {    
    [self processDescrSelectionPopover];
}

-(void)processDescrSelectionPopover {
    NSString* descrTypeCode = [self.cellData objectForKey:@"descrTypeCode"];
    NSMutableArray* dataList = nil;
    NSString* navigationBarTitle = nil;
    
//    dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:descrTypeCode];
    dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:descrTypeCode parentCode:nil checkActive:YES];
    navigationBarTitle = [[[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:descrTypeCode] objectForKey:@"Details"];
    [self processDescrSelectionCenter:navigationBarTitle dataList:dataList];    
}

-(void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
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
    [self.cellData setObject:[data objectForKey:@"DescrDetailIUR"] forKey:@"actualContent"];
    self.contentString.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[data objectForKey:@"Title"] actualData:[data objectForKey:@"DescrDetailIUR"] forIndexpath:self.indexPath];
}

-(void)dismissPopoverController {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveCustomerTypeParentViewController] dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

@end
