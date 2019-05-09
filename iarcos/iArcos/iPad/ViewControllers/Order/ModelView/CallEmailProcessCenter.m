//
//  CallEmailProcessCenter.m
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CallEmailProcessCenter.h"

@implementation CallEmailProcessCenter
@synthesize orderHeader = _orderHeader;
//@synthesize detailingSelectionNames = _detailingSelectionNames;
//@synthesize detailingSelections = _detailingSelections;
@synthesize hasDetailing = _hasDetailing;
@synthesize hasKeyMessages = _hasKeyMessages;
@synthesize hasSamples = _hasSamples;
@synthesize hasPromotionalItems = _hasPromotionalItems;
@synthesize hasPresenter = _hasPresenter;
@synthesize hasMeetingContact = _hasMeetingContact;
@synthesize adoptionLadderKey = _adoptionLadderKey;
@synthesize keyMessagesKey = _keyMessagesKey;
@synthesize samplesKey = _samplesKey;
@synthesize promotionalItemsKey = _promotionalItemsKey;
@synthesize presenterKey = _presenterKey;
@synthesize meetingContactKey = _meetingContactKey;
@synthesize detailingHeaderDict = _detailingHeaderDict;
@synthesize detailingActiveKeyList = _detailingActiveKeyList;
@synthesize detailingRowDict = _detailingRowDict;
//@synthesize arcosConfigDataManager = _arcosConfigDataManager;

