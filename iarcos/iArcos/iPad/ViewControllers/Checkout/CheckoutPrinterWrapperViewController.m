//
//  CheckoutPrinterWrapperViewController.m
//  iArcos
//
//  Created by David Kilmartin on 03/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CheckoutPrinterWrapperViewController.h"
#import "OrderSharedClass.h"
#import "ArcosCoreData.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "ZebraPrinterConnection.h"
#import "ZebraPrinter.h"
#import "ZebraPrinterFactory.h"
#import "MFiBtPrinterConnection.h"

@interface CheckoutPrinterWrapperViewController ()

@end

@implementation CheckoutPrinterWrapperViewController
@synthesize isOrderPadPrinterType = _isOrderPadPrinterType;
@synthesize checkoutPrinterRequestSource = _checkoutPrinterRequestSource;
//@synthesize myDelegate = _myDelegate;
@synthesize modalDelegate = _modalDelegate;
@synthesize locationNameLabel = _locationNameLabel;
@synthesize address1Label = _address1Label;
@synthesize address2Label = _address2Label;
@synthesize address3Label = _address3Label;
@synthesize address4Label = _address4Label;
//@synthesize totalOrderValueTitleLabel = _totalOrderValueTitleLabel;
//@synthesize totalOrderValueContentLabel = _totalOrderValueContentLabel;
@synthesize orderLineTableView = _orderLineTableView;
@synthesize drawingAreaView = _drawingAreaView;
@synthesize pleaseSignHereLabel = _pleaseSignHereLabel;
@synthesize printButton = _printButton;
@synthesize printEmailButton = _printEmailButton;
@synthesize bothButton = _bothButton;
@synthesize cancelButton = _cancelButton;
@synthesize sortedOrderKeys = _sortedOrderKeys;
//@synthesize checkoutPDFRenderer = _checkoutPDFRenderer;
//@synthesize fileName = _fileName;
@synthesize compositeErrorResult = _compositeErrorResult;
@synthesize orderHeader = _orderHeader;
@synthesize orderLines = _orderLines;
//@synthesize orderLineFont = _orderLineFont;
@synthesize logoImage = _logoImage;
@synthesize orderDetailOrderEmailActionDataManager = _orderDetailOrderEmailActionDataManager;
@synthesize orderLineHeaderView = _orderLineHeaderView;
@synthesize orderLineFooterView = _orderLineFooterView;
@synthesize checkoutPrinterWrapperDataManager = _checkoutPrinterWrapperDataManager;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize descrDetailDictList = _descrDetailDictList;
@synthesize descrDetailDictHashMap = _descrDetailDictHashMap;
@synthesize descrDetailIurLineValueHashMap = _descrDetailIurLineValueHashMap;
@synthesize includePriceLabel = _includePriceLabel;
@synthesize includePriceSwitch = _includePriceSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.drawingAreaView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//    [self.drawingAreaView.layer setBorderWidth:0.5];
//    [self.drawingAreaView.layer setCornerRadius:5.0f];
    self.rootView = [ArcosUtils getRootView];
    self.checkoutPrinterWrapperDataManager = [[[CheckoutPrinterWrapperDataManager alloc] init] autorelease];
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    [self.orderLineTableView.layer setBorderColor:[myColor CGColor]];
    [self.orderLineTableView.layer setBorderWidth:1.0];
    if ([self.orderLineTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.orderLineTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.orderLineTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.orderLineTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.orderLineTableView setSeparatorColor:myColor];
    
    self.locationNameLabel.text = [self.orderHeader objectForKey:@"CustName"];
    self.address1Label.text = [self.orderHeader objectForKey:@"Address1"];
    self.address2Label.text = [self.orderHeader objectForKey:@"Address2"];
    self.address3Label.text = [self.orderHeader objectForKey:@"Address3"];
    self.address4Label.text = [self.orderHeader objectForKey:@"Address4"];
//
//    self.totalOrderValueContentLabel.text = [self.orderHeader objectForKey:@"totalGoodsText"];
//    self.checkoutPDFRenderer = [[[CheckoutPDFRenderer alloc] init] autorelease];
//    self.fileName = @"order.pdf";
    self.orderLines = [[ArcosCoreData sharedArcosCoreData] allOrderLinesWithOrderNumber:[self.orderHeader objectForKey:@"OrderNumber"] withSortKey:@"OrderLine" locationIUR:[self.orderHeader objectForKey:@"LocationIUR"]];
//    self.orderLineFont = [UIFont systemFontOfSize:11.0];    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternativeLogoFlag]) {
        self.logoImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:100]];            
    } else {
        self.logoImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:1]];
    }
    self.orderDetailOrderEmailActionDataManager = [[[OrderDetailOrderEmailActionDataManager alloc] initWithOrderHeader:self.orderHeader] autorelease];
    self.orderDetailOrderEmailActionDataManager.showSignatureFlag = YES;
    if (self.isOrderPadPrinterType) {
        self.printEmailButton.hidden = YES;
        self.bothButton.hidden = YES;
        NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:[GlobalSharedClass shared].currentSelectedLocationIUR];
        if (locationList != nil && [locationList count] > 0) {
            NSDictionary* locationDict = [locationList objectAtIndex:0];
            self.locationNameLabel.text = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]];
            self.address1Label.text = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address1"]];
            self.address2Label.text = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address2"]];
            self.address3Label.text = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address3"]];
            self.address4Label.text = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address4"]];
        }
        NSMutableArray* sortedOrderKeys = [[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[[OrderSharedClass sharedOrderSharedClass].currentOrderCart allValues]];
        self.orderLines = [NSMutableArray arrayWithCapacity:[sortedOrderKeys count]];
        for (int i = 0; i < [sortedOrderKeys count]; i++) {
            NSString* name = [sortedOrderKeys objectAtIndex:i];            
            NSMutableDictionary* auxCellDataDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:name];
            [self.orderLines addObject:auxCellDataDict];
        }
    }    
    if (!self.isOrderPadPrinterType && self.checkoutPrinterRequestSource != CheckoutPrinterCheckout) {
        NSMutableArray* auxDataList = [self createData];
        [self.drawingAreaView loadData:auxDataList];
        [self.drawingAreaView setUserInteractionEnabled:NO];
    }
    NSMutableArray* vcIurList = [NSMutableArray array];
    for (int i = 0; i < [self.orderLines count]; i++) {
        NSMutableDictionary* tmpOrderLineDict = [self.orderLines objectAtIndex:i];
        [vcIurList addObject:[tmpOrderLineDict objectForKey:@"VCIUR"]];
    }
    self.descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:vcIurList];
    NSSortDescriptor* descrDetailCodeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"DescrDetailCode" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [self.descrDetailDictList sortUsingDescriptors:[NSArray arrayWithObjects:descrDetailCodeDescriptor,nil]];
    self.descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[self.descrDetailDictList count]];
    for (int i = 0; i < [self.descrDetailDictList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [self.descrDetailDictList objectAtIndex:i];
        [self.descrDetailDictHashMap setObject:tmpDescrDetailDict forKey:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
    }
}

- (void)dealloc {
    self.locationNameLabel = nil;
    self.address1Label = nil;
    self.address2Label = nil;
    self.address3Label = nil;
    self.address4Label = nil;
//    self.totalOrderValueTitleLabel = nil;
//    self.totalOrderValueContentLabel = nil;
    self.orderLineTableView = nil;
    self.drawingAreaView = nil;
    self.pleaseSignHereLabel = nil;
    self.printButton = nil;
    self.printEmailButton = nil;
    self.bothButton = nil;
    self.cancelButton = nil;
    self.sortedOrderKeys = nil;
//    self.checkoutPDFRenderer = nil;
//    self.fileName = nil;
    self.compositeErrorResult = nil;
    self.orderHeader = nil;
    self.orderLines = nil;
//    self.orderLineFont = nil;
    self.logoImage = nil;
    self.orderDetailOrderEmailActionDataManager = nil;
    self.orderLineHeaderView = nil;
    self.orderLineFooterView = nil;
    self.checkoutPrinterWrapperDataManager = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    self.descrDetailDictList = nil;
    self.descrDetailDictHashMap = nil;
    self.descrDetailIurLineValueHashMap = nil;
    self.includePriceLabel = nil;
    self.includePriceSwitch = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.orderLines count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.orderLineHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    int totalQty = 0;
    int totalBonus = 0;
    for (int i = 0; i < [self.orderLines count]; i++) {
        NSMutableDictionary* tmpCellDict = [self.orderLines objectAtIndex:i];
        totalQty += [[tmpCellDict objectForKey:@"Qty"] intValue];
        totalBonus += [[tmpCellDict objectForKey:@"Bonus"] intValue]; 
    }
    self.orderLineFooterView.totalQty.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalQty]];
    self.orderLineFooterView.totalBon.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalBonus]];
    return self.orderLineFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* checkoutOrderLineCellIdentifier = @"IdCheckoutPrinterOrderLineTableViewCell";
    
    CheckoutPrinterOrderLineTableViewCell* cell = (CheckoutPrinterOrderLineTableViewCell*) [tableView dequeueReusableCellWithIdentifier:checkoutOrderLineCellIdentifier];
    if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CheckoutPrinterOrderLineTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CheckoutPrinterOrderLineTableViewCell class]] && [[(CheckoutPrinterOrderLineTableViewCell*)nibItem reuseIdentifier] isEqualToString:checkoutOrderLineCellIdentifier]) {
                cell = (CheckoutPrinterOrderLineTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSMutableDictionary* cellDataDict = [self.orderLines objectAtIndex:indexPath.row];
    cell.productCodeOrderPadDetails.text = [NSString stringWithFormat:@"%@ %@", [cellDataDict objectForKey:@"ProductCode"], [cellDataDict objectForKey:@"OrderPadDetails"]];
    cell.productDesc.text = [cellDataDict objectForKey:@"Details"];
    NSString* qtyString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [cellDataDict objectForKey:@"Qty"]]];
    NSString* instockString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [cellDataDict objectForKey:@"InStock"]]];
    if (![instockString isEqualToString:@""]) {
        qtyString = [NSString stringWithFormat:@"%@/%@",qtyString,instockString];
    }
    cell.qty.text = qtyString;
    NSString* bonusString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [cellDataDict objectForKey:@"Bonus"]]];
    NSString* focString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [cellDataDict objectForKey:@"FOC"]]];
    if (![focString isEqualToString:@""]) {
        bonusString = [NSString stringWithFormat:@"%@/%@",bonusString,focString];
    }
    cell.bon.text = bonusString;
    
    return cell;
}

