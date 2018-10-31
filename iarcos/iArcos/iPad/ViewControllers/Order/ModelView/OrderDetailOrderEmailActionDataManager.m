//
//  OrderDetailOrderEmailActionDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailOrderEmailActionDataManager.h"

@implementation OrderDetailOrderEmailActionDataManager
@synthesize orderHeader = _orderHeader;
@synthesize orderEmailProcessCenter = _orderEmailProcessCenter;
@synthesize showSignatureFlag = _showSignatureFlag;
@synthesize signatureImage = _signatureImage;
@synthesize checkoutPDFRenderer = _checkoutPDFRenderer;
@synthesize fileName = _fileName;
@synthesize logoImage = _logoImage;
@synthesize orderLineFont = _orderLineFont;
@synthesize headerFont = _headerFont;

- (id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader {
    self = [super init];
    if (self != nil) {
        self.orderHeader = anOrderHeader;
        self.orderEmailProcessCenter = [[[OrderEmailProcessCenter alloc] initWithOrderHeader:anOrderHeader] autorelease];
        self.showSignatureFlag = NO;
        self.checkoutPDFRenderer = [[[CheckoutPDFRenderer alloc] init] autorelease];
        NSString* ccDesc = @"";
        NSNumber* auxLocationIUR = [anOrderHeader objectForKey:@"LocationIUR"];
        NSArray* auxLocationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:auxLocationIUR];
        if ([auxLocationList count] > 0) {
            NSDictionary* auxLocationDict = [auxLocationList objectAtIndex:0];
            NSNumber* auxCCiur = [auxLocationDict objectForKey:@"CCiur"];
            NSDictionary* auxDescrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:auxCCiur];
            if (auxDescrDetailDict != nil) {
                ccDesc = [ArcosUtils convertNilToEmpty:[auxDescrDetailDict objectForKey:@"Detail"]];
            }
        }
        self.fileName = [NSString stringWithFormat:@"%@_%@_%@.pdf", [ArcosUtils removeSubstringFromString:ccDesc substring:@"/"], [ArcosUtils removeSubstringFromString:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"LocationCode"]] substring:@"/"], [self.orderHeader objectForKey:@"OrderNumber"]];
        
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternativeLogoFlag]) {
            self.logoImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:100]];            
        } else {
            self.logoImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:1]];
        }
        self.orderLineFont = [UIFont systemFontOfSize:7.0];
        self.headerFont = [UIFont systemFontOfSize:10.0];
    }
    return self;
}

- (void)dealloc {
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    if (self.orderEmailProcessCenter != nil) { self.orderEmailProcessCenter = nil; }
    self.signatureImage = nil;
    self.checkoutPDFRenderer = nil;
    self.fileName = nil;
    self.logoImage = nil;
    self.orderLineFont = nil;
    self.headerFont = nil;
    
    [super dealloc];
}

#pragma mark - OrderDetailEmailActionDelegate
- (NSMutableDictionary*)didSelectEmailRecipientRowWithCellData:(NSDictionary*)aCellData {
    NSMutableDictionary* mailDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [mailDict setObject:[NSString stringWithFormat:@"Order taken by %@", [self.orderHeader objectForKey:@"Employee"]] forKey:@"Subject"];
    [mailDict setObject:[self.orderEmailProcessCenter buildEmailMessageWithController] forKey:@"Body"];
    [self generatePdfFile];
    return mailDict;
}
- (NSString*)retrieveFileName {
    return self.fileName;
}

