//
//  ProductDetailImageViewController.m
//  Arcos
//
//  Created by David Kilmartin on 13/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductDetailImageViewController.h"

@implementation ProductDetailImageViewController
@synthesize bigProductCodeImageView = _bigProductCodeImageView;
@synthesize imageResourceLocator = _imageResourceLocator;
//@synthesize HUD = _HUD;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize productCode = _productCode;
@synthesize callGenericServices = _callGenericServices;
@synthesize mediumImage = _mediumImage;
@synthesize showMediumImageExclusively = _showMediumImageExclusively;
@synthesize largeImageName = _largeImageName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showMediumImageExclusively = NO;
    }
    return self;
}

- (void) dealloc {
    if (self.bigProductCodeImageView != nil) { self.bigProductCodeImageView = nil; }
    if (self.imageResourceLocator != nil) { self.imageResourceLocator = nil; }
//    if (self.HUD != nil) { self.HUD = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    self.mediumImage = nil;
    self.largeImageName = nil;
            
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
//    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
//    self.HUD.dimBackground = YES;
//    self.HUD.labelText = @"Loading";
//    [self.navigationController.view addSubview:self.HUD];
    [ArcosUtils configEdgesForExtendedLayout:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    if (self.HUD != nil) { 
//        [self.HUD removeFromSuperview];
//        self.HUD = nil;
//    }
    if (self.bigProductCodeImageView != nil) { self.bigProductCodeImageView = nil; }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isNotFirstLoaded) return;
//    [self.HUD show:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    /*
    NSString* downloadServer = [SettingManager downloadServer];
    NSString* largeImageName = [NSString stringWithFormat:@"L-%@.png",self.productCode];
    NSString* filePath = [NSString stringWithFormat:@"%@%@", downloadServer,largeImageName];    
    @try {
        NSURL* url = [NSURL URLWithString:filePath];
        NSError* error = nil;
        NSData* imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (error != nil) {
            NSString* errorMsg = [NSString stringWithFormat:@"%@ not found.", filePath];
            [ArcosUtils showMsg:errorMsg delegate:nil];
        } else {
            UIImage* image = [UIImage imageWithData:imageData];
            self.bigProductCodeImageView.image = image;
        }
        self.isNotFirstLoaded = YES;
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
        NSString* errorMsg = [NSString stringWithFormat:@"%@ not found.", filePath];
        [ArcosUtils showMsg:errorMsg delegate:nil];
        self.isNotFirstLoaded = NO;
    }
    @finally {
        [self.HUD hide:YES];
    }    
    */
    if (self.showMediumImageExclusively) {
        self.bigProductCodeImageView.image = self.mediumImage;
        return;
    }
    self.largeImageName = [NSString stringWithFormat:@"L-%@.png",self.productCode];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.isNotRecursion = NO;
    [self.callGenericServices genericFileExistsInResourcesWithFileName:self.largeImageName action:@selector(setFileExistsInResources:) target:self];
//    [self.callGenericServices genericGetFromResourcesWithFileName:largeImageName action:@selector(setGenericGetFromResourcesResult:) target:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.navigationController.view setNeedsLayout];
}

-(void)setFileExistsInResources:(id)result {
    if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* aSoapFault = (SoapFault*)result;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[aSoapFault faultString]] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.callGenericServices.HUD hide:YES];
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.callGenericServices.HUD hide:YES];
    } else {
        @try {
            if ([result boolValue]) {
                [self.callGenericServices genericGetFromResourcesWithFileName:self.largeImageName action:@selector(setGenericGetFromResourcesResult:) target:self];
            } else {
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@ could not be located", self.largeImageName] title:@"" delegate:nil target:self tag:0 handler:nil];
                [self.callGenericServices.HUD hide:YES];
            }
        } @catch (NSException *exception) {
            [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
            [self.callGenericServices.HUD hide:YES];
        }
    }
}

-(void)setGenericGetFromResourcesResult:(id)result {
    [self.callGenericServices.HUD hide:YES];
    if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* anSoapFault = (SoapFault*)result;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anSoapFault faultString]] title:@"" delegate:nil target:self tag:0 handler:nil];
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
    } else {
        UIImage* anImage = nil;
        @try {
            NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
            anImage = [[[UIImage alloc] initWithData:myNSData] autorelease];
            self.bigProductCodeImageView.image = anImage;
        } @catch (NSException *exception) {
            [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
        }
    }
    
}

@end