- (IBAction)cancelButtonPressed:(id)sender {
    if (self.checkoutPrinterRequestSource == CheckoutPrinterCheckout) {
        [self.checkoutPrinterWrapperDataManager saveSignatureWithOrderNumber:[self.orderHeader objectForKey:@"OrderNumber"] dataList:self.drawingAreaView.listOfLines];
    }    
//    [self.myDelegate didDismissCustomisePresentView];
    [self.modalDelegate didDismissModalPresentViewController];
}

- (IBAction)printButtonPressed:(id)sender {
    self.printButton.enabled = NO;
    self.compositeErrorResult = [[[CompositeErrorResult alloc] init] autorelease];
    self.compositeErrorResult.successFlag = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performReceiptPrintingTask];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.compositeErrorResult.successFlag) {
                [ArcosUtils showDialogBox:self.compositeErrorResult.errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
            } else {
                [ArcosUtils showDialogBox:@"Document Printed" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
            }
            self.printButton.enabled = YES;
        });
    });
}

- (IBAction)emailButtonPressed:(id)sender {
    self.orderDetailOrderEmailActionDataManager.signatureImage = [UIImage imageWithCGImage:[self.drawingAreaView getImage]];
    NSMutableDictionary* mailDict = [self.orderDetailOrderEmailActionDataManager didSelectEmailRecipientRowWithCellData:nil taskData:nil];
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:[ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]], nil];
    NSArray* auxCcRecipients = [self.orderDetailOrderEmailActionDataManager retrieveCcRecipients];
    NSMutableArray* ccRecipients = [NSMutableArray arrayWithArray:auxCcRecipients];
    NSString* fileName = [self.orderDetailOrderEmailActionDataManager retrieveFileName];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.ccRecipients = ccRecipients;
        amwvc.subjectText = [mailDict objectForKey:@"Subject"];
        amwvc.bodyText = [mailDict objectForKey:@"Body"];
        amwvc.isHTML = YES;
        if (![fileName isEqualToString:@""]) {
            NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
            NSData* data = [NSData dataWithContentsOfFile:pdfFilePath];
            [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];            
            [FileCommon removeFileAtPath:pdfFilePath];
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self presentViewController:self.globalNavigationController animated:YES completion:^{
            
        }];
        [amwvc release];
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
        
    [mailComposeViewController setToRecipients:toRecipients];
    
    [mailComposeViewController setCcRecipients:ccRecipients];
    [mailComposeViewController setSubject:[mailDict objectForKey:@"Subject"]];
    [mailComposeViewController setMessageBody:[mailDict objectForKey:@"Body"] isHTML:YES];
    
    if (![fileName isEqualToString:@""]) {
        NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
        NSData* data = [NSData dataWithContentsOfFile:pdfFilePath];
        [mailComposeViewController addAttachmentData:data mimeType:@"application/pdf" fileName:fileName];
        [FileCommon removeFileAtPath:pdfFilePath];
    }
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
    [mailComposeViewController release];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [self dismissViewControllerAnimated:YES completion:^{
        self.globalNavigationController = nil;
    }];
}