- (void)generatePdfFile {
    BOOL exclusiveValueFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] excludeValueFromOrderEmailFlag];
    NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:self.fileName];
    UIGraphicsBeginPDFContextToFile(pdfFilePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.checkoutPDFRenderer.pageWidth, self.checkoutPDFRenderer.pageHeight), nil);
    CGRect logoRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:30];
    [self.checkoutPDFRenderer drawImage:self.logoImage inRect:logoRect];
    [self.checkoutPDFRenderer drawText:[self.orderHeader objectForKey:@"CustName"] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:1]];
    [self.checkoutPDFRenderer drawText:@"Order Date:" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:2] alignment:NSTextAlignmentLeft];
    NSString* auxOrderDate = [self.orderHeader objectForKey:@"orderDateText"];
    [self.checkoutPDFRenderer drawText:auxOrderDate inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:3]];
    [self.checkoutPDFRenderer drawText:[self.orderHeader objectForKey:@"Address1"] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:4]];
    NSString* orderNumberTitle = @"Order Number";
    NSNumber* orderHeaderIUR = [self.orderHeader objectForKey:@"OrderHeaderIUR"];
    if (orderHeaderIUR != nil && [orderHeaderIUR intValue] == 0) {
        orderNumberTitle = @"Docket No.";
    }
    [self.checkoutPDFRenderer drawText:[NSString stringWithFormat:@"%@:", orderNumberTitle] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:5] alignment:NSTextAlignmentLeft];
    NSNumber* docketIUR = [self.orderHeader objectForKey:@"DocketIUR"];
    NSNumber* theOrderNumber = [self.orderHeader objectForKey:@"OrderNumber"];
    if ([docketIUR intValue] > 0) {
        [self.checkoutPDFRenderer drawText:[docketIUR stringValue] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:6]];
    }else {
        [self.checkoutPDFRenderer drawText:[theOrderNumber stringValue] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:6]];
    }
    
    [self.checkoutPDFRenderer drawText:[self.orderHeader objectForKey:@"Address2"] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:7]];
    [self.checkoutPDFRenderer drawText:@"Reference:" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:8] alignment:NSTextAlignmentLeft];
    [self.checkoutPDFRenderer drawText:[self.orderHeader objectForKey:@"custRef"] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:9]];
    
    [self.checkoutPDFRenderer drawText:[self.orderHeader objectForKey:@"Address3"] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:10]];
    [self.checkoutPDFRenderer drawText:@"Location Code:" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:11] alignment:NSTextAlignmentLeft];
    [self.checkoutPDFRenderer drawText:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"LocationCode"]] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:12]];
    
    [self.checkoutPDFRenderer drawText:[self.orderHeader objectForKey:@"Address4"] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:13]];
    [self.checkoutPDFRenderer drawText:@"Contact:" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:31] alignment:NSTextAlignmentLeft];
    [self.checkoutPDFRenderer drawText:[ArcosUtils convertUnAssignedToBlank:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"contactText"]]] inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:32]];
    
    CGRect headerTopLineRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:14];
    
    
    CGRect headerRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:15];
    CGPoint headerTopLineFromPoint = CGPointMake(headerRect.origin.x, headerRect.origin.y - headerRect.size.height - 5);
    CGPoint headerTopLineToPoint = CGPointMake(headerRect.origin.x + headerTopLineRect.size.width, headerRect.origin.y - headerRect.size.height - 5);
    [self.checkoutPDFRenderer drawLineFromPoint:headerTopLineFromPoint toPoint:headerTopLineToPoint];
    [self.checkoutPDFRenderer drawText:@"Qty" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:15] alignment:NSTextAlignmentLeft font:self.headerFont];
    [self.checkoutPDFRenderer drawText:@"Bon" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:16] alignment:NSTextAlignmentLeft font:self.headerFont];
    [self.checkoutPDFRenderer drawText:@"Code" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:35] alignment:NSTextAlignmentLeft font:self.headerFont];
    [self.checkoutPDFRenderer drawText:@"Disc%" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:17] alignment:NSTextAlignmentLeft font:self.headerFont];
    [self.checkoutPDFRenderer drawText:@"Details" inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:18] alignment:NSTextAlignmentLeft font:self.headerFont];
    NSString* valueTitleStr = @"EAN";
    if (!exclusiveValueFlag) {
        valueTitleStr = @"Value";
        [self.checkoutPDFRenderer drawText:valueTitleStr inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:19] alignment:NSTextAlignmentCenter font:self.headerFont];
    } else {        
        [self.checkoutPDFRenderer drawText:valueTitleStr inRect:[self.checkoutPDFRenderer retrieveViewRectWithTag:19] alignment:NSTextAlignmentCenter font:self.headerFont];
    }
    
    CGPoint headerBottomLineFromPoint = CGPointMake(headerRect.origin.x, headerRect.origin.y + 0);
    CGPoint headerBottomLineToPoint = CGPointMake(headerRect.origin.x + headerTopLineRect.size.width, headerRect.origin.y + 0);
    [self.checkoutPDFRenderer drawLineFromPoint:headerBottomLineFromPoint toPoint:headerBottomLineToPoint];
    
    int pageNum = 0;
    int length = [ArcosUtils convertNSUIntegerToUnsignedInt:self.orderEmailProcessCenter.orderLines.count];
    int totalQty = 0;
    int totalBonus = 0;
    for (int i = 0; i < length; i++) {
        NSMutableDictionary* orderLineDict = [self.orderEmailProcessCenter.orderLines objectAtIndex:i];
        NSString* details = [orderLineDict objectForKey:@"Description"];
        NSNumber* qty = [orderLineDict objectForKey:@"Qty"];
        totalQty += [qty intValue];
        NSString* qtyStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qty]];
        NSNumber* inStock = [orderLineDict objectForKey:@"InStock"];
        NSString* inStockStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:inStock]];
        if (![inStockStr isEqualToString:@""]) {
            qtyStr = [NSString stringWithFormat:@"%@/%@", qtyStr, inStockStr];
        }
        NSNumber* bonus = [orderLineDict objectForKey:@"Bonus"];
        totalBonus += [bonus intValue];
        NSString* bonusStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:bonus]];
        NSNumber* foc = [orderLineDict objectForKey:@"FOC"];
        NSString* focStr = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:foc]];
        if (![focStr isEqualToString:@""]) {
            bonusStr = [NSString stringWithFormat:@"%@/%@", bonusStr, focStr];
        }
        NSNumber* discount = [orderLineDict objectForKey:@"DiscountPercent"];
        NSString* discountStr = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@",discount]];
        NSString* lineValueStr = [NSString stringWithFormat:@"%1.2f",[[orderLineDict objectForKey:@"LineValue"] floatValue]];
        
        CGRect qtyRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:21];
        CGRect bonusRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:22];
        CGRect codeRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:36];
        CGRect discRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:23];
        CGRect detailRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:24];
        CGRect valueRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:25];
        CGRect newQtyRect = [self.checkoutPDFRenderer retrieveNewViewRect:qtyRect index:i verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
        CGRect newBonusRect = [self.checkoutPDFRenderer retrieveNewViewRect:bonusRect index:i verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
        CGRect newCodeRect = [self.checkoutPDFRenderer retrieveNewViewRect:codeRect index:i verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
        CGRect newDiscRect = [self.checkoutPDFRenderer retrieveNewViewRect:discRect index:i verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
        CGRect newDetailRect = [self.checkoutPDFRenderer retrieveNewViewRect:detailRect index:i verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
        CGRect newValueRect = [self.checkoutPDFRenderer retrieveNewViewRect:valueRect index:i verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
        float yAxis = qtyRect.origin.y + (i * qtyRect.size.height) + i * self.checkoutPDFRenderer.rowVerticalSpace;
        int auxPageNum = (int)(yAxis / self.checkoutPDFRenderer.pageHeight);
        BOOL flag = NO;
        if (pageNum != auxPageNum) {
            pageNum = auxPageNum;
            flag = YES;
        } else {
            
        }
        [self.checkoutPDFRenderer drawText:qtyStr inRect:newQtyRect alignment:NSTextAlignmentLeft font:self.orderLineFont];
        [self.checkoutPDFRenderer drawText:bonusStr inRect:newBonusRect alignment:NSTextAlignmentLeft font:self.orderLineFont];
        [self.checkoutPDFRenderer drawText:[orderLineDict objectForKey:@"ProductCode"] inRect:newCodeRect alignment:NSTextAlignmentLeft font:self.orderLineFont];
        [self.checkoutPDFRenderer drawText:discountStr inRect:newDiscRect alignment:NSTextAlignmentLeft font:self.orderLineFont];
        [self.checkoutPDFRenderer drawText:[NSString stringWithFormat:@"%@ %@", details, [orderLineDict objectForKey:@"ProductSize"]] inRect:newDetailRect alignment:NSTextAlignmentLeft font:self.orderLineFont];
        if (!exclusiveValueFlag) {
            [self.checkoutPDFRenderer drawText:lineValueStr inRect:newValueRect alignment:NSTextAlignmentRight font:self.orderLineFont];
        } else {            
            [self.checkoutPDFRenderer drawText:[NSString stringWithFormat:@"%@", [orderLineDict objectForKey:@"EAN"]] inRect:newValueRect alignment:NSTextAlignmentRight font:self.orderLineFont];
        }
        
        if (flag) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.checkoutPDFRenderer.pageWidth, self.checkoutPDFRenderer.pageHeight), nil);
        }
    }
    CGRect qtyRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:21];
    CGRect lastQtyRect = [self.checkoutPDFRenderer retrieveNewViewRect:qtyRect index:length - 1 verticalSpace:self.checkoutPDFRenderer.rowVerticalSpace pageNum:pageNum];
    CGPoint orderLineBottomLineFromPoint = CGPointMake(lastQtyRect.origin.x, lastQtyRect.origin.y + 1);
    CGPoint orderLineBottomLineToPoint = CGPointMake(lastQtyRect.origin.x + headerTopLineRect.size.width, lastQtyRect.origin.y + 1);
    [self.checkoutPDFRenderer drawLineFromPoint:orderLineBottomLineFromPoint toPoint:orderLineBottomLineToPoint];
    CGRect totalQtyTemplateRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:33];
    CGRect totalBonusTemplateRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:34];
    CGRect deliveryByTemplateRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:27];
    CGRect totalTemplateRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:28];
    float deliveryByHeightDiff = deliveryByTemplateRect.origin.y - qtyRect.origin.y;
    CGRect totalQtyRect = CGRectMake(totalQtyTemplateRect.origin.x, lastQtyRect.origin.y + deliveryByHeightDiff, totalQtyTemplateRect.size.width, totalQtyTemplateRect.size.height);
    CGRect totalBonusRect = CGRectMake(totalBonusTemplateRect.origin.x, lastQtyRect.origin.y + deliveryByHeightDiff, totalBonusTemplateRect.size.width, totalBonusTemplateRect.size.height);
    CGRect deliveryByRect = CGRectMake(deliveryByTemplateRect.origin.x, lastQtyRect.origin.y + deliveryByHeightDiff, deliveryByTemplateRect.size.width, deliveryByTemplateRect.size.height);
    CGRect totalByRect = CGRectMake(totalTemplateRect.origin.x, lastQtyRect.origin.y + deliveryByHeightDiff, totalTemplateRect.size.width, totalTemplateRect.size.height);
    //    float yAxis = qtyRect.origin.y + ((length - 1) * qtyRect.size.height) + (length - 1) * self.checkoutPDFRenderer.rowVerticalSpace;
    //    int resYAxis = ((int)(yAxis)) % self.checkoutPDFRenderer.pageHeight;
    if (lastQtyRect.origin.y + deliveryByHeightDiff + deliveryByTemplateRect.size.height > self.checkoutPDFRenderer.pageHeight) {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.checkoutPDFRenderer.pageWidth, self.checkoutPDFRenderer.pageHeight), nil);
        totalQtyRect = CGRectMake(totalQtyTemplateRect.origin.x, deliveryByHeightDiff, totalQtyTemplateRect.size.width, totalQtyTemplateRect.size.height);
        totalBonusRect = CGRectMake(totalBonusTemplateRect.origin.x, deliveryByHeightDiff, totalBonusTemplateRect.size.width, totalBonusTemplateRect.size.height);
        deliveryByRect = CGRectMake(deliveryByRect.origin.x, deliveryByHeightDiff, deliveryByRect.size.width, deliveryByRect.size.height);
        totalByRect = CGRectMake(totalTemplateRect.origin.x, deliveryByHeightDiff, totalTemplateRect.size.width, totalTemplateRect.size.height);
    }
    [self.checkoutPDFRenderer drawText:[ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalQty]] inRect:totalQtyRect alignment:NSTextAlignmentLeft font:self.headerFont];
    [self.checkoutPDFRenderer drawText:[ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalBonus]] inRect:totalBonusRect alignment:NSTextAlignmentLeft font:self.headerFont];
    NSDictionary* wholesalerDict = [self.orderHeader objectForKey:@"wholesaler"];    
    //[self.orderHeader objectForKey:@"wholesalerText"]
    [self.checkoutPDFRenderer drawText:[NSString stringWithFormat:@"Delivery by:%@", [ArcosUtils convertNilToEmpty:[wholesalerDict objectForKey:@"Address4"]]] inRect:deliveryByRect alignment:NSTextAlignmentLeft font:self.headerFont];
    if (!exclusiveValueFlag) {
        [self.checkoutPDFRenderer drawText:[NSString stringWithFormat:@"Total:%@", [self.orderHeader objectForKey:@"totalGoodsText"]] inRect:totalByRect alignment:NSTextAlignmentRight font:self.headerFont];
    }
    
    
    //    CGRect productRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:9];
    //    float yAxis = productRect.origin.y + ((length - 1) * productRect.size.height) + (length - 1) * self.checkoutPDFRenderer.rowVerticalSpace;
    //    int resYAxis = ((int)(yAxis)) % self.checkoutPDFRenderer.pageHeight;
    
    if (self.showSignatureFlag) {
        CGRect signatureTemplateRect = [self.checkoutPDFRenderer retrieveViewRectWithTag:29];
        float sigHeightDiff = signatureTemplateRect.origin.y - deliveryByTemplateRect.origin.y;
        
        CGRect auxSignatureRect = CGRectMake(signatureTemplateRect.origin.x, deliveryByRect.origin.y + sigHeightDiff, signatureTemplateRect.size.width, signatureTemplateRect.size.height);
        
        if (deliveryByRect.origin.y + sigHeightDiff + signatureTemplateRect.size.height > self.checkoutPDFRenderer.pageHeight) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.checkoutPDFRenderer.pageWidth, self.checkoutPDFRenderer.pageHeight), nil);
            auxSignatureRect = CGRectMake(signatureTemplateRect.origin.x, sigHeightDiff, signatureTemplateRect.size.width, signatureTemplateRect.size.height);
        }
        [self.checkoutPDFRenderer drawImage:self.signatureImage inRect:auxSignatureRect];
    }
    
    UIGraphicsEndPDFContext();
}

