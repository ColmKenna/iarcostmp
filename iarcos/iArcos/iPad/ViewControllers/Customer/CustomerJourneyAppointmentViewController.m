//
//  CustomerJourneyAppointmentViewController.m
//  iArcos
//
//  Created by David Kilmartin on 21/05/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyAppointmentViewController.h"

@interface CustomerJourneyAppointmentViewController ()

@end

@implementation CustomerJourneyAppointmentViewController
@synthesize modalDelegate = _modalDelegate;
@synthesize callDateTitle = _callDateTitle;
@synthesize callDate = _callDate;
@synthesize callTypeTitle = _callTypeTitle;
@synthesize callType = _callType;
@synthesize contactTitle = _contactTitle;
@synthesize contact = _contact;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize currentLabelIndex = _currentLabelIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    UIBarButtonItem* cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    [cancelBarButtonItem release];
    UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
    self.title = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.callDate addGestureRecognizer:singleTap];
    [singleTap release];
    
    UITapGestureRecognizer* singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.callType addGestureRecognizer:singleTap1];
    [singleTap1 release];
    
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contact addGestureRecognizer:singleTap2];
    [singleTap2 release];
}

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.callDate.gestureRecognizers) {
        [self.callDate removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.callType.gestureRecognizers) {
        [self.callType removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.contact.gestureRecognizers) {
        [self.contact removeGestureRecognizer:recognizer];
    }
    self.callDateTitle = nil;
    self.callDate = nil;
    self.callTypeTitle = nil;
    self.callType = nil;
    self.contactTitle = nil;
    self.contact = nil;
    self.factory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

- (void)cancelButtonPressed {
    [self.modalDelegate didDismissModalPresentViewController];
}

- (void)saveButtonPressed {
    [self.modalDelegate didDismissModalPresentViewController];
}

- (void)handleSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    UILabel* aLabel = (UILabel*)recognizer.view;
    self.currentLabelIndex = aLabel.tag;
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    switch (aLabel.tag) {
        case 1: {
            self.globalWidgetViewController = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceNormalDate pickerFormatType:DatePickerFormatForceDateTime];
        }
            break;
        case 2: {
            self.globalWidgetViewController = [self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceCallType];
        }
            break;
        case 3: {
            NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
            NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
            [miscDataDict setObject:@"Contact" forKey:@"Title"];
            [miscDataDict setObject:[GlobalSharedClass shared].currentSelectedLocationIUR forKey:@"LocationIUR"];
            [miscDataDict setObject:[OrderSharedClass sharedOrderSharedClass].currentCustomerName forKey:@"Name"];
            self.globalWidgetViewController = [self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
        }
            break;
            
        default:
            break;
    }
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = aLabel;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = aLabel.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

- (BOOL)allowToShowAddContactButton {
    return NO;
}

- (void)operationDone:(id)data {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (self.currentLabelIndex) {
        case 1: {
            self.callDate.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].datetimehmFormat];
        }
            break;
            
        case 2: {
            self.callType.text = [data objectForKey:@"Title"];
        }
            break;
            
        case 3: {
            self.contact.text = [data objectForKey:@"Title"];
        }
            break;
            
        default:
            break;
    }
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

@end