- (IBAction)bothButtonPressed:(id)sender {
    self.bothButton.enabled = NO;
    self.compositeErrorResult = [[[CompositeErrorResult alloc] init] autorelease];
    self.compositeErrorResult.successFlag = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performReceiptPrintingTask];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.compositeErrorResult.successFlag) {
                [ArcosUtils showDialogBox:self.compositeErrorResult.errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
            } else {
                [ArcosUtils showDialogBox:@"Document Printed" title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
                    [self emailButtonPressed:nil];
                }];
            }
            self.bothButton.enabled = YES;
        });
    });
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self emailButtonPressed:nil];
}

- (void)performReceiptPrintingTask {
    EAAccessoryManager* manager = [EAAccessoryManager sharedAccessoryManager];
    NSArray<EAAccessory*>* connectedAccessories = manager.connectedAccessories;
    NSNumber* myNumber = [NSNumber numberWithUnsignedInteger:connectedAccessories.count];
    if ([myNumber intValue] <= 0) {
        self.compositeErrorResult.successFlag = NO;
        self.compositeErrorResult.errorMsg = @"No device found";
        return;
    }
//    NSLog(@"device: %@ %@", accessory.name, accessory.serialNumber);
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    id<ZebraPrinterConnection, NSObject> connection = nil;
    BOOL didOpen = NO;
    for (int i = 0; i < [myNumber intValue]; i++) {
        EAAccessory* accessory = [connectedAccessories objectAtIndex:i];
        connection = [[[MfiBtPrinterConnection alloc] initWithSerialNumber:accessory.serialNumber] autorelease];
        didOpen = [connection open];
        if (didOpen) {
            break;
        }
    }
    
    if(didOpen == YES) {
        NSError* error = nil;
        id<ZebraPrinter,NSObject> printer = [ZebraPrinterFactory getInstance:connection error:&error];
        
        if(printer != nil) {
            PrinterStatus* printerStatus = [printer getCurrentStatus:&error];
            if (printerStatus.isReadyToPrint) {
                PrinterLanguage language = [printer getPrinterControlLanguage];
                if (language == PRINTER_LANGUAGE_CPCL) {
                    self.compositeErrorResult.successFlag = NO;
                    self.compositeErrorResult.errorMsg = @"Could not work for CPCL printers";
                } else {
                    [self printLogoImage:printer];
                    [self printOrderNumber:printer];
                    [self printCustomerName:printer];
                    [self printContactName:printer];
                    [self printReceiptBody:printer];
                    [self printSignatureImage:printer];
                    [self printCustRef:printer];
                }
            } else if (printerStatus.isPaused) {
                self.compositeErrorResult.successFlag = NO;
                self.compositeErrorResult.errorMsg = @"Cannot Print because the printer is paused.";
            } else if (printerStatus.isHeadOpen) {
                self.compositeErrorResult.successFlag = NO;
                self.compositeErrorResult.errorMsg = @"Cannot Print because the printer head is open.";
            } else if (printerStatus.isPaperOut) {
                self.compositeErrorResult.successFlag = NO;
                self.compositeErrorResult.errorMsg = @"Cannot Print because the paper is out.";
            } else {
                self.compositeErrorResult.successFlag = NO;
                self.compositeErrorResult.errorMsg = @"Cannot Print.";
            }
        } else {
            self.compositeErrorResult.successFlag = NO;
            self.compositeErrorResult.errorMsg = @"Could not detect language";
        }
    } else {
        self.compositeErrorResult.successFlag = NO;
        self.compositeErrorResult.errorMsg = @"Could not connect to printer";
    }
    [connection close];
    [pool release];
}