- (NSArray*)retrieveCcRecipients {
    NSDictionary* auxContactDict = [self.orderHeader objectForKey:@"contact"];
    NSNumber* auxContactIUR = [auxContactDict objectForKey:@"IUR"];
    NSString* contactEmail = @"";
    NSString* locationEmail = @"";
    if ([auxContactIUR intValue] != 0) {
        NSMutableArray* auxContactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:auxContactIUR];
        if ([auxContactList count] > 0) {
            NSDictionary* tmpContactDict = [auxContactList objectAtIndex:0];
            contactEmail = [ArcosUtils convertNilToEmpty:[tmpContactDict objectForKey:@"Email"]];
        }
    }
    if (![contactEmail isEqualToString:@""]) return [NSArray arrayWithObject:contactEmail];
    NSNumber* auxLocationIUR = [self.orderHeader objectForKey:@"LocationIUR"];
    NSMutableArray* auxLocationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:auxLocationIUR];
    if ([auxLocationList count] > 0) {
        NSDictionary* tmpLocationDict = [auxLocationList objectAtIndex:0];
        locationEmail = [ArcosUtils convertNilToEmpty:[tmpLocationDict objectForKey:@"Email"]];
    }
    if (![locationEmail isEqualToString:@""]) return [NSArray arrayWithObject:locationEmail];
    return [NSArray arrayWithObject:@""];
}

