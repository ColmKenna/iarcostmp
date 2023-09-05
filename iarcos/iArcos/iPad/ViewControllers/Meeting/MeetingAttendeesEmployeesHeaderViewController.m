//
//  MeetingAttendeesEmployeesHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 22/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesEmployeesHeaderViewController.h"

@interface MeetingAttendeesEmployeesHeaderViewController ()

@end

@implementation MeetingAttendeesEmployeesHeaderViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize addButton = _addButton;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    self.addButton = nil;
    self.factory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

- (IBAction)addButtonPressed:(id)sender {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    NSMutableArray* parentItemList = [NSMutableArray array];
    self.globalWidgetViewController = [self.factory CreateGenericTableMSWidgetWithData:employeeList withTitle:@"Employee" withParentItemList:parentItemList];
    
    //do show the popover if there is no data
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.addButton.bounds inView:self.addButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.addButton;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.addButton.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.actionDelegate retrieveMeetingAttendeesEmployeesParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

#pragma mark WidgetFactoryDelegate
-(void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.actionDelegate retrieveMeetingAttendeesEmployeesParentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.actionDelegate meetingAttendeesEmployeesOperationDone:data];
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    self.globalWidgetViewController = nil;
}

-(void)dismissPopoverController {
//    [self.thePopover dismissPopoverAnimated:YES];
//
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    [[self.actionDelegate retrieveMeetingAttendeesEmployeesParentViewController] dismissViewControllerAnimated:YES completion:^ {
        self.globalWidgetViewController = nil;
    }];
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