- (void)printLogoImage:(id<NSObject,ZebraPrinter>)printer {
    NSError* error = nil;
    NSString* codeString =
    @"^XA^POI^PW400^MNN^LL210LH0,0^XZ";
    id<GraphicsUtil, NSObject> graphicsUtil = [printer getGraphicsUtil];
    
    NSError* logoError = nil;
    [[printer getToolsUtil] sendCommand:codeString error:&error];
    CGImageRef logoImageRef = [self.logoImage CGImage];
    
    [graphicsUtil printImage:logoImageRef atX:50 atY:10 withWidth:300 withHeight:180 andIsInsideFormat:NO error:&logoError];
}

- (void)printOrderNumber:(id<NSObject,ZebraPrinter>)printer {
    NSNumber* auxOrderNumber = [self.orderHeader objectForKey:@"OrderNumber"];
    if (auxOrderNumber == nil) return;
    NSError* error = nil;
    NSString* orderNumberFormat = @"^XA^POI^PW800^MNN^LL40^LH0,0" \
    @"^FO0,5"\
    @"^FB790,1,0,R,0"\
    @"^A0N,32,25"\
    @"^FD%@^FS" \
    @"^XZ";
    NSString* orderNumberString = [NSString stringWithFormat:orderNumberFormat, auxOrderNumber];
    [[printer getToolsUtil] sendCommand:orderNumberString error:&error];
}