/*
- (void)didSelectEmailRecipientRow:(MFMailComposeViewController*)aMailController cellData:(NSDictionary*)aCellData {
    [aMailController setToRecipients:[NSArray arrayWithObjects:[aCellData objectForKey:@"Email"] , nil]];
    [aMailController setSubject:[NSString stringWithFormat:@"%@ Order taken by %@", [self.orderEmailProcessCenter companyName], [self.orderEmailProcessCenter employeeName]]];    
    [self.orderEmailProcessCenter buildEmailMessageWithController];
}
- (void)emailButtonPressed:(MFMailComposeViewController*)aMailController {
    NSLog(@"OrderDetailOrderEmailActionDataManager");
    NSNumber *locationIUR = [self.orderHeader objectForKey:@"LocationIUR"];
    
    NSMutableDictionary* locationDict = [[[ArcosCoreData sharedArcosCoreData]locationWithIUR:locationIUR]objectAtIndex:0];
    NSString* locationEmail = [locationDict objectForKey:@"Email"];
    if (locationEmail != nil) {
        [aMailController setToRecipients:[NSArray arrayWithObjects:locationEmail, nil]]; 
    }
	
    [aMailController setSubject:[NSString stringWithFormat:@"%@ Order, given to %@ on %@"
                                     , [self.orderEmailProcessCenter companyName], [self.orderEmailProcessCenter employeeName], [self.orderHeader objectForKey:@"orderDateText"]]];
    
    [self.orderEmailProcessCenter buildEmailMessageWithController:aMailController];
}

- (void)wholesalerEmailButtonPressed:(MFMailComposeViewController*)aMailController {
    NSMutableDictionary* wholesalerDict = [self.orderHeader objectForKey:@"wholesaler"];
    
    NSString* wholesaleEmail = [wholesalerDict objectForKey:@"Email"];
    if (wholesaleEmail != nil) {
        [aMailController setToRecipients:[NSArray arrayWithObjects:wholesaleEmail, nil]]; 
    }
	
    [aMailController setSubject:[NSString stringWithFormat:@"Please process the following %@ order, from %@", [self.orderEmailProcessCenter companyName], [self.orderEmailProcessCenter employeeName]]];
    [self.orderEmailProcessCenter buildEmailMessageWithController:aMailController];
}

- (void)contactEmailButtonPressed:(MFMailComposeViewController*)aMailController {
    if ([self.orderHeader objectForKey:@"contactText"] != @"None") {
        NSMutableDictionary* contactDict = [self.orderHeader objectForKey:@"contact"];
        NSString* contactEmail = [contactDict objectForKey:@"Email"];               
        if (contactEmail != nil) {
            NSArray *toRecipients = [NSArray arrayWithObjects:contactEmail, nil];
            [aMailController setToRecipients:toRecipients]; 
        }
        
    }    
    [aMailController setSubject:[NSString stringWithFormat:@"Copy of Order given to %@ on %@"
                                     , [self.orderEmailProcessCenter employeeName], [self.orderHeader objectForKey:@"orderDateText"]]];
    
    [self.orderEmailProcessCenter buildEmailMessageWithController:aMailController];
}
*/

@end
