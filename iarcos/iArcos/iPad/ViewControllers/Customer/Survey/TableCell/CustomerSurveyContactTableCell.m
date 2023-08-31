//
//  CustomerSurveyContactTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyContactTableCell.h"

@implementation CustomerSurveyContactTableCell
//@synthesize narrative;
@synthesize contactTitle;
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

-(void)configCellWithData:(NSMutableDictionary*)theData{        
    self.cellData = theData;
    self.contactTitle.text = [theData objectForKey:@"Title"];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contactTitle addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    /*
    NSMutableArray* objectsArray = nil;
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        objectsArray = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    }
    NSMutableDictionary* emptyCustomerDict = [[[NSMutableDictionary alloc] init] autorelease];
    [emptyCustomerDict setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
    [emptyCustomerDict setObject:@"UnAssigned" forKey:@"Title"];
    [objectsArray insertObject:emptyCustomerDict atIndex:0];
    
    thePopover = [self.factory CreateGenericCategoryWidgetWithPickerValue:objectsArray title:@"Contact"];
     */
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:self.locationIUR];
    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [miscDataDict setObject:@"Contact" forKey:@"Title"];
    [miscDataDict setObject:self.locationIUR forKey:@"LocationIUR"];
    [miscDataDict setObject:self.locationName forKey:@"Name"];
    self.globalWidgetViewController =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
//    thePopover = [self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceContact];
    if (self.globalWidgetViewController != nil) {
//        [self.delegate popoverShows:thePopover];
    }else{
        self.contactTitle.text = @"No contact found";
    }
    
    //do show the popover if there is no data
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:contactTitle.bounds inView:contactTitle permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.contactTitle;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.contactTitle.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
    
}

-(void)operationDone:(id)data {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    self.contactTitle.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    self.globalWidgetViewController = nil;
}

-(BOOL)allowToShowAddContactButton {
    return YES;   
}

- (void)dealloc
{
//    if (self.narrative != nil) { self.narrative = nil; }
    if (self.contactTitle != nil) { self.contactTitle = nil; }
    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

@end