- (void)printCustomerName:(id<NSObject,ZebraPrinter>)printer {
    NSError* error = nil;
    NSString* customerNameFormat = @"^XA^POI^PW800^MNN^LL50^LH0,0" \
    @"^FO0,5"\
    @"^FB800,1,0,L,0"\
    @"^A0N,25,25"\
    @"^FD%@^FS" \
    @"^XZ";
    NSString* customerNameString = [NSString stringWithFormat:customerNameFormat, self.locationNameLabel.text];
    [[printer getToolsUtil] sendCommand:customerNameString error:&error];
}

- (void)printContactName:(id<NSObject,ZebraPrinter>)printer {
    NSDictionary* tmpContactDict = [self.orderHeader objectForKey:@"contact"];
    if ([[tmpContactDict objectForKey:@"IUR"] intValue] == 0) return;    
    NSString* auxContactText = [ArcosUtils convertUnAssignedToBlank:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"contactText"]]];
    if ([auxContactText isEqualToString:@""]) return;
    NSError* error = nil;
    NSString* contactNameFormat = @"^XA^POI^PW800^MNN^LL40^LH0,0" \
    @"^FO0,5"\
    @"^FB800,1,0,L,0"\
    @"^A0N,25,25"\
    @"^FD%@^FS" \
    @"^XZ";
    NSString* contactNameString = [NSString stringWithFormat:contactNameFormat, auxContactText];
    [[printer getToolsUtil] sendCommand:contactNameString error:&error];
}

- (void)printOrderLineHeader:(id<NSObject,ZebraPrinter>)printer {
    NSError* error = nil;
    NSString* finalOrderLineHeaderFormat = @"";
    NSString* orderLineHeaderString = @"";
    NSString* orderLineHeaderBeginFormat =
    @"^XA^POI^PW800^MNN^LL40^LH0,0" \
    @"^FO0,5"\
    @"^FB45,1,0,L,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS"\
    
    @"^FO50,5"\
    @"^FB530,1,0,L,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS"\
    
    @"^FO585,5"\
    @"^FB65,1,0,L,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS" \
    @"^FO650,5"\
    @"^FB65,1,0,L,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS";
//    \
    
//    @"^FO715,5"\
//    @"^FB75,1,0,R,0"\
//    @"^A0N,20,20"\
//    @"^FD%@^FS" \
//
//    @"^XZ";
    NSString* orderLineHeaderValueFormat =
    @"^FO715,5"\
    @"^FB75,1,0,R,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS";

    NSString* orderLineHeaderEndFormat = @"^XZ";
    if (self.includePriceSwitch.isOn) {
        finalOrderLineHeaderFormat = [NSString stringWithFormat:@"%@%@%@",orderLineHeaderBeginFormat,orderLineHeaderValueFormat,orderLineHeaderEndFormat];
        orderLineHeaderString = [NSString stringWithFormat:finalOrderLineHeaderFormat, @"VC", @"Description", @"Qty", @"Bon", @"Value"];
    } else {
        finalOrderLineHeaderFormat = [NSString stringWithFormat:@"%@%@",orderLineHeaderBeginFormat,orderLineHeaderEndFormat];
        orderLineHeaderString = [NSString stringWithFormat:finalOrderLineHeaderFormat, @"VC", @"Description", @"Qty", @"Bon"];
    }
//    NSString* orderLineHeaderString = [NSString stringWithFormat:orderLineHeaderFormat, @"VC", @"Description", @"Qty", @"Bon", @"Value"];
    [[printer getToolsUtil] sendCommand:orderLineHeaderString error:&error];
}

