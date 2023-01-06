//
//  ReportMainTemplateViewController.m
//  iArcos
//
//  Created by Richard on 04/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReportMainTemplateViewController.h"

@interface ReportMainTemplateViewController ()

@end

@implementation ReportMainTemplateViewController
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize templateView = _templateView;
@synthesize reportTableViewController = _reportTableViewController;
@synthesize reportNavigationController = _reportNavigationController;
@synthesize reporterXmlSubTableViewController = _reporterXmlSubTableViewController;
@synthesize reporterXmlGraphViewController = _reporterXmlGraphViewController;
@synthesize layoutKeyList = _layoutKeyList;
@synthesize layoutObjectList = _layoutObjectList;
@synthesize objectViewControllerList = _objectViewControllerList;
@synthesize layoutDict = _layoutDict;
@synthesize emailButton = _emailButton;
@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize reporterXmlExcelViewController = _reporterXmlExcelViewController;
@synthesize rootView = _rootView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize mailController = _mailController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.reportTableViewController = [[[ReportTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.reportNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.reportTableViewController] autorelease];
        self.reporterXmlSubTableViewController = [[[ReporterXmlSubTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.reporterXmlSubTableViewController.subTableDelegate = self;
        self.reporterXmlGraphViewController = [[[ReporterXmlGraphViewController alloc] initWithNibName:@"ReporterXmlGraphViewController" bundle:nil] autorelease];
        self.reporterXmlExcelViewController = [[[ReporterXmlExcelViewController alloc] initWithNibName:@"ReporterXmlExcelViewController" bundle:nil] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.rootView = [ArcosUtils getRootView];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.emailButton;
    
    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
    emailRecipientTableViewController.requestSource = EmailRequestSourceReporter;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    [emailRecipientTableViewController release];
    
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.mySegmentedControl.layer.cornerRadius = 0.0;
    self.mySegmentedControl.layer.borderColor = myColor.CGColor;
    self.mySegmentedControl.layer.borderWidth = 2.0f;
    self.mySegmentedControl.layer.masksToBounds = YES;
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction) forControlEvents:UIControlEventValueChanged];
    
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
//    [self.templateView.layer setCornerRadius:10.0];
    self.layoutKeyList = [NSArray arrayWithObjects:@"AuxListing", @"AuxSubTable", @"AuxGraph", @"AuxExcel", nil];
    self.layoutObjectList = [NSArray arrayWithObjects:self.reportNavigationController.view, self.reporterXmlSubTableViewController.view, self.reporterXmlGraphViewController.view, self.reporterXmlExcelViewController.view, nil];
    self.objectViewControllerList = [NSArray arrayWithObjects:self.reportNavigationController, self.reporterXmlSubTableViewController, self.reporterXmlGraphViewController, self.reporterXmlExcelViewController, nil];
    
    self.layoutDict = [NSDictionary dictionaryWithObjects:self.layoutObjectList forKeys:self.layoutKeyList];
    for (int i = 0; i < [self.layoutKeyList count]; i++) {
        NSString* tmpLayoutKey = [self.layoutKeyList objectAtIndex:i];
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        [self addChildViewController:tmpObjectViewController];
        [self.templateView addSubview:tmpObjectViewController.view];
        [tmpObjectViewController didMoveToParentViewController:self];
        [tmpObjectViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(0)-[%@]-(0)-|", tmpLayoutKey] options:0 metrics:0 views:self.layoutDict]];
        [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(0)-[%@]-(0)-|", tmpLayoutKey] options:0 metrics:0 views:self.layoutDict]];
    }

    [self segmentedAction];
}

- (void)dealloc {
    self.mySegmentedControl = nil;
    self.templateView = nil;
    self.reportTableViewController = nil;
    self.reportNavigationController = nil;
    self.reporterXmlSubTableViewController = nil;
    self.reporterXmlGraphViewController = nil;
    self.layoutDict = nil;
    self.layoutKeyList = nil;
    self.layoutObjectList = nil;
    self.objectViewControllerList = nil;
    self.emailButton = nil;
    self.emailPopover = nil;
    self.emailNavigationController = nil;
    self.reporterXmlExcelViewController = nil;
    self.rootView = nil;
    self.globalNavigationController = nil;
    self.mailController = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
    }
}

- (void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    NSString* email = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"Email"]];
    NSMutableArray* toRecipients = [NSMutableArray array];
    if (![@"" isEqualToString:email]) {
        toRecipients = [NSMutableArray arrayWithObjects:email, nil];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = self.reporterXmlExcelViewController.reportTitle;
        NSMutableString* msgBodyString = [NSMutableString stringWithString:@""];
        [msgBodyString appendString:@"Please find attached:\n"];
        [msgBodyString appendString:@"\n"];
        [msgBodyString appendString:self.reporterXmlExcelViewController.fileName];
        amwvc.bodyText = msgBodyString;
        if ([FileCommon fileExistAtPath:self.reporterXmlExcelViewController.filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.reporterXmlExcelViewController.filePath];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:data fileName:self.reporterXmlExcelViewController.fileName]];
            } else {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:self.reporterXmlExcelViewController.fileName]];
            }
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            [self.emailPopover dismissPopoverAnimated:YES];
        }];
        return;
    }
    
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    [self.emailPopover dismissPopoverAnimated:YES];
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    [self.mailController setToRecipients:toRecipients];
    [self.mailController setSubject:self.reporterXmlExcelViewController.fileName];
    if ([FileCommon fileExistAtPath:self.reporterXmlExcelViewController.filePath]) {
        NSData* data = [NSData dataWithContentsOfFile:self.reporterXmlExcelViewController.filePath];
        NSString* mimeTypeString = @"application/vnd.ms-excel";
        
        [self.mailController addAttachmentData:data mimeType:mimeTypeString fileName:self.reporterXmlExcelViewController.fileName];
    }
    
    [self presentViewController:self.mailController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = @"";
    NSString* title = @"";
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";
            title = @"App Email";
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            title = [GlobalSharedClass shared].errorTitle;
        }
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    if (result != MFMailComposeResultFailed) {
        [self alertViewCallBack];
    } else {
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:99 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self alertViewCallBack];
}

- (void)alertViewCallBack {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}

- (void)segmentedAction {
    for (int i = 0; i < [self.objectViewControllerList count]; i++) {
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        tmpObjectViewController.view.hidden = YES;
    }
    switch (self.mySegmentedControl.selectedSegmentIndex) {
        case 0: {
            self.reportNavigationController.view.hidden = NO;
            if (!self.reporterXmlSubTableViewController.reporterXmlSubDataManager.subTableRowPressed) {
                [self.reportTableViewController sortWithLinkIUR:self.reportTableViewController.nullStr];
            }
        }
            break;
            
        case 1: {
            self.reporterXmlSubTableViewController.view.hidden = NO;
        }
            break;
            
        case 2: {
            self.reporterXmlGraphViewController.view.hidden = NO;
        }
            break;
            
        case 3: {
            self.reporterXmlExcelViewController.view.hidden = NO;
        }
            break;
            
        
            
        default:
            break;
    }
}

#pragma mark ReporterXmlSubTableDelegate
- (void)subTableFooterPressed {
    self.mySegmentedControl.selectedSegmentIndex = 0;
    [self segmentedAction];
}

- (void)subTableRowPressedWithLinkIUR:(NSString *)aLinkIUR {
    self.mySegmentedControl.selectedSegmentIndex = 0;
    [self.reportTableViewController sortWithLinkIUR:aLinkIUR];
    [self segmentedAction];
}


@end
