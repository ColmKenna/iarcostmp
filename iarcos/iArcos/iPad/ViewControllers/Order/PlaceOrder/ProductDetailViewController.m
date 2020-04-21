//
//  ProductDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 11/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductDetailViewController.h"

@implementation ProductDetailViewController
@synthesize presentViewDelegate = _presentViewDelegate;
@synthesize callGenericServices = _callGenericServices;
@synthesize productIUR = _productIUR;
@synthesize locationIUR = _locationIUR;
@synthesize productCodeImageView = _productCodeImageView;
@synthesize productCodeButtonView = _productCodeButtonView;
@synthesize levelTableView = _levelTableView;
//@synthesize specTableView = _specTableView;
@synthesize stockTableView = _stockTableView;
@synthesize priceTableView = _priceTableView;
@synthesize codeTableView = _codeTableView;
@synthesize levelTableViewController = _levelTableViewController;
//@synthesize specTableViewController = _specTableViewController;
@synthesize stockTableViewController = _stockTableViewController;
@synthesize priceTableViewController = _priceTableViewController;
@synthesize codeTableViewController = _codeTableViewController;
@synthesize productDetailDataManager = _productDetailDataManager;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize productDetailRequestSource = _productDetailRequestSource;
@synthesize mediumImage = _mediumImage;

