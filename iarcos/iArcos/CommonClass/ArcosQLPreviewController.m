//
//  ArcosQLPreviewController.m
//  Arcos
//
//  Created by David Kilmartin on 12/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosQLPreviewController.h"

@implementation ArcosQLPreviewController
//@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize mailController = _mailController;
@synthesize emailButton = _emailButton;
@synthesize previewButton = _previewButton;
@synthesize arcosPreviewDelegate = _arcosPreviewDelegate;
@synthesize isDownloadPdfFileClicked = _isDownloadPdfFileClicked;
@synthesize isNotNeedToShowPdfButton = _isNotNeedToShowPdfButton;

- (void)dealloc {
//    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
    if (self.mailController != nil) { self.mailController = nil; }
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.previewButton != nil) { self.previewButton = nil; }    
    if (self.arcosPreviewDelegate != nil) { self.arcosPreviewDelegate = nil; }
    
            
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
    emailRecipientTableViewController.requestSource = EmailRequestSourceReporter;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];  
//    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    [emailRecipientTableViewController release];
        
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];   
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.previewButton = [[[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(previewButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.navigationItem.rightBarButtonItem, self.emailButton, self.previewButton,nil];
    /*
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"up.png"],
                                             [UIImage imageNamed:@"down.png"],
                                             nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30.0);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
    
	UIBarButtonItem* segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    
    
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self.navigationItem.leftBarButtonItems objectAtIndex:0], nil];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    [segmentedControl release];
    [segmentBarItem release];
    */
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.navigationController.view setNeedsLayout];
}

-(void)emailButtonPressed:(id)sender {
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)previewButtonPressed:(id)sender {
    QLPreviewController* myPreviewController = [[QLPreviewController alloc] init];
    myPreviewController.dataSource = self.dataSource;
    myPreviewController.delegate = self;
    [self presentViewController:myPreviewController animated:YES completion:nil];
    [myPreviewController release];
}

- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
//    [self.emailPopover dismissPopoverAnimated:YES];
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    NSString* email = [cellData objectForKey:@"Email"];
    if (![@"" isEqualToString:email]) {
        NSArray* toRecipients = [NSArray arrayWithObjects:email, nil];
        [self.mailController setToRecipients:toRecipients];
    }
    [self.mailController setSubject:self.currentPreviewItem.previewItemTitle];
    if ([FileCommon fileExistAtPath:self.currentPreviewItem.previewItemURL.relativePath]) {
        NSData* data = [NSData dataWithContentsOfFile:self.currentPreviewItem.previewItemURL.relativePath];
        NSString* mimeTypeString = @"application/vnd.ms-excel";
        @try {
            NSArray *fileComponents = [self.currentPreviewItem.previewItemURL.lastPathComponent componentsSeparatedByString:@"."];
            // Use the filename (index 0) and the extension (index 1) to get path
            if ([@"pdf" isEqualToString:[fileComponents objectAtIndex:1]]) {
                mimeTypeString = @"application/pdf";
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }        
        [self.mailController addAttachmentData:data mimeType:mimeTypeString fileName:self.currentPreviewItem.previewItemURL.lastPathComponent];        
    }
    [self presentViewController:self.mailController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    NSString* message = nil;
    UIAlertView* v = nil;
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";            
//            v = [[UIAlertView alloc] initWithTitle:@"App Email" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [v show];
//            [v release];
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
            [v show];
            [v release];
        }            
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    
    // display an error
    NSLog(@"Email sending error message %@ ", message);
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.mailController != nil) { self.mailController = nil; }    
}

- (void)segmentAction:(id)sender {
    UISegmentedControl* segment = (UISegmentedControl*)sender;
//    NSLog(@"selectedSegmentIndex: %d", segment.selectedSegmentIndex);
    switch (segment.selectedSegmentIndex) {
        case 0: {
            [self setCurrentPreviewItemIndex:0];
        }
            break;
        case 1: {
            [self setCurrentPreviewItemIndex:1];
        }
            break;
        default:
            break;
    }
}


- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
//    NSLog(@"previewControllerDidDismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
