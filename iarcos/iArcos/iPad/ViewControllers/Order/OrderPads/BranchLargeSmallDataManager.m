//
//  BranchLargeSmallDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 14/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLargeSmallDataManager.h"

@implementation BranchLargeSmallDataManager
@synthesize displayList = _displayList;
@synthesize slideViewItemList = _slideViewItemList;
@synthesize currentPage = _currentPage;
@synthesize previousPage = _previousPage;
@synthesize bufferSize = _bufferSize;
@synthesize halfBufferSize = _halfBufferSize;
@synthesize formType = _formType;
@synthesize branchDescrTypeCode = _branchDescrTypeCode;
@synthesize leafDescrTypeCode = _leafDescrTypeCode;
@synthesize branchLxCode = _branchLxCode;
@synthesize leafLxCode = _leafLxCode;
@synthesize formTypeId = _formTypeId;
@synthesize branchLeafDataProcessCenter = _branchLeafDataProcessCenter;
@synthesize branchLeafProductBaseDataManager = _branchLeafProductBaseDataManager;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];        
        self.slideViewItemList = [NSMutableArray array];
        self.currentPage = 0;
        self.previousPage = 0;
        self.bufferSize = 7;
        self.halfBufferSize = self.bufferSize / 2;
        self.branchLeafDataProcessCenter = [[[BranchLeafDataProcessCenter alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }    
    if (self.formType != nil) { self.formType = nil; }
    if (self.branchDescrTypeCode != nil) { self.branchDescrTypeCode = nil; }
    if (self.leafDescrTypeCode != nil) { self.leafDescrTypeCode = nil; }
    if (self.branchLxCode != nil) { self.branchLxCode = nil; }
    if (self.leafLxCode != nil) { self.leafLxCode = nil; }
    if (self.branchLeafDataProcessCenter != nil) { self.branchLeafDataProcessCenter = nil; }
    if (self.branchLeafProductBaseDataManager != nil) { self.branchLeafProductBaseDataManager = nil; }
    
    [super dealloc];
}

- (void)createBranchLargeSmallL45Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 30;
    arcosFormDetailBO.Details = @"Branch Large Small Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [ArcosUtils dateFromString:@"01/01/2021" format:[GlobalSharedClass shared].dateFormat];
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 445;
    arcosFormDetailBO.Type = @"445";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)createBranchLargeSmallL35Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 31;
    arcosFormDetailBO.Details = @"Branch Large Small Brand Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 435;
    arcosFormDetailBO.Type = @"435";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)createBranchLargeSmallL45GridData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 50;
    arcosFormDetailBO.Details = @"Branch Large Small Grid Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 545;
    arcosFormDetailBO.Type = @"545";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    arcosFormDetailBO.ShowSeperators = YES;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)createBranchSmallL05GridData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 52;
    arcosFormDetailBO.Details = @"Branch Small Grid Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 505;
    arcosFormDetailBO.Type = @"505";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    arcosFormDetailBO.ShowSeperators = YES;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)analyseFormTypeRawData {
    NSRange formTypeRange = NSMakeRange(0, 1);
    NSRange branchRange = NSMakeRange(1, 1);
    NSRange leafRange = NSMakeRange(2, 1);
    self.formTypeId = [ArcosUtils convertStringToNumber:[self.formType substringWithRange:formTypeRange]];
    NSString* branchCode = [self.formType substringWithRange:branchRange];
    NSString* leafCode = [self.formType substringWithRange:leafRange];
    self.branchDescrTypeCode = [NSString stringWithFormat:@"L%@", branchCode];
    self.leafDescrTypeCode = [NSString stringWithFormat:@"L%@", leafCode];
    self.branchLxCode = [NSString stringWithFormat:@"L%@Code", branchCode];
    self.leafLxCode = [NSString stringWithFormat:@"L%@Code", leafCode];
//    NSLog(@"analyse: %@ %@ %@ %@ %@", self.branchDescrTypeCode, self.leafDescrTypeCode, self.branchLxCode, self.leafLxCode, self.formTypeId);
}

- (void)retrieveAnalyseFormTypeRawData {
    NSMutableDictionary* formTypeMiscDict = [self.branchLeafDataProcessCenter analyseFormTypeRawData:self.formType];
    self.formTypeId = [formTypeMiscDict objectForKey:@"formTypeId"];
    self.branchDescrTypeCode = [formTypeMiscDict objectForKey:@"branchDescrTypeCode"];
    self.leafDescrTypeCode = [formTypeMiscDict objectForKey:@"leafDescrTypeCode"];
    self.branchLxCode = [formTypeMiscDict objectForKey:@"branchLxCode"];
    self.leafLxCode = [formTypeMiscDict objectForKey:@"leafLxCode"];
}

/*
 * BranchDict()
 *    -LeafChildren (hasActiveProduct)
 */
- (void)getBranchLeafData {
    [self retrieveAnalyseFormTypeRawData];
    switch ([self.formTypeId intValue]) {
        case 4: {
            self.branchLeafProductBaseDataManager = [[[BranchLeafProductListDataManager alloc] init] autorelease];
        }            
            break;
        case 5: {
            self.branchLeafProductBaseDataManager = [[[BranchLeafProductGridDataManager alloc] init] autorelease];
        }            
            break;
        default: {
            self.branchLeafProductBaseDataManager = [[[BranchLeafProductListDataManager alloc] init] autorelease];
        }
            break;
    }
    self.displayList = [self.branchLeafDataProcessCenter getBranchLeafData:self.branchDescrTypeCode leafDescrTypeCode:self.leafDescrTypeCode branchLxCode:self.branchLxCode leafLxCode:self.leafLxCode];
//    NSLog(@"final self.displayList %@", self.displayList);
}

- (void)createPlaceholderBranchLargeSmallSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        [self.slideViewItemList addObject:[NSNull null]];
    }
}

- (void)fillBranchLargeSmallSlideViewItemWithIndex:(int)anIndex {
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndex];
    NSNumber* imageIur = [cellDataDict objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];        
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];        
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    [aLISVIC.myButton setImage:anImage forState:UIControlStateNormal];
    if (isCompanyImage) {
        aLISVIC.myButton.alpha = [GlobalSharedClass shared].imageCellAlpha;
    } else {
        aLISVIC.myButton.alpha = 1.0;
    }
    aLISVIC.myButton.adjustsImageWhenHighlighted = NO;
}

@end