@synthesize posFilesButton = _posFilesButton;
@synthesize radioFilesButton = _radioFilesButton;
@synthesize advertFilesButton = _advertFilesButton;
@synthesize myArcosGenericClass = _myArcosGenericClass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.productDetailDataManager = [[[ProductDetailDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.productIUR != nil) { self.productIUR = nil; }
    self.locationIUR = nil;
    for (UIGestureRecognizer* recognizer in self.productCodeImageView.gestureRecognizers) {
        [self.productCodeImageView removeGestureRecognizer:recognizer];
    }
    if (self.productCodeImageView != nil) { self.productCodeImageView = nil; }
    self.productCodeButtonView = nil;
    if (self.levelTableView != nil) { self.levelTableView = nil; }
//    if (self.specTableView != nil) { self.specTableView = nil; }
    if (self.stockTableView != nil) { self.stockTableView = nil; }
    if (self.priceTableView != nil) { self.priceTableView = nil; } 
    if (self.codeTableView != nil) { self.codeTableView = nil; } 
    if (self.levelTableViewController != nil) { self.levelTableViewController = nil; }
//    if (self.specTableViewController != nil) { self.specTableViewController = nil; }
    if (self.stockTableViewController != nil) { self.stockTableViewController = nil; }
    if (self.priceTableViewController != nil) { self.priceTableViewController = nil; }
    if (self.codeTableViewController != nil) { self.codeTableViewController = nil; }
    
    if (self.productDetailDataManager != nil) { self.productDetailDataManager = nil; }
    self.mediumImage = nil;

    self.posFilesButton = nil;
    self.radioFilesButton = nil;
    self.advertFilesButton = nil;
    
    self.myArcosGenericClass = nil;
        
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
    // Do any additional setup after loading the view from its nib.#d3d7dd
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    self.productCodeButtonView.layer.borderWidth = 1.0f;
    [self.productCodeButtonView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drilldownTapGesture)];
    [self.productCodeButtonView addGestureRecognizer:singleTap];
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture)];
    doubleTap.numberOfTapsRequired = 2;
    [self.productCodeButtonView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [doubleTap release];
    [singleTap release];

    self.levelTableView.layer.cornerRadius = 10.0f;
    self.stockTableView.layer.cornerRadius = 10.0f;
    self.priceTableView.layer.cornerRadius = 10.0f;
    self.codeTableView.layer.cornerRadius = 10.0f;
    self.levelTableView.layer.borderWidth = 1.0f;
    [self.levelTableView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    self.stockTableView.layer.borderWidth = 1.0f;
    [self.stockTableView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    self.priceTableView.layer.borderWidth = 1.0f;
    [self.priceTableView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    self.codeTableView.layer.borderWidth = 1.0f;
    [self.codeTableView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    self.productDetailDataManager.productIUR = self.productIUR;
    self.levelTableViewController = [[[ProductDetailLevelTableViewController alloc] init] autorelease];
    self.levelTableViewController.productDetailDataManager = self.productDetailDataManager;
    self.stockTableViewController = [[[ProductDetailStockTableViewController alloc] init] autorelease];
    self.stockTableViewController.productDetailDataManager = self.productDetailDataManager;
    self.priceTableViewController = [[[ProductDetailPriceTableViewController alloc] init] autorelease];
    self.priceTableViewController.productDetailDataManager = self.productDetailDataManager;
    self.codeTableViewController = [[[ProductDetailCodeTableViewController alloc] init] autorelease];
    self.codeTableViewController.productDetailDataManager = self.productDetailDataManager;
    
    [self.levelTableView setDataSource:self.levelTableViewController];
    [self.levelTableView setDelegate:self.levelTableViewController];
    [self.stockTableView setDataSource:self.stockTableViewController];
    [self.stockTableView setDelegate:self.stockTableViewController];
    [self.priceTableView setDataSource:self.priceTableViewController];
    [self.priceTableView setDelegate:self.priceTableViewController];
    [self.codeTableView setDataSource:self.codeTableViewController];
    [self.codeTableView setDelegate:self.codeTableViewController];
    self.levelTableView.allowsSelection = NO;
    self.stockTableView.allowsSelection = NO;
    self.priceTableView.allowsSelection = NO;
    self.codeTableView.allowsSelection = NO;
    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
//    [self.productCodeImageView addGestureRecognizer:singleTap];    
//    [singleTap release];
    [ArcosUtils configEdgesForExtendedLayout:self];
    
    if (self.presentViewDelegate != nil) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
        [self.navigationItem setLeftBarButtonItem:closeButton];
        [closeButton release];
    }
}

- (void)drilldownTapGesture {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.showMediumImageExclusively = YES;
    pdivc.productCode = self.productDetailDataManager.productCode;
    pdivc.mediumImage = self.mediumImage;
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
}

- (void)handleDoubleTapGesture {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.productCode = self.productDetailDataManager.productCode;
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self resetDisplayLayout:orientation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self resetDisplayLayout:orientation];
    if (self.isNotFirstLoaded) return;
    
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    NSString* sqlStatement = [NSString stringWithFormat:@"select L1,L2,L3,L4,L5,StockAvailable,StockOnOrder,CONVERT(VARCHAR(19),StockDueDate,120),UnitRRP,UnitTradePrice,PacksPerCase,ProductCode,CatalogCode,EAN,Description,UnitsPerPack,PosFiles,RadioFiles,AdvertFiles from IPADViewProductDetails where IUR = %@", self.productIUR];
    self.callGenericServices.isNotRecursion = NO;
    [self.callGenericServices genericGetData:sqlStatement action:@selector(setGenericGetDataResult:) target:self];
    self.isNotFirstLoaded = YES; 
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self resetDisplayLayout:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.navigationController.view setNeedsLayout];
}

-(void)setGenericGetDataResult:(ArcosGenericReturnObject*)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        @try {
            self.myArcosGenericClass = [result.ArrayOfData objectAtIndex:0];
            self.title = [self.myArcosGenericClass Field15];
            NSString* productCode = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[self.myArcosGenericClass Field12]]];
            self.productDetailDataManager.productCode = productCode;
            NSString* mediumImageName = [NSString stringWithFormat:@"M-%@.png",productCode];
            /*
            NSString* downloadServer = [SettingManager downloadServer];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", downloadServer,mediumImageName]];
            NSError* error = nil;
            NSData* imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
            UIImage* image = nil;
            if (imageData != nil) {
                image = [UIImage imageWithData:imageData];
            } else {
                image = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
                if (image == nil) {
                    image = [UIImage imageNamed:@"iArcos_72.png"];
                }
            }
            self.productCodeImageView.image = image;
            */
            [self.productDetailDataManager processRawData:self.myArcosGenericClass];
            [self.levelTableView reloadData];
            [self.stockTableView reloadData];
            [self.priceTableView reloadData];
            if (self.myArcosGenericClass.Field17 != nil && ![[ArcosUtils trim:self.myArcosGenericClass.Field17] isEqualToString:@""]) {
                NSString* posDescrDetail = [self retrieveDescrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"POS"];
                if ([posDescrDetail isEqualToString:@""]) {
                    posDescrDetail = @"Pos";
                }
                [self.posFilesButton setTitle:posDescrDetail forState:UIControlStateNormal];
                self.posFilesButton.hidden = NO;
            }
            if (self.myArcosGenericClass.Field18 != nil && ![[ArcosUtils trim:self.myArcosGenericClass.Field18] isEqualToString:@""]) {
                NSString* radioDescrDetail = [self retrieveDescrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"RADIO"];
                if ([radioDescrDetail isEqualToString:@""]) {
                    radioDescrDetail = @"Radio";
                }
                [self.radioFilesButton setTitle:radioDescrDetail forState:UIControlStateNormal];
                self.radioFilesButton.hidden = NO;
            }
            if (self.myArcosGenericClass.Field19 != nil && ![[ArcosUtils trim:self.myArcosGenericClass.Field19] isEqualToString:@""]) {
                NSString* advertDescrDetail = [self retrieveDescrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"ADVERT"];
                if ([advertDescrDetail isEqualToString:@""]) {
                    advertDescrDetail = @"Advert";
                }
                [self.advertFilesButton setTitle:advertDescrDetail forState:UIControlStateNormal];
                self.advertFilesButton.hidden = NO;
            }
            
