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
@synthesize thePopover = _thePopover;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    self.addButton = nil;
    self.factory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (IBAction)addButtonPressed:(id)sender {
    NSLog(@"ac1");
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    NSMutableArray* parentItemList = [NSMutableArray array];
    self.thePopover = [self.factory CreateGenericTableMSWidgetWithData:employeeList withTitle:@"Employee" withParentItemList:parentItemList];
    
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.addButton.bounds inView:self.addButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark WidgetFactoryDelegate
-(void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    [self.actionDelegate meetingAttendeesEmployeesOperationDone:data];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

-(void)dismissPopoverController {
    [self.thePopover dismissPopoverAnimated:YES];
    
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
