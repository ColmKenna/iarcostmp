//
//  FormRowsTableDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 19/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "FormRowsTableDataManager.h"

@implementation FormRowsTableDataManager
@synthesize currentFormDetailDict = _currentFormDetailDict;
@synthesize prevStandardOrderPadFlag = _prevStandardOrderPadFlag;
@synthesize prevNumber = _prevNumber;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize prevNormalStandardOrderPadFlag = _prevNormalStandardOrderPadFlag;
@synthesize prevNormalNumber = _prevNormalNumber;
@synthesize enablePhysKeyboardFlag = _enablePhysKeyboardFlag;
@synthesize currentTextFieldIndex = _currentTextFieldIndex;
@synthesize currentTextFieldHighlightedFlag = _currentTextFieldHighlightedFlag;
@synthesize textFieldTagKeyDict = _textFieldTagKeyDict;
@synthesize viewHasBeenAppearedTime = _viewHasBeenAppearedTime;
@synthesize firstProductRowIndex = _firstProductRowIndex;
@synthesize firstProductRowHasBeenShowedFlag = _firstProductRowHasBeenShowedFlag;
@synthesize searchBarFocusedByShortCutFlag = _searchBarFocusedByShortCutFlag;
@synthesize showFooterMatViewFlag = _showFooterMatViewFlag;
@synthesize viewDidAppearedFlag = _viewDidAppearedFlag;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.currentIndexPath = nil;
        self.currentTextFieldIndex = 0;
        self.currentTextFieldHighlightedFlag = NO;
        self.viewHasBeenAppearedTime = 0;
        self.firstProductRowIndex = -1;
        self.firstProductRowHasBeenShowedFlag = NO;
        self.searchBarFocusedByShortCutFlag = NO;
        self.textFieldTagKeyDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Qty", @"Bonus", @"DiscountPercent", nil] forKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]];
        self.viewDidAppearedFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.currentFormDetailDict = nil;
    self.prevNumber = nil;
    self.currentIndexPath = nil;
    self.prevNormalNumber = nil;
    self.textFieldTagKeyDict = nil;
    
    [super dealloc];
}

- (NSMutableArray*)retrieveTableViewDataSourceWithSearchText:(NSString*)aSearchText orderFormDetails:(NSString*)anOrderFormDetails {
    NSMutableArray* tmpDisplayList = [NSMutableArray array];
    NSMutableArray* auxProducts = [[ArcosCoreData sharedArcosCoreData] productWithDescriptionKeyword:aSearchText];
    
    if (auxProducts != nil) {
        NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[auxProducts count]];
        for (NSDictionary* aDict in auxProducts) {
            [productIURList addObject:[aDict objectForKey:@"ProductIUR"]];
        }
//        NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIURList:productIURList];
//        NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData].arcosCoreDataManager processPriceProductList:auxProducts priceHashMap:priceHashMap];
        NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:auxProducts productIURList:productIURList locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault]];
        tmpDisplayList = [NSMutableArray arrayWithCapacity:[products count]];
        for (NSMutableDictionary* aProduct in products) {//loop products
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:aProduct orderFormDetails:anOrderFormDetails];
            //sync the row with current cart
            formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
            [tmpDisplayList addObject:formRow];
        }
    }
    return tmpDisplayList;
}

- (NSMutableArray*)retrievePredicativeTableViewDataSourceWithOrderFormDetails:(NSString*)anOrderFormDetails {
    NSMutableArray* tmpDisplayList = [NSMutableArray array];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1'"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ProductCode", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectArray count] <= 0) return tmpDisplayList;
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[objectArray count]];
    for (NSDictionary* aDict in objectArray) {
        [productIURList addObject:[aDict objectForKey:@"ProductIUR"]];
    }
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:objectArray productIURList:productIURList locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault]];
    tmpDisplayList = [NSMutableArray arrayWithCapacity:[products count]];
    for (NSMutableDictionary* aProduct in products) {//loop products
        NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:aProduct orderFormDetails:anOrderFormDetails];
        //sync the row with current cart
        formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        [tmpDisplayList addObject:formRow];
    }
    return tmpDisplayList;
}


@end