//            [self.codeTableView reloadData];
            if ([self.productDetailDataManager.productImageIUR intValue] != 0) {
                self.mediumImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:self.productDetailDataManager.productImageIUR];
                if (self.mediumImage != nil) {
                    self.productDetailDataManager.useLocalImageFlag = YES;
                    [self.productCodeButtonView setImage:self.mediumImage forState:UIControlStateNormal];                    
                    if ([self.locationIUR intValue] == 0) {
                        [self.callGenericServices.HUD hide:YES];
                        return;
                    }
                    [self.callGenericServices genericProductSalesPerLocationSummary:[self.locationIUR intValue] productiur:[self.productIUR intValue] action:@selector(setProductSalesPerLocationSummary:) target:self];
                }
            }
            if (!self.productDetailDataManager.useLocalImageFlag) {
                [self.callGenericServices genericGetFromResourcesWithFileName:mediumImageName action:@selector(setGenericGetFromResourcesResult:) target:self];
            }            
        }
        @catch (NSException *exception) {
            [self.callGenericServices.HUD hide:YES];
            [ArcosUtils showMsg:[exception reason] delegate:nil];
        }        
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (NSString*)retrieveDescrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode {
    NSString* resultDescrDetail = @"";
    NSMutableArray* objectDictList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:aDescrTypeCode descrDetailCode:aDescrDetailCode];
    if ([objectDictList count] > 0) {
        NSDictionary* objectDict = [objectDictList objectAtIndex:0];
        resultDescrDetail = [objectDict objectForKey:@"Detail"];
    }
    return resultDescrDetail;
}

-(void)setGenericGetFromResourcesResult:(id)result {
//    [self.callGenericServices.HUD hide:YES];
    BOOL successFlag = YES;
    if ([result isKindOfClass:[NSError class]]) {
        successFlag = NO;
    } else if ([result isKindOfClass:[SoapFault class]]) {
        successFlag = NO;
    }
    self.mediumImage = nil;
    if (successFlag) {
        NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
        self.mediumImage = [[[UIImage alloc] initWithData:myNSData] autorelease];
    } else {
        self.mediumImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
        if (self.mediumImage == nil) {
            self.mediumImage = [UIImage imageNamed:@"iArcos_72.png"];
        }
    }
//    self.productCodeImageView.image = anImage;
    [self.productCodeButtonView setImage:self.mediumImage forState:UIControlStateNormal];
    if ([self.locationIUR intValue] == 0) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    [self.callGenericServices genericProductSalesPerLocationSummary:[self.locationIUR intValue] productiur:[self.productIUR intValue] action:@selector(setProductSalesPerLocationSummary:) target:self];
}

