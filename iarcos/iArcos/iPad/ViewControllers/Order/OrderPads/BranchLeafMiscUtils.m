//
//  BranchLeafMiscUtils.m
//  Arcos
//
//  Created by David Kilmartin on 23/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafMiscUtils.h"

@implementation BranchLeafMiscUtils

- (NSMutableDictionary*)getImageWithImageIUR:(NSNumber*)anImageIUR {
    NSMutableDictionary* imageDict = [NSMutableDictionary dictionaryWithCapacity:2];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([anImageIUR intValue] > 0) {
        anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:anImageIUR];        
    } else {
        anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];        
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    [imageDict setObject:anImage forKey:@"ImageObj"];
    [imageDict setObject:[NSNumber numberWithBool:isCompanyImage] forKey:@"CompanyImage"];
    return imageDict;
}

- (NSMutableArray*)getFormRowList:aBranchLxCodeContent branchLxCode:aBranchLxCode leafLxCodeContent:anLeafLxCodeContent leafLxCode:anLeafLxCode {
    NSMutableArray* productList = [[ArcosCoreData sharedArcosCoreData] activeProduct:aBranchLxCodeContent branchLxCode:aBranchLxCode leafLxCodeContent:anLeafLxCodeContent leafLxCode:anLeafLxCode];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[productList count]];
    for (NSDictionary* aDict in productList) {
        [productIURList addObject:[aDict objectForKey:@"ProductIUR"]];
    }
//    NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIURList:productIURList];
//    productList = [[ArcosCoreData sharedArcosCoreData].arcosCoreDataManager processPriceProductList:productList priceHashMap:priceHashMap];
    productList = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:productList productIURList:productIURList locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIUR]];
    NSMutableArray* unsortFormRows = [NSMutableArray arrayWithCapacity:[productList count]];
    for (NSMutableDictionary* product in productList) {
        NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:product];
        //sync the row with current cart
        formRow = [[OrderSharedClass sharedOrderSharedClass] syncRowWithCurrentCart:formRow];        
        [unsortFormRows addObject:formRow];
    }
    return unsortFormRows;
}

@end