-(id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader{
    self = [super init];
    if (self != nil) {
        self.detailingHeaderDict = [NSMutableDictionary dictionaryWithCapacity:4];
        self.detailingActiveKeyList = [NSMutableArray arrayWithCapacity:4];
        self.detailingRowDict = [NSMutableDictionary dictionaryWithCapacity:4];
        self.adoptionLadderKey = @"DT";
        self.keyMessagesKey = @"KM";
        self.samplesKey = @"SM";
        self.promotionalItemsKey = @"RG";
        self.presenterKey = @"PS";
        self.meetingContactKey = @"MC";
        NSString* adoptionLadderValue = @"Adoption Ladder";
        NSDictionary* adoptionLadderDict = [[ArcosCoreData sharedArcosCoreData]descrTypeAllRecordsWithTypeCode:@"DD"];
        if (adoptionLadderDict != nil) {
            adoptionLadderValue = [ArcosUtils convertNilToEmpty:[adoptionLadderDict objectForKey:@"Details"]];
        }
        [self.detailingHeaderDict setObject:adoptionLadderValue forKey:self.adoptionLadderKey];
        NSString* keyMessagesValue = @"Key Messages";
        NSDictionary* keyMessagesDict = [[ArcosCoreData sharedArcosCoreData]descrTypeAllRecordsWithTypeCode:@"KM"];
        if (keyMessagesDict != nil) {
            keyMessagesValue = [ArcosUtils convertNilToEmpty:[keyMessagesDict objectForKey:@"Details"]];
        }
        [self.detailingHeaderDict setObject:keyMessagesValue forKey:self.keyMessagesKey];
        [self.detailingHeaderDict setObject:@"Samples" forKey:self.samplesKey];
        [self.detailingHeaderDict setObject:@"Promotional Items" forKey:self.promotionalItemsKey];
        [self.detailingHeaderDict setObject:@"Presenter" forKey:self.presenterKey];
        [self.detailingHeaderDict setObject:@"Attendees" forKey:self.meetingContactKey];
        NSMutableArray* detailingQAList = [[ArcosCoreData sharedArcosCoreData]detailingQA];
        if ([detailingQAList count] != 0) {
            [self.detailingActiveKeyList addObject:self.adoptionLadderKey];
            [self.detailingRowDict setObject:detailingQAList forKey:self.adoptionLadderKey];
            [self.detailingActiveKeyList addObject:self.keyMessagesKey];
            NSMutableArray* detailingKeyMessagesList = [NSMutableArray arrayWithCapacity:[detailingQAList count]];
            for (NSMutableDictionary* aDict in detailingQAList) {
                NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
                [newDict setObject:self.keyMessagesKey forKey:@"DetailLevel"];
                [detailingKeyMessagesList addObject:newDict];
            }
            [self.detailingRowDict setObject:detailingKeyMessagesList forKey:self.keyMessagesKey];
        }
        NSMutableArray* detailingSamplesList = [[ArcosCoreData sharedArcosCoreData]detailingSamples];
        if ([detailingSamplesList count] != 0) {
            [self.detailingActiveKeyList addObject:self.samplesKey];
            [self.detailingRowDict setObject:detailingSamplesList forKey:self.samplesKey];
        }
        NSMutableArray* detailingRNGList = [[ArcosCoreData sharedArcosCoreData]detailingRNG];
        if ([detailingRNGList count] != 0) {
            [self.detailingActiveKeyList addObject:self.promotionalItemsKey];
            [self.detailingRowDict setObject:detailingRNGList forKey:self.promotionalItemsKey];
        }
        self.orderHeader = anOrderHeader;
        /*
        self.detailingSelectionNames = [NSMutableArray arrayWithObjects:@"Detailing", @"Samples", @"Promotional Items", nil];
        self.detailingSelections = [NSMutableArray array];
        [self.detailingSelections addObject:[[ArcosCoreData sharedArcosCoreData]detailingQA]];
        [self.detailingSelections addObject:[[ArcosCoreData sharedArcosCoreData]detailingSamples]];
        [self.detailingSelections addObject:[[ArcosCoreData sharedArcosCoreData]detailingRNG]];
        */
        self.hasDetailing = NO;
        self.hasKeyMessages = NO;
        self.hasSamples = NO;
        self.hasPromotionalItems = NO;
        self.hasPresenter = NO;
        self.hasMeetingContact = NO;
//        self.arcosConfigDataManager = [[[ArcosConfigDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.orderHeader != nil) { self.orderHeader = nil; }
//    if (self.detailingSelectionNames != nil) { self.detailingSelectionNames = nil; }
//    if (self.detailingSelections != nil) { self.detailingSelections = nil; }
    self.adoptionLadderKey = nil;
    self.keyMessagesKey = nil;
    self.samplesKey = nil;
    self.promotionalItemsKey = nil;
    self.presenterKey = nil;
    self.meetingContactKey = nil;
    self.detailingHeaderDict = nil;
    self.detailingActiveKeyList = nil;
    self.detailingRowDict = nil;
//    self.arcosConfigDataManager = nil;
    
    [super dealloc];
}

-(NSString*)employeeName{
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    return [NSString stringWithFormat:@"%@ %@", [employeeDict objectForKey:@"ForeName"], [employeeDict objectForKey:@"Surname"]];
}

-(NSString*)companyName {
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    return [configDict objectForKey:@"StandardLocationCode"];
}

-(NSString*)buildCallEmailMessageWithController:(NSMutableArray*)aTaskObjectList {
    [self fillCallTranTemplate];
//    NSLog(@"self.detailingSelections: %@", self.detailingSelections);
//    NSLog(@"calltranSet: %@", calltranSet);    
    NSString* auxInvoiceRef = [self.orderHeader objectForKey:@"invoiceRef"];
    BOOL showInvoiceRefFlag = NO;
    NSArray* invoiceRefList = nil;
    if (auxInvoiceRef != nil && ![auxInvoiceRef isEqualToString:@""]) {
        invoiceRefList = [auxInvoiceRef componentsSeparatedByString:@"|"];
        if ([invoiceRefList count] == 4) {
            NSNumber* typeIUR = [ArcosUtils convertStringToNumber:invoiceRefList[2]];
            if ([typeIUR intValue] != 0) {
                showInvoiceRefFlag = YES;
            }
        }
    }
    
    NSMutableString* body = [NSMutableString string];
    [body appendString:@"<html><body><table width='100%' height='100%'>"];
    
    //order header
    [body appendString:@"<tr><td width='100%' height='40'><table width='100%' height='100%'>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='40%'>"];
    [body appendString:[self.orderHeader objectForKey:@"CustName"]];    
    [body appendString:@"</td>"];
    [body appendString:@"<td width='15%' align='right'>"];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='45%' align='right'><b>"];
    [body appendString:[self.orderHeader objectForKey:@"orderDateText"]];    
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='40%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address1"]];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='15%' align='right'>"];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='45%' align='right'><b>"];
    [body appendString:[self.orderHeader objectForKey:@"callTypeText"]];    
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='40%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address2"]];
    [body appendString:@"</td>"];
    NSString* dueDateTitle = @"";
    NSString* dueDateContent = @"";
//    if (showInvoiceRefFlag) {
//        dueDateTitle = @"Due Date:";
//        dueDateContent = invoiceRefList[3];
//    }
    [body appendString:@"<td width='15%' align='right'>"];
    [body appendString:dueDateTitle];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='45%'><b>"];
    [body appendString:dueDateContent];
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    NSString* typeTitle = @"";
    NSString* typeContent = @"";
//    if (showInvoiceRefFlag) {
//        typeTitle = @"Type:";
//        NSNumber* typeIUR = [ArcosUtils convertStringToNumber:invoiceRefList[2]];
//        NSDictionary* descrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:typeIUR];
//        if (descrDetailDict != nil) {
//            typeContent = [descrDetailDict objectForKey:@"Detail"];
//        }
//    }
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='40%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address3"]];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='15%' align='right'>"];
    [body appendString:typeTitle];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='45%'><b>"];
    [body appendString:typeContent];
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    NSString* employeeTitle = @"";
    NSString* employeeContent = @"";
//    if (showInvoiceRefFlag) {
//        employeeTitle = @"Employee:";
//        NSNumber* employeeIUR = [ArcosUtils convertStringToNumber:invoiceRefList[1]];
//        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
//        employeeContent = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
//    }
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='40%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address4"]];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='15%' align='right'>"];
    [body appendString:employeeTitle];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='45%'><b>"];
    [body appendString:employeeContent];
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
//    if (showInvoiceRefFlag) {
//        NSString* detailsTitle = @"Details:";
//        NSString* detailsContent = invoiceRefList[0];
//        [body appendString:@"<tr>"];
//        [body appendString:@"<td width='40%'>"];
//        [body appendString:@"</td>"];
//        [body appendString:@"<td width='15%' align='right'>"];
//        [body appendString:detailsTitle];
//        [body appendString:@"</td>"];
//        [body appendString:@"<td width='45%'><b>"];
//        [body appendString:detailsContent];
//        [body appendString:@"</b></td>"];
//        [body appendString:@"</tr>"];
//    }
    
    
    [body appendString:@"</table></td></tr>"];
    
    NSString* memo = [self.orderHeader objectForKey:@"memo"];
    if (![memo isEqualToString:@""]) {
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='2' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='2' width='100%'><b>Memo</b></td></tr>"];
        [body appendString:@"<tr><td width='5%' align='left'></td>"];
        [body appendString:@"<td width='95%'>"];
        [body appendString:memo];
        [body appendString:@"</td></tr>"];
        [body appendString:@"</table></td></tr>"];
    }
    
    if (self.hasDetailing) {
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><b>"];
//        [body appendString:[self.detailingSelectionNames objectAtIndex:0]];
        [body appendString:[self.detailingHeaderDict objectForKey:self.adoptionLadderKey]];
        [body appendString:@"</b></td></tr>"];
        
//        NSMutableArray* aQASelection = [self.detailingSelections objectAtIndex:0];
        NSMutableArray* aQASelection = [self.detailingRowDict objectForKey:self.adoptionLadderKey];
        for (NSMutableDictionary* aQADict in aQASelection) {
            NSMutableDictionary* answerData = [aQADict objectForKey:@"data"];
            if (answerData != nil) {
                [body appendString:@"<tr>"];
                [body appendString:@"<td width='5%' align='left'></td>"];
                [body appendString:@"<td width='45%' align='left'>"];
                [body appendString:[NSString stringWithFormat:@"%@", [aQADict objectForKey:@"Label"]]];
                [body appendString:@"</td>"];
                [body appendString:@"<td width='50%' align='right'>"];
                [body appendString:[NSString stringWithFormat:@"%@",[answerData objectForKey:@"Detail"]]];        
                [body appendString:@"</td>"];
                [body appendString:@"</tr>"];
            }
        }
        [body appendString:@"</table></td></tr>"];        
    }
    if (self.hasKeyMessages) {
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><b>"];
        //        [body appendString:[self.detailingSelectionNames objectAtIndex:0]];
        [body appendString:[self.detailingHeaderDict objectForKey:self.keyMessagesKey]];
        [body appendString:@"</b></td></tr>"];
        
        //        NSMutableArray* aQASelection = [self.detailingSelections objectAtIndex:0];
        NSMutableArray* aKeyMessageList = [self.detailingRowDict objectForKey:self.keyMessagesKey];
        for (NSMutableDictionary* aKeyMessageDict in aKeyMessageList) {
            NSMutableDictionary* answerData = [aKeyMessageDict objectForKey:@"data"];
            if (answerData != nil) {
                [body appendString:@"<tr>"];
                [body appendString:@"<td width='5%' align='left'></td>"];
                [body appendString:@"<td width='45%' align='left'>"];
                [body appendString:[NSString stringWithFormat:@"%@", [aKeyMessageDict objectForKey:@"Label"]]];
                [body appendString:@"</td>"];
                [body appendString:@"<td width='50%' align='right'>"];
                [body appendString:[NSString stringWithFormat:@"%@",[answerData objectForKey:@"Detail"]]];
                [body appendString:@"</td>"];
                [body appendString:@"</tr>"];
            }
        }
        [body appendString:@"</table></td></tr>"];
    }
    
    if (self.hasSamples) {
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='5' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='5' width='100%'><b>"];
//        [body appendString:[self.detailingSelectionNames objectAtIndex:1]];
        [body appendString:[self.detailingHeaderDict objectForKey:self.samplesKey]];
        [body appendString:@"</b></td></tr>"];
        
//        NSMutableArray* sampleSelection = [self.detailingSelections objectAtIndex:1];
        NSMutableArray* sampleSelection = [self.detailingRowDict objectForKey:self.samplesKey];
        for (NSMutableDictionary* aSampleDict in sampleSelection) {
            NSMutableDictionary* aSampleData = [aSampleDict objectForKey:@"data"];
            if (aSampleData != nil) {
                [body appendString:@"<tr>"];
                [body appendString:@"<td width='5%' align='left'></td>"];
                [body appendString:@"<td width='45%' align='left'>"];
                [body appendString:[NSString stringWithFormat:@"%@", [aSampleDict objectForKey:@"Label"]]];
                [body appendString:@"</td>"];
                [body appendString:@"<td width='10%' align='left'>QTY:</td>"];
                NSMutableDictionary* given = [aSampleData objectForKey:@"Qty"];
                [body appendString:@"<td width='10%' align='right'>"];
                if (given != nil) {//any given value setted
                    [body appendString:[[given objectForKey:@"Qty"]stringValue]];
                } else {
                    [body appendString:@"0"];
                }
                [body appendString:@"</td>"];
                [body appendString:@"<td width='30%' align='right'>"];
                NSMutableDictionary* batch = [aSampleData objectForKey:@"Batch"];
                if (batch != nil) {//any given value setted
                    [body appendString:[batch objectForKey:@"Value"]];
                } else {
                    [body appendString:@"Select batch"];
                }
                [body appendString:@"</tr>"];
            }
        }
        [body appendString:@"</table></td></tr>"];
    }
    
    if (self.hasPromotionalItems) {
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='6' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='6' width='100%'><b>"];
//        [body appendString:[self.detailingSelectionNames objectAtIndex:2]];
        [body appendString:[self.detailingHeaderDict objectForKey:self.promotionalItemsKey]];
        [body appendString:@"</b></td></tr>"];
        
//        NSMutableArray* givenRequestSelection = [self.detailingSelections objectAtIndex:2];
        NSMutableArray* givenRequestSelection = [self.detailingRowDict objectForKey:self.promotionalItemsKey];
        for (NSMutableDictionary* givenRequestDict in givenRequestSelection) {
            NSMutableDictionary* givenRequestData = [givenRequestDict objectForKey:@"data"];
            if (givenRequestData != nil) {
                [body appendString:@"<tr>"];
                [body appendString:@"<td width='5%' align='left'></td>"];
                [body appendString:@"<td width='45%' align='left'>"];
                [body appendString:[NSString stringWithFormat:@"%@", [givenRequestDict objectForKey:@"Label"]]];
                [body appendString:@"</td>"];
                [body appendString:@"<td width='10%' align='left'>Given:</td>"];
                NSMutableDictionary* given = [givenRequestData objectForKey:@"Given"];
                [body appendString:@"<td width='10%' align='right'>"];
                if (given != nil) {//any given value setted
                    [body appendString:[[given objectForKey:@"Qty"]stringValue]];
                } else {
                    [body appendString:@"0"];
                }
                [body appendString:@"</td>"];
                [body appendString:@"<td width='15%' align='right'>Request:</td>"];
                NSMutableDictionary* request = [givenRequestData objectForKey:@"Request"];
                [body appendString:@"<td width='15%' align='right'>"];
                if (request != nil) {//any request value setted
                    [body appendString:[[request objectForKey:@"Qty"]stringValue]];
                } else {
                    [body appendString:@"0"];
                }
                [body appendString:@"</td>"];
                [body appendString:@"</tr>"];
            }
        }
        [body appendString:@"</table></td></tr>"];
    }
    if (self.hasPresenter) {
        
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><b>"];
        [body appendString:[self.detailingHeaderDict objectForKey:self.presenterKey]];
        [body appendString:@"</b></td></tr>"];
        NSMutableArray* aPresenterSelection = [self.detailingRowDict objectForKey:self.presenterKey];
        for (NSMutableDictionary* aPresenterDict in aPresenterSelection) {
            NSNumber* answerData = [aPresenterDict objectForKey:@"data"];
            if (answerData != nil) {
                [body appendString:@"<tr>"];
                [body appendString:@"<td width='5%' align='left'></td>"];
                [body appendString:@"<td width='45%' align='left'>"];
                [body appendString:[NSString stringWithFormat:@"%@", [aPresenterDict objectForKey:@"Label"]]];
                [body appendString:@"</td>"];
                [body appendString:@"<td width='50%' align='right'>"];
                [body appendString:[NSString stringWithFormat:@"%@", answerData]];
                [body appendString:@"</td>"];
                [body appendString:@"</tr>"];
            }
        }
        [body appendString:@"</table></td></tr>"];
    }
    if (self.hasMeetingContact) {
        
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='3' width='100%'><b>"];
        [body appendString:[self.detailingHeaderDict objectForKey:self.meetingContactKey]];
        [body appendString:@"</b></td></tr>"];
        NSMutableArray* aMeetingContactSelection = [self.detailingRowDict objectForKey:self.meetingContactKey];
        for (NSMutableDictionary* aMeetingContactDict in aMeetingContactSelection) {
            NSNumber* answerData = [aMeetingContactDict objectForKey:@"data"];
            if (answerData != nil) {
                [body appendString:@"<tr>"];
                [body appendString:@"<td width='5%' align='left'></td>"];
                [body appendString:@"<td width='45%' align='left'>"];
                [body appendString:[NSString stringWithFormat:@"%@", [aMeetingContactDict objectForKey:@"Label"]]];
                [body appendString:@"</td>"];
                [body appendString:@"<td width='50%' align='right'>"];
                [body appendString:[NSString stringWithFormat:@"%@", answerData]];
                [body appendString:@"</td>"];
                [body appendString:@"</tr>"];
            }
        }
        [body appendString:@"</table></td></tr>"];
    }
    if (showInvoiceRefFlag) {
        NSString* typeContent = @"";
        NSNumber* typeIUR = [ArcosUtils convertStringToNumber:invoiceRefList[2]];
        NSDictionary* descrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:typeIUR];
        if (descrDetailDict != nil) {
            typeContent = [descrDetailDict objectForKey:@"Detail"];
        }
        NSString* detailsContent = invoiceRefList[0];
        NSString* employeeContent = @"";
        NSNumber* employeeIUR = [ArcosUtils convertStringToNumber:invoiceRefList[1]];
        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
        employeeContent = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
        NSString* dueDateContent = invoiceRefList[3];
        [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
        [body appendString:@"<tr><td colspan='2' width='100%'><hr></td></tr>"];
        [body appendString:@"<tr><td colspan='2' width='100%'><b>"];
        [body appendString:[ArcosUtils convertNilToEmpty:typeContent]];
        [body appendString:@"</b></td></tr>"];
        [body appendString:@"<tr><td width='5%' align='left'></td>"];
        [body appendString:@"<td width='95%' align='left'>"];
        [body appendString:[ArcosUtils convertNilToEmpty:detailsContent]];
        [body appendString:@"</td></tr>"];
        [body appendString:@"<tr><td width='5%' align='left'></td>"];
        [body appendString:@"<td width='95%' align='left' style='font-size:12px'>"];
        [body appendString:[NSString stringWithFormat:@"Entered by %@ on %@",[ArcosUtils convertNilToEmpty:employeeContent], [ArcosUtils convertNilToEmpty:dueDateContent]]];
        [body appendString:@"</td></tr>"];
        
        [body appendString:@"</table></td></tr>"];
    }
    
    if ([aTaskObjectList count] > 0) {
        for (int i = 0; i < [aTaskObjectList count]; i++) {
            ArcosGenericClass* auxArcosGenericClass = [aTaskObjectList objectAtIndex:i];
            [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
            [body appendString:@"<tr><td colspan='2' width='100%'><hr></td></tr>"];
            [body appendString:@"<tr><td colspan='2' width='100%'><b>"];
            [body appendString:[ArcosUtils convertNilToEmpty:auxArcosGenericClass.Field2]];
            [body appendString:@"</b></td></tr>"];
            [body appendString:@"<tr><td width='5%' align='left'></td>"];
            [body appendString:@"<td width='95%' align='left'>"];
            [body appendString:[ArcosUtils convertNilToEmpty:auxArcosGenericClass.Field4]];
            [body appendString:@"</td></tr>"];
            [body appendString:@"<tr><td width='5%' align='left'></td>"];
            [body appendString:@"<td width='95%' align='left' style='font-size:12px'>"];
            [body appendString:[NSString stringWithFormat:@"Entered by %@ on %@ %@",[ArcosUtils convertNilToEmpty:auxArcosGenericClass.Field5], [ArcosUtils convertNilToEmpty:auxArcosGenericClass.Field3], [ArcosUtils convertNilToEmpty:auxArcosGenericClass.Field1]]];
            [body appendString:@"</td></tr>"];
            
            [body appendString:@"</table></td></tr>"];
        }
    }
    
    [body appendString:@"<tr><td height='100%' width='100%'><table width='100%' height='100%'>"];        
    [body appendString:@"</table></td></tr>"];
    [body appendString:@"</table></body></html>"];
    return body;
}

-(void)fillCallTranTemplate {
    NSNumber* coordinateType = [self.orderHeader objectForKey:@"CoordinateType"];
    NSMutableArray* calltranList = nil;
    if ([coordinateType intValue] == 0) {
        NSNumber* theOrderNumber = [self.orderHeader objectForKey:@"OrderNumber"];
        
        OrderHeader* OH = [[ArcosCoreData sharedArcosCoreData]orderHeaderWithOrderNumber:theOrderNumber];
        NSSet* calltranSet = OH.calltrans;
        calltranList = [ProductFormRowConverter convertManagedCalltranSet:calltranSet];
    } else if ([coordinateType intValue] == 1) {
        calltranList = [self.orderHeader objectForKey:@"RemoteCallTrans"];
    }
    for (ArcosCallTran* CT in calltranList) {
        //fill 
        if ([CT.DetailLevel isEqualToString:@"DT"]) {
//            NSMutableArray* QASelection = [self.detailingSelections objectAtIndex:0];
            NSMutableArray* QASelection = [self.detailingRowDict objectForKey:self.adoptionLadderKey];
            
            for (NSMutableDictionary* aDict in QASelection) {
                if (CT.DetailIUR != 0 && [aDict valueForKeyPath:@"DescIUR"]!=nil) {
                    if (CT.DetailIUR == [[aDict valueForKeyPath:@"DescIUR"] intValue]) {
                        NSDictionary* aData = [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                        [aDict setObject:aData forKey:@"data"];
//                        NSLog(@"DT setted 1 %@",aData);
                        self.hasDetailing = YES;
                    }
                }
                if (CT.ProductIUR != 0 && [aDict valueForKeyPath:@"ProductIUR"]!=nil) {
                    if (CT.ProductIUR == [[aDict valueForKeyPath:@"ProductIUR"] intValue]) {
                        NSDictionary* aData= [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                        [aDict setObject:aData forKey:@"data"];
//                        NSLog(@"DT setted %@",aData);
                        self.hasDetailing = YES;
                    }
                }
            }
            
        }
        if ([CT.DetailLevel isEqualToString:self.keyMessagesKey]) {
            //            NSMutableArray* QASelection = [self.detailingSelections objectAtIndex:0];
            NSMutableArray* keyMessageList = [self.detailingRowDict objectForKey:self.keyMessagesKey];
            
            for (NSMutableDictionary* aDict in keyMessageList) {
                if (CT.DetailIUR != 0 && [aDict valueForKeyPath:@"DescIUR"]!=nil) {
                    if (CT.DetailIUR == [[aDict valueForKeyPath:@"DescIUR"] intValue]) {
                        NSDictionary* aData = [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                        [aDict setObject:aData forKey:@"data"];
                        //                        NSLog(@"DT setted 1 %@",aData);
                        self.hasKeyMessages = YES;
                    }
                }
                if (CT.ProductIUR != 0 && [aDict valueForKeyPath:@"ProductIUR"]!=nil) {
                    if (CT.ProductIUR == [[aDict valueForKeyPath:@"ProductIUR"] intValue]) {
                        NSDictionary* aData= [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                        [aDict setObject:aData forKey:@"data"];
                        //                        NSLog(@"DT setted %@",aData);
                        self.hasKeyMessages = YES;
                    }
                }
            }
            
        }
        
        //fill up the samples
        if ([CT.DetailLevel isEqualToString:@"SM"]) {
            NSLog(@"SM found");
            
//            NSMutableArray* SampleSelection=[self.detailingSelections objectAtIndex:1];
            NSMutableArray* SampleSelection = [self.detailingRowDict objectForKey:self.samplesKey];
            for (NSMutableDictionary* aDict in SampleSelection) {
                if (CT.ProductIUR != 0 && [aDict valueForKeyPath:@"IUR"]!=nil) {
                    if (CT.ProductIUR == [[aDict valueForKeyPath:@"IUR"] intValue]){
                        NSMutableDictionary* aData=[NSMutableDictionary dictionary];
                        NSMutableDictionary* aBatch=[NSMutableDictionary dictionary];
                        NSMutableDictionary* aQty=[NSMutableDictionary dictionary];
                        
                        [aBatch setObject:[NSNumber numberWithInt:CT.ProductIUR] forKey:@"ProductIUR"];
                        [aBatch setObject:[ArcosUtils convertNilToEmpty:CT.Reference] forKey:@"Value"];
                        [aQty setObject:[NSNumber numberWithInt:CT.Score] forKey:@"Qty"];
                        
                        [aData setObject:aBatch forKey:@"Batch"];
                        [aData setObject:aQty forKey:@"Qty"];
                        
                        [aDict setObject:aData forKey:@"data"];
                        self.hasSamples = YES;
                    }
                }
            }
            
        }
        
        //fill out the request and given
        if ([CT.DetailLevel isEqualToString:@"GV"]||[CT.DetailLevel isEqualToString:@"RQ"]) {
            NSMutableArray* GiveAndRequestSelection = [self.detailingRowDict objectForKey:self.promotionalItemsKey];
            for (NSMutableDictionary* aDict in GiveAndRequestSelection) {
                
                NSMutableDictionary* aData;
                if ([aDict objectForKey:@"data"]!=nil) {
                    aData=[aDict objectForKey:@"data"];
                }else{
                    aData=[NSMutableDictionary dictionary];
                }
                
                if (CT.DetailIUR == [[aDict valueForKeyPath:@"IUR"] intValue]){
                    
                    if ([CT.DetailLevel isEqualToString: @"GV"]) {
                        NSMutableDictionary* aGiven=[NSMutableDictionary dictionary];
                        [aGiven setObject:[NSNumber numberWithInt:CT.Score] forKey:@"Qty"];
                        [aGiven setObject:@"GV" forKey:@"DetailLevel"];
                        [aData setObject:aGiven forKey:@"Given"];
                        
                    }
                    if ([CT.DetailLevel isEqualToString: @"RQ"]) {
                        NSMutableDictionary* aRequest=[NSMutableDictionary dictionary];
                        [aRequest setObject:[NSNumber numberWithInt:CT.Score] forKey:@"Qty"];
                        [aRequest setObject:@"RQ" forKey:@"DetailLevel"];
                        [aData setObject:aRequest forKey:@"Request"];
                        
                    }
                    [aDict setObject:aData forKey:@"data"];
                    self.hasPromotionalItems = YES;
                }
            }
        }
        
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] && [CT.DetailLevel isEqualToString:self.presenterKey]) {
            
            NSMutableArray* presenterSelection = [self.detailingRowDict objectForKey:self.presenterKey];
            if (presenterSelection == nil) {
                presenterSelection = [NSMutableArray array];
                [self.detailingActiveKeyList addObject:self.presenterKey];
                [self.detailingRowDict setObject:presenterSelection forKey:self.presenterKey];
            }
            
            NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
            NSDictionary* presenterDict = [[ArcosCoreData sharedArcosCoreData] presenterWithIUR:[NSNumber numberWithInt:CT.DetailIUR]];
            [cellData setObject:[NSNumber numberWithInt:CT.DetailIUR] forKey:@"presenterIUR"];
            [cellData setObject:@"PS" forKey:@"DetailLevel"];
            [cellData setObject:[ArcosUtils convertNilToEmpty:[presenterDict objectForKey:@"Title"]]  forKey:@"Label"];
//            [cellData setObject:[NSNumber numberWithInt:CT.Score] forKey:@"data"];
            [cellData setObject:[ArcosUtils convertNilToEmpty:CT.Reference] forKey:@"data"];
            [presenterSelection addObject:cellData];
            self.hasPresenter = YES;
        }
        if ([CT.DetailLevel isEqualToString:self.meetingContactKey]) {
            
            NSMutableArray* meetingContactSelection = [self.detailingRowDict objectForKey:self.meetingContactKey];
            if (meetingContactSelection == nil) {
                meetingContactSelection = [NSMutableArray array];
                [self.detailingActiveKeyList addObject:self.meetingContactKey];
                [self.detailingRowDict setObject:meetingContactSelection forKey:self.meetingContactKey];
            }
            
            NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
            
            [cellData setObject:self.meetingContactKey forKey:@"DetailLevel"];
            NSArray* referenceList = [CT.Reference componentsSeparatedByString:@"|"];
            @try {
                [cellData setObject:[ArcosUtils convertNilToEmpty:[referenceList objectAtIndex:0]]  forKey:@"Label"];
                [cellData setObject:[ArcosUtils convertNilToEmpty:[referenceList objectAtIndex:1]] forKey:@"data"];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            [meetingContactSelection addObject:cellData];
            self.hasMeetingContact = YES;
        }
    }
}

@end