- (void)printOrderLineFooter:(id<NSObject,ZebraPrinter>)printer totalQty:(int)aTotalQty totalBonus:(int)aTotalBonus totalGoods:(float)aTotalGoods {
    NSError* error = nil;
    NSString* horizontalLine = @"^XA^POI^PW800^MNN^LL20^LH0,0" \
    @"^FO0,5"\
    @"^GB800,0,1^FS"\
    @"^XZ";
    [[printer getToolsUtil] sendCommand:horizontalLine error:&error];
    NSString* finalOrderLineFooterFormat = @"";
    NSString* orderLineFooterString = @"";
    NSString* orderLineFooterBeginFormat =
    @"^XA^POI^PW800^MNN^LL40^LH0,0" \
    @"^FO585,5"\
    @"^FB45,1,0,R,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS" \
    @"^FO650,5"\
    @"^FB45,1,0,R,0"\
    @"^A0N,20,20"\
    @"^FD%@^FS";
//    \
//    @"^FO715,5"\
//    @"^FB75,1,0,R,0"\
//    @"^A0N,20,20"\
//    @"^FD%.2f^FS" \
//    @"^XZ";
    NSString* orderLineTotalGoodsFormat =
    @"^FO715,5"\
    @"^FB75,1,0,R,0"\
    @"^A0N,20,20"\
    @"^FD%.2f^FS";
    NSString* orderLineFooterEndFormat = @"^XZ";
    if (self.includePriceSwitch.isOn) {
        finalOrderLineFooterFormat = [NSString stringWithFormat:@"%@%@%@",orderLineFooterBeginFormat, orderLineTotalGoodsFormat, orderLineFooterEndFormat];
        orderLineFooterString = [NSString stringWithFormat:finalOrderLineFooterFormat, [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", aTotalQty]], [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", aTotalBonus]], aTotalGoods];
        [[printer getToolsUtil] sendCommand:orderLineFooterString error:&error];
        float totalDueValue = aTotalGoods;
        for (int i = 0; i < [self.descrDetailDictList count]; i++) {
            NSDictionary* auxDescrDetailDict = [self.descrDetailDictList objectAtIndex:i];
            NSNumber* descrDetailIUR = [auxDescrDetailDict objectForKey:@"DescrDetailIUR"];
            NSNumber* sumLineValue = [self.descrDetailIurLineValueHashMap objectForKey:descrDetailIUR];
            float vatValue = [sumLineValue floatValue] / 100.0 * [[auxDescrDetailDict objectForKey:@"Dec1"] floatValue];
            totalDueValue += vatValue;
            NSString* vatValueLineFormat =
            @"^XA^POI^PW800^MNN^LL40^LH0,0" \
            @"^FO0,5"\
            @"^FB695,1,0,R,0"\
            @"^A0N,20,20"\
            @"^FD%@^FS" \
            @"^FO715,5"\
            @"^FB75,1,0,R,0"\
            @"^A0N,20,20"\
            @"^FD%.2f^FS" \
            @"^XZ";
            NSString* vatValueDesc = [NSString stringWithFormat:@"%@ - %@", [ArcosUtils convertNilToEmpty:[auxDescrDetailDict objectForKey:@"DescrDetailCode"]], [ArcosUtils convertNilToEmpty:[auxDescrDetailDict objectForKey:@"Detail"]]];
            NSString* vatValueLineString = [NSString stringWithFormat:vatValueLineFormat, vatValueDesc, vatValue];
            [[printer getToolsUtil] sendCommand:vatValueLineString error:&error];
        }
        NSString* totalDueLineFormat =
        @"^XA^POI^PW800^MNN^LL40^LH0,0" \
        @"^FO0,5"\
        @"^FB695,1,0,R,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS" \
        @"^FO715,5"\
        @"^FB75,1,0,R,0"\
        @"^A0N,20,20"\
        @"^FD%.2f^FS" \
        @"^XZ";
        NSString* totalDueLineString = [NSString stringWithFormat:totalDueLineFormat, @"Total Due", totalDueValue];
        [[printer getToolsUtil] sendCommand:totalDueLineString error:&error];
    } else {
        finalOrderLineFooterFormat = [NSString stringWithFormat:@"%@%@",orderLineFooterBeginFormat, orderLineFooterEndFormat];
        orderLineFooterString = [NSString stringWithFormat:finalOrderLineFooterFormat, [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", aTotalQty]], [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", aTotalBonus]]];
        [[printer getToolsUtil] sendCommand:orderLineFooterString error:&error];
    }
