//
//  ArcosMailWrapperViewController.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailWrapperViewController.h"

@interface ArcosMailWrapperViewController ()

@end

@implementation ArcosMailWrapperViewController
//@synthesize myDelegate = _myDelegate;
@synthesize mailDelegate = _mailDelegate;
@synthesize customiseContentView = _customiseContentView;
@synthesize customiseScrollContentView = _customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize subjectText = _subjectText;
@synthesize bodyText = _bodyText;
@synthesize isHTML = _isHTML;
@synthesize toRecipients = _toRecipients;
@synthesize ccRecipients = _ccRecipients;
@synthesize attachmentList = _attachmentList;
@synthesize showSignatureFlag = _showSignatureFlag;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.subjectText = @"";
        self.bodyText = @"";
        self.isHTML = NO;
        self.toRecipients = [NSMutableArray array];
        self.ccRecipients = [NSMutableArray array];
        self.attachmentList = [NSMutableArray array];
        self.showSignatureFlag = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.customiseContentView = nil;
    self.customiseScrollContentView = nil;
    self.globalNavigationController = nil;
    self.subjectText = nil;
    self.bodyText = nil;
    self.toRecipients = nil;
    self.ccRecipients = nil;
    self.attachmentList = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    ArcosMailTableViewController* amtvc = [[ArcosMailTableViewController alloc] initWithNibName:@"ArcosMailTableViewController" bundle:nil];
    ArcosMailTableViewController* amtvc = nil;
    if (self.showSignatureFlag) {
        amtvc = [[ArcosMailTableViewController alloc] initWithNibName:@"ArcosMailSignatureViewController" bundle:nil];
    } else {
        amtvc = [[ArcosMailTableViewController alloc] initWithNibName:@"ArcosMailViewController" bundle:nil];
    }
//    amtvc.myDelegate = self;
    amtvc.mailDelegate = self;
    amtvc.arcosMailDataManager.subjectText = self.subjectText;
    amtvc.arcosMailDataManager.bodyText = self.bodyText;
    amtvc.arcosMailDataManager.isHTML = self.isHTML;
    amtvc.arcosMailDataManager.showSignatureFlag = self.showSignatureFlag;
    if ([self.toRecipients count] > 0) {
        amtvc.arcosMailDataManager.toRecipients = self.toRecipients;
        if ([self.toRecipients count] == 1) {
            NSString* auxToRecipient = [ArcosUtils convertNilToEmpty:[self.toRecipients objectAtIndex:0]];
            if ([auxToRecipient isEqualToString:@""]) {
                amtvc.arcosMailDataManager.toRecipients = [NSMutableArray array];
            }
        }
    }
    if ([self.ccRecipients count] > 0) {
        amtvc.arcosMailDataManager.ccRecipients = self.ccRecipients;
        if ([self.ccRecipients count] == 1) {
            NSString* auxCcRecipient = [ArcosUtils convertNilToEmpty:[self.ccRecipients objectAtIndex:0]];
            if ([auxCcRecipient isEqualToString:@""]) {
                amtvc.arcosMailDataManager.ccRecipients = [NSMutableArray array];
            }
        }
    }
    if ([self.attachmentList count] > 0) {
        amtvc.arcosMailDataManager.attachmentList = self.attachmentList;
    }
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amtvc] autorelease];
    [amtvc release];
    [self addChildViewController:self.globalNavigationController];
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;
    [self.globalNavigationController didMoveToParentViewController:self];
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [super viewDidDisappear:animated];
    [self.globalNavigationController willMoveToParentViewController:nil];
    [[self.customiseContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.globalNavigationController removeFromParentViewController];
}

//#pragma mark CustomisePresentViewControllerDelegate
//- (void)didDismissCustomisePresentView {
//    [self.myDelegate didDismissCustomisePresentView];
//}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [self.mailDelegate arcosMailDidFinishWithResult:aResult error:anError];
}



@end
