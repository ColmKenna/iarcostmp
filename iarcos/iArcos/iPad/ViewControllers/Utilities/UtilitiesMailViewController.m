//
//  UtilitiesMailViewController.m
//  iArcos
//
//  Created by Apple on 27/12/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "UtilitiesMailViewController.h"
#import "ArcosUtils.h"
#import "ArcosSplitViewController.h"

@interface UtilitiesMailViewController ()

@end

@implementation UtilitiesMailViewController
@synthesize presentDelegate = _presentDelegate;
//@synthesize kScopes = _kScopes;
@synthesize webViewParameters = _webViewParameters;
@synthesize signInButton = _signInButton;
@synthesize signOutButton = _signOutButton;
//@synthesize myTextView = _myTextView;
@synthesize myLabel = _myLabel;
@synthesize renewButton = _renewButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
//    [self.myTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//    [self.myTextView.layer setBorderWidth:0.5];
//    [self.myTextView.layer setCornerRadius:5.0f];
//    NSMutableArray* leftButtonList = [NSMutableArray arrayWithCapacity:3];
//    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].backButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
//    [leftButtonList addObject:closeButton];
//    [closeButton release];
//    UIBarButtonItem* signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutPressed:)];
//    [leftButtonList addObject:signOutButton];
//    [signOutButton release];
//    UIBarButtonItem* useAnotherAccountButton = [[UIBarButtonItem alloc] initWithTitle:@"Use another account" style:UIBarButtonItemStylePlain target:self action:@selector(useAnotherAccountPressed:)];
//    [leftButtonList addObject:useAnotherAccountButton];
//    [useAnotherAccountButton release];
    
//    [self.navigationItem setLeftBarButtonItems:leftButtonList];
//
//    UIBarButtonItem* signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(signInPressed:)];
//    [self.navigationItem setRightBarButtonItem:signInButton];
//    [signInButton release];
//    self.kScopes = [NSArray arrayWithObjects:@"https://graph.microsoft.com/user.read", @"https://graph.microsoft.com/Mail.Send", @"https://graph.microsoft.com/Mail.ReadWrite", @"https://graph.microsoft.com/Calendars.Read", @"https://graph.microsoft.com/Calendars.ReadWrite", nil];
//    self.webViewParameters = [[[MSALWebviewParameters alloc] initWithParentViewController:self] autorelease];
    self.webViewParameters = [[[MSALWebviewParameters alloc] initWithAuthPresentationViewController:self] autorelease];
//    self.webViewParameters.webviewType = MSALWebviewTypeWKWebView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self controlLeftBarButtonItem];
    if (![[ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress isEqualToString:@""]) {
//        self.myTextView.text = [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress;
        self.myLabel.text = [ArcosUtils convertNilToEmpty:[ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress];
    } else {
//        self.myTextView.text = @"";
        self.myLabel.text = @"";
    }
}

- (void)dealloc {
//    self.kScopes = nil;
    self.webViewParameters = nil;
    self.signInButton = nil;
    self.signOutButton = nil;
//    self.myTextView = nil;
    self.myLabel = nil;
    self.renewButton = nil;
    
    [super dealloc];
}

- (void)closePressed:(id)sender {
    [self.presentDelegate didDismissCustomisePresentView];
}

- (IBAction)signOutPressed:(id)sender {
    MSALAccount* msalAccount = [self currentAccount];
    NSError* error = nil;
    if (msalAccount != nil) {
        [[ArcosConstantsDataManager sharedArcosConstantsDataManager].applicationContext removeAccount:msalAccount error:&error];
        [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken = @"";
        [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress = @"";
//        self.myTextView.text = [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress;
        self.myLabel.text = [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress;
    }
    if (error != nil) {
//        NSLog(@"error %@", [error description]);
        [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:self tag:0 handler:nil];
    } else {
//        UtilitiesSignOutViewController* utilitiesSignOutViewController = [[UtilitiesSignOutViewController alloc] initWithNibName:@"UtilitiesSignOutViewController" bundle:nil];
//        utilitiesSignOutViewController.delegate = self;
//        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:utilitiesSignOutViewController];
//        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:navigationController animated:YES completion:nil];
//        [utilitiesSignOutViewController release];
//        [navigationController release];
    }    
}

- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)useAnotherAccountPressed:(id)sender {
//    NSLog(@"abc");
    [self acquireTokenInteractively:YES];
}

- (IBAction)signInPressed:(id)sender {
    [self acquireTokenInteractively:NO];
}

- (void)acquireTokenInteractively:(BOOL)aLoginFlag {
    MSALInteractiveTokenParameters* parameters = [[[MSALInteractiveTokenParameters alloc] initWithScopes:[ArcosConstantsDataManager sharedArcosConstantsDataManager].kScopes webviewParameters:self.webViewParameters] autorelease];
    if (aLoginFlag) {
        parameters.promptType = MSALPromptTypeLogin;
    }
    [[ArcosConstantsDataManager sharedArcosConstantsDataManager].applicationContext acquireTokenWithParameters:parameters completionBlock:^(MSALResult * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken = result.accessToken;
//            NSLog(@"token: %@", result.accessToken);
//            self.myTextView.text = [result.account username];
            [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress = [result.account username];
//            NSLog(@"expired at: %@", result.expiresOn);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.myLabel.text = [result.account username];
            });
//            [self retrieveContentWithToken];
//                [self sendMailProcessor];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:self tag:0 handler:nil];
            });
        }
    }];
}

- (MSALAccount*)currentAccount {
    NSArray* accountList = [[ArcosConstantsDataManager sharedArcosConstantsDataManager].applicationContext allAccounts:nil];
//    NSLog(@"account count: %d", [ArcosUtils convertNSUIntegerToUnsignedInt:[accountList count]]);
//    for (int i = 0; i < [accountList count]; i++) {
//        MSALAccount* tmpMSALAccount = [accountList objectAtIndex:i];
//        NSLog(@"index %d: %@", i, tmpMSALAccount.username);
//    }
    if ([accountList count] > 0) {
        return accountList.firstObject;
    }
    return nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self controlLeftBarButtonItem];
}

- (void)controlLeftBarButtonItem {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController;
        UIViewController* masterViewController = [arcosSplitViewController.rcsViewControllers objectAtIndex:0];
        UIBarButtonItem* leftBarButton = [[[UIBarButtonItem alloc] initWithTitle:masterViewController.title style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPressed)] autorelease];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }else{
        self.navigationItem.leftBarButtonItem=nil;
    }
}

- (void)leftBarButtonPressed {
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController;
    [arcosSplitViewController rightMoveMasterViewController];
}


- (IBAction)renewPressed:(id)sender {
    self.renewButton.enabled = NO;
    MSALAccount* myMSALAccount = [self currentAccount];
    MSALSilentTokenParameters* myMSALSilentTokenParameters = [[[MSALSilentTokenParameters alloc] initWithScopes:[ArcosConstantsDataManager sharedArcosConstantsDataManager].kScopes account:myMSALAccount] autorelease];
    [[ArcosConstantsDataManager sharedArcosConstantsDataManager].applicationContext acquireTokenSilentWithParameters:myMSALSilentTokenParameters completionBlock:^(MSALResult * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken = result.accessToken;
//            NSLog(@"renew token: %@", result.accessToken);
            [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress = [result.account username];
//            NSLog(@"renew expired at: %@", result.expiresOn);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.myLabel.text = [result.account username];
                [ArcosUtils showDialogBox:@"Completed" title:@"" delegate:nil target:self tag:0 handler:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:self tag:0 handler:nil];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.renewButton.enabled = YES;
        });
    }];
}

@end