//    NSString* orderLineFooterString = [NSString stringWithFormat:orderLineFooterFormat, [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", aTotalQty]], [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", aTotalBonus]], aTotalGoods];
    
}

- (void)printCustRef:(id<NSObject,ZebraPrinter>)printer {
    NSString* auxCustRef = [ArcosUtils convertUnAssignedToBlank:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"custRef"]]];
    if ([auxCustRef isEqualToString:@""]) return;
    NSError* error = nil;
    NSString* custRefFormat = @"^XA^POI^PW800^MNN^LL90^LH0,0" \
    @"^FO0,5"\
    @"^FB800,1,0,L,0"\
    @"^A0N,25,25"\
    @"^FDYOUR REF:%@^FS" \
    @"^XZ";
    NSString* custRefString = [NSString stringWithFormat:custRefFormat, auxCustRef];
    [[printer getToolsUtil] sendCommand:custRefString error:&error];
}

- (void)printReceiptBody:(id<NSObject,ZebraPrinter>)printer {
    NSError* error = nil;
    NSString *header = [NSString stringWithFormat:
                        @"^XA^POI^PW800^MNN^LL160^LH0,0" \
                        
                        @"^FO0,5" \
                        @"^FB520,1,0,L,0"\
                        @"^A0N,25,25" \
                        @"^FD%@^FS" \
                        
                        @"^FO570,5" \
                        @"^FB80,1,0,R,0"\
                        @"^A0N,25,25" \
                        @"^FDDate:^FS" \
                        
                        @"^FO650,5" \
                        @"^FB140,1,0,R,0"\
                        @"^A0N,25,25" \
                        @"^FD%@^FS" \
                        
                        @"^FO0,45" \
                        @"^FB800,1,0,L,0"\
                        @"^A0N,25,25" \
                        @"^FD%@^FS" \
                        
                        @"^FO0,85" \
                        @"^FB800,1,0,L,0"\
                        @"^A0N,25,25" \
                        @"^FD%@^FS" \
                        
                        @"^FO0,125" \
                        @"^FB800,1,0,L,0"\
                        @"^A0N,25,25" \
                        @"^FD%@^FS^XZ", self.address1Label.text, [ArcosUtils stringFromDate:[self.orderHeader objectForKey:@"orderDate"] format:[GlobalSharedClass shared].dateFormat],
                         self.address2Label.text, self.address3Label.text
                        , self.address4Label.text];
    
    [[printer getToolsUtil] sendCommand:header error:&error];
    [self printOrderLineHeader:printer];
    int auxTotalQty = 0;
    int auxTotalBonus = 0;
    float auxTotalGoods = 0.0;
    self.descrDetailIurLineValueHashMap = [NSMutableDictionary dictionaryWithCapacity:[self.descrDetailDictHashMap count]];
    for (int i = 0; i < self.orderLines.count; i++) {
        NSMutableDictionary* orderLineDict = [self.orderLines objectAtIndex:i];
        NSString* orderPadDetailsSubString = @"";
        @try {
            NSString* orderPadDetails = [orderLineDict objectForKey:@"OrderPadDetails"];
            NSArray* orderPadDetailsList = [orderPadDetails componentsSeparatedByString:@"-"];
            if ([orderPadDetailsList count] > 0) {
                orderPadDetailsSubString = [ArcosUtils trim:[orderPadDetailsList objectAtIndex:0]];
            }
        } @catch (NSException *exception) {
            
        }
        NSNumber* vcIUR = [orderLineDict objectForKey:@"VCIUR"];
        NSDictionary* descrDetailDict = [self.descrDetailDictHashMap objectForKey:vcIUR];
        NSString* descrDetailCode = [ArcosUtils convertNilToEmpty:[descrDetailDict objectForKey:@"DescrDetailCode"]];
        NSString* details = [orderLineDict objectForKey:@"Details"];
        NSNumber* qty = [orderLineDict objectForKey:@"Qty"];
        NSString* qtyStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qty]];
        NSNumber* instock = [orderLineDict objectForKey:@"InStock"];
        NSString* instockStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:instock]];
        NSNumber* bonus = [orderLineDict objectForKey:@"Bonus"];
        NSString* bonusStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:bonus]];
        NSNumber* foc = [orderLineDict objectForKey:@"FOC"];
        NSString* focStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:foc]];
        float lineValue = [[orderLineDict objectForKey:@"LineValue"] floatValue];
        if ([self.descrDetailIurLineValueHashMap objectForKey:vcIUR] == nil) {
            [self.descrDetailIurLineValueHashMap setObject:[orderLineDict objectForKey:@"LineValue"] forKey:vcIUR];
        } else {
            float sumLineValue = [[orderLineDict objectForKey:@"LineValue"] floatValue] + [[self.descrDetailIurLineValueHashMap objectForKey:vcIUR] floatValue];
            [self.descrDetailIurLineValueHashMap setObject:[NSNumber numberWithFloat:sumLineValue] forKey:vcIUR];
        }
        auxTotalQty += [qty intValue];
        auxTotalBonus += [bonus intValue];
        auxTotalGoods += lineValue;
        NSString* lineItem = @"";
        NSString* lineItemWithVars = @"";
        NSString* lineBeginItem =
        @"^XA^POI^PW800^MNN^LL40^LH0,0" \
        @"^FO0,5"\
        @"^FB45,1,0,L,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS"\
        
        @"^FO50,5"\
        @"^FB530,1,0,L,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS"\
        @"^FO585,5"\
        @"^FB45,1,0,R,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS" \
        @"^FO630,10"\
        @"^FB20,1,0,L,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS" \
        @"^FO650,5"\
        @"^FB45,1,0,R,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS" \
        @"^FO695,10"\
        @"^FB20,1,0,L,0"\
        @"^A0N,20,20"\
        @"^FD%@^FS";
