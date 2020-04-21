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
@synthesize HUD = _HUD;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize productCode = _productCode;
@synthesize callGenericServices = _callGenericServices;
@synthesize mediumImage = _mediumImage;
@synthesize showMediumImageExclusively = _showMediumImageExclusively;

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
    if (self.HUD != nil) { self.HUD = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    self.mediumImage = nil;
            
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
    NSString* largeImageName = [NSString stringWithFormat:@"L-%@.png",self.productCode];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    [self.callGenericServices genericGetFromResourcesWithFileName:largeImageName action:@selector(setGenericGetFromResourcesResult:) target:self];
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

-(void)setGenericGetFromResourcesResult:(id)result {
    
    [self.callGenericServices.HUD hide:YES];
    BOOL successFlag = YES;
    if ([result isKindOfClass:[NSError class]]) {
        successFlag = NO;
    } else if ([result isKindOfClass:[SoapFault class]]) {
        successFlag = NO;
    }
    
    UIImage* anImage = nil;
    if (successFlag) {
        NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
        anImage = [[[UIImage alloc] initWithData:myNSData] autorelease];
        self.bigProductCodeImageView.image = anImage;
    } else {
//        self.bigProductCodeImageView.image = self.mediumImage;
        NSString* errorMsg = [NSString stringWithFormat:@"%@ not found.", [NSString stringWithFormat:@"L-%@.png",self.productCode]];
        [ArcosUtils showMsg:errorMsg delegate:nil];
    }    
}

@end