- (void)setProductSalesPerLocationSummary:(ArcosGenericReturnObject*)result{
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.productDetailDataManager processProductLocationRawData:result.ArrayOfData];
        [self.codeTableView reloadData];
    } else if (result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (IBAction)pressProductButtonView {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.productCode = self.productDetailDataManager.productCode;
    pdivc.mediumImage = self.mediumImage;
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
}

- (void)resetDisplayLayout:(UIInterfaceOrientation)orientation {
    float width = (self.view.bounds.size.width - 40.0) / 3.0;
    float firstRowHeight = 44*4.0;
    float height = 44*9.0;
    float yOrigin = 240.0f;
    float buttonYOrigin = yOrigin + height + 20;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        float yOrigin = 284.0f;
//        float height = 307.0f;
        if (self.productDetailRequestSource == ProductDetailRequestSourceProductDetail) {
            [self productDetailLandscapeLayoutAction];
        } else {
            self.productCodeButtonView.frame = CGRectMake(10, 20, width, firstRowHeight);
            self.codeTableView.frame = CGRectMake(20 + width, 20, width*2.0 + 10, firstRowHeight);
            self.stockTableView.frame = CGRectMake(10, yOrigin, width, height);
            self.priceTableView.frame = CGRectMake(20 + width, yOrigin, width, height);
            self.levelTableView.frame = CGRectMake(30 + width * 2.0, yOrigin, width, height);
            self.posFilesButton.frame = CGRectMake(10, buttonYOrigin, width, self.posFilesButton.frame.size.height);
            self.radioFilesButton.frame = CGRectMake(20 + width, buttonYOrigin, width, self.posFilesButton.frame.size.height);
            self.advertFilesButton.frame = CGRectMake(30 + width * 2.0, buttonYOrigin, width, self.posFilesButton.frame.size.height);
        }        
    } else {
//        float yOrigin = 284.0f;
        // 10 263 516
        self.productCodeButtonView.frame = CGRectMake(10, 20, width, firstRowHeight);
        self.codeTableView.frame = CGRectMake(20 + width, 20, width*2.0 + 10, firstRowHeight);
        self.stockTableView.frame = CGRectMake(10, yOrigin, width, height);
        self.priceTableView.frame = CGRectMake(20 + width, yOrigin, width, height);
        self.levelTableView.frame = CGRectMake(30 + width * 2.0, yOrigin, width, height);
        
        self.posFilesButton.frame = CGRectMake(10, buttonYOrigin, width, self.posFilesButton.frame.size.height);
        self.radioFilesButton.frame = CGRectMake(20 + width, buttonYOrigin, width, self.posFilesButton.frame.size.height);
        self.advertFilesButton.frame = CGRectMake(30 + width * 2.0, buttonYOrigin, width, self.posFilesButton.frame.size.height);
    }
}

- (void)productDetailLandscapeLayoutAction {
    float yOrigin = 240.0f;
    float height = 44*9.0;
    self.stockTableView.frame = CGRectMake(10, yOrigin, 221, height);
    self.priceTableView.frame = CGRectMake(241, yOrigin, 222, height);
    self.levelTableView.frame = CGRectMake(473, yOrigin, 221, height);
}

-(void)closePressed:(id)sender {
    [self.presentViewDelegate didDismissPresentView];
}

- (IBAction)posFilesButtonPressed:(id)sender {
    [self buttonPressedProcessorWithUrlString:self.myArcosGenericClass.Field17];
}

- (IBAction)radioFilesButtonPressed:(id)sender {
    [self buttonPressedProcessorWithUrlString:self.myArcosGenericClass.Field18];
}

- (IBAction)advertFilesButtonPressed:(id)sender {
    [self buttonPressedProcessorWithUrlString:self.myArcosGenericClass.Field19];
}

- (void)buttonPressedProcessorWithUrlString:(NSString*)aUrlString {
    ProductDetailDesignViewController* PDDVC = [[ProductDetailDesignViewController alloc] initWithNibName:@"ProductDetailDesignViewController" bundle:nil];
    PDDVC.myURLString = aUrlString;
    [self.navigationController pushViewController:PDDVC animated:YES];
    [PDDVC release];
}

@end