//        \
//        @"^FO715,5"\
//        @"^FB75,1,0,R,0"\
//        @"^A0N,20,20"\
//        @"^FD%.2f^FS" \
//
//        @"^XZ";
        NSString* lineValueFormat =
        @"^FO715,5"\
        @"^FB75,1,0,R,0"\
        @"^A0N,20,20"\
        @"^FD%.2f^FS";
        NSString* lineEndItem = @"^XZ";
        if (self.includePriceSwitch.isOn) {
            lineItem = [NSString stringWithFormat:@"%@%@%@", lineBeginItem, lineValueFormat, lineEndItem];
            lineItemWithVars = [NSString stringWithFormat:lineItem, descrDetailCode, [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@", orderPadDetailsSubString, details]], qtyStr, instockStr, bonusStr, focStr, lineValue];
        } else {
            lineItem = [NSString stringWithFormat:@"%@%@", lineBeginItem, lineEndItem];
            lineItemWithVars = [NSString stringWithFormat:lineItem, descrDetailCode, [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@", orderPadDetailsSubString, details]], qtyStr, instockStr, bonusStr, focStr];
        }
//        NSString* lineItemWithVars = [NSString stringWithFormat:lineItem, descrDetailCode, [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@", orderPadDetailsSubString, details]], qtyStr, instockStr, bonusStr, focStr, lineValue];
        [[printer getToolsUtil] sendCommand:lineItemWithVars error:&error];
    }
    [self printOrderLineFooter:printer totalQty:auxTotalQty totalBonus:auxTotalBonus totalGoods:auxTotalGoods];
}

- (void)printSignatureImage:(id<NSObject,ZebraPrinter>)printer {
    NSError* error = nil;
    NSString* codeString =
    @"^XA^POI^PW500^MNN^LL300LH0,0^XZ";
    id<GraphicsUtil, NSObject> graphicsUtil = [printer getGraphicsUtil];
    
    NSError* logoError = nil;
    [[printer getToolsUtil] sendCommand:codeString error:&error];
    CGImageRef signatureImage = [self.drawingAreaView getImage];
    
    [graphicsUtil printImage:signatureImage atX:50 atY:10 withWidth:400 withHeight:200 andIsInsideFormat:NO error:&logoError];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = nil;
    switch (result) {
        case MFMailComposeResultSent: {
            
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = [error localizedDescription];
            [ArcosUtils showDialogBox:message title:@"Error !" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            
        }
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
//        NSString* fileName = [self.orderDetailOrderEmailActionDataManager retrieveFileName];
//        if (![fileName isEqualToString:@""]) {
//            NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
//            [FileCommon removeFileAtPath:pdfFilePath];
//        }
    }];
}

- (NSMutableArray*)createData {    
    return [self.checkoutPrinterWrapperDataManager retrieveDataList:[self.orderHeader objectForKey:@"OrderNumber"]];
}



@end
