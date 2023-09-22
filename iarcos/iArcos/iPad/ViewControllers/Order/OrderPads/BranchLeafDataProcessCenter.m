//
//  BranchLeafDataProcessCenter.m
//  Arcos
//
//  Created by David Kilmartin on 16/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafDataProcessCenter.h"

@implementation BranchLeafDataProcessCenter
@synthesize arcosAlgorithmUtils = _arcosAlgorithmUtils;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.arcosAlgorithmUtils = [[[ArcosAlgorithmUtils alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.arcosAlgorithmUtils != nil) { self.arcosAlgorithmUtils = nil; }        
    
    [super dealloc];
}

- (NSMutableArray*)getBranchLeafData:(NSString*)aBranchDescrTypeCode leafDescrTypeCode:(NSString*)anLeafDescrTypeCode branchLxCode:(NSString*)aBranchLxCode leafLxCode:(NSString*)anLeafLxCode {
    NSMutableArray* tmpDisplayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:aBranchDescrTypeCode parentCode:nil];
//    NSLog(@"tmpDisplayList: %@", tmpDisplayList);
    
    NSMutableDictionary* branchDescrDetailIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpDescrDetailDict in tmpDisplayList) {
        NSString* branchDescDetailCode = [ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailCode"]];
        [branchDescrDetailIURHashMap setObject:[ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]] forKey:branchDescDetailCode];
    }
    NSArray* tmpBranchDescrDetailCodeList = [branchDescrDetailIURHashMap allKeys];
//    NSLog(@"tmpBranchDescrDetailCodeList: %@", tmpBranchDescrDetailCodeList);
    NSMutableArray* tmpBranchLeafProductList = [[ArcosCoreData sharedArcosCoreData] productWithBranchCodeList:tmpBranchDescrDetailCodeList branchLxCode:aBranchLxCode leafLxCode:anLeafLxCode];
//    NSLog(@"tmpBranchLeafProductList: %@", tmpBranchLeafProductList);
    NSArray* tmpLeafCodeList = [self getLeafCodeListWithBranchLeafProductList:tmpBranchLeafProductList leafLxCode:anLeafLxCode];
    
    NSMutableArray* tmpLeafDescrDetailCodeList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithL5CodeList:tmpLeafCodeList descrTypeCode:anLeafDescrTypeCode active:1];
    //    NSLog(@"tmpLeafDescrDetailCodeList: %@", tmpLeafDescrDetailCodeList);
    
    NSMutableDictionary* tmpLeafDescrDetailCodeHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpLeafDescrDetailCodeList count]];
    for (NSDictionary* tmpLeafDescrDetailCodeDict in tmpLeafDescrDetailCodeList) {
        [tmpLeafDescrDetailCodeHashMap setObject:tmpLeafDescrDetailCodeDict forKey:[tmpLeafDescrDetailCodeDict objectForKey:@"DescrDetailCode"]];
    }
    //    NSLog(@"tmpLeafDescrDetailCodeHashMap: %@", tmpLeafDescrDetailCodeHashMap);
    
    //filter leafCode that is inactive in descrdetail
    /*
     *BranchCodeIUR branchLxCode LeafDescrDetail
     */
    NSMutableArray* tmpActiveBranchLeafProductList = [NSMutableArray arrayWithCapacity:[tmpBranchLeafProductList count]];
    for (int i = 0; i < [tmpBranchLeafProductList count]; i++) {
        NSDictionary* tmpBranchLeafProductDict = [tmpBranchLeafProductList objectAtIndex:i];
        NSDictionary* tmpLeafDescrDetailDict = [tmpLeafDescrDetailCodeHashMap objectForKey:[tmpBranchLeafProductDict objectForKey:anLeafLxCode]];
        if (tmpLeafDescrDetailDict != nil) {
            NSMutableDictionary* tmpActiveBranchLeafProductDict = [NSMutableDictionary dictionaryWithCapacity:3];
            NSString* branchCode = [tmpBranchLeafProductDict objectForKey:aBranchLxCode];
            [tmpActiveBranchLeafProductDict setObject:[branchDescrDetailIURHashMap objectForKey:branchCode] forKey:@"BranchCodeIUR"];
            [tmpActiveBranchLeafProductDict setObject:branchCode forKey:aBranchLxCode];
            [tmpActiveBranchLeafProductDict setObject:tmpLeafDescrDetailDict forKey:@"LeafDescrDetail"];
            [tmpActiveBranchLeafProductList addObject:tmpActiveBranchLeafProductDict];
        }
    }
//    NSLog(@"tmpActiveBranchLeafProductList: %@", tmpActiveBranchLeafProductList);
    if ([tmpActiveBranchLeafProductList count] == 0) {        
//        [ArcosUtils showMsg:@"Please Check for Active Product Group Assignments." delegate:nil];
        [ArcosUtils showDialogBox:@"Please Check for Active Product Group Assignments." title:@"" target:[ArcosUtils getRootView] handler:nil];
        return [NSMutableArray array];
    }
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"BranchCodeIUR" ascending:YES] autorelease];
    [tmpActiveBranchLeafProductList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
//    NSLog(@"tmpActiveBranchLeafProductList count: %d %@", [tmpActiveBranchLeafProductList count], tmpActiveBranchLeafProductList);
    
    NSMutableArray* displayList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpBranchDescrDetailDict in tmpDisplayList) {
        NSNumber* branchCodeIUR = [tmpBranchDescrDetailDict objectForKey:@"DescrDetailIUR"];
        
        int location = [self.arcosAlgorithmUtils binarySearchWithArrayOfDict:tmpActiveBranchLeafProductList dictKey:@"BranchCodeIUR" keyword:branchCodeIUR];
        if (location != -1) {            
            NSRange range = [self.arcosAlgorithmUtils getBSRangeWithArrayOfDict:tmpActiveBranchLeafProductList dictKey:@"BranchCodeIUR" keyword:branchCodeIUR location:location];
            NSArray* subsetTmpActiveBranchLeafProductList = [tmpActiveBranchLeafProductList subarrayWithRange:range];
            NSMutableDictionary* branchDescrDetailDict = [NSMutableDictionary dictionaryWithDictionary:tmpBranchDescrDetailDict];
            NSMutableArray* leafDescrDetailDictList = [NSMutableArray arrayWithCapacity:[subsetTmpActiveBranchLeafProductList count]];
            
            for (NSDictionary* subsetTmpActiveBranchLeafProductDict in subsetTmpActiveBranchLeafProductList) {
                NSDictionary* leafDescrDetailDict = [subsetTmpActiveBranchLeafProductDict objectForKey:@"LeafDescrDetail"];
                [leafDescrDetailDictList addObject:[NSDictionary dictionaryWithDictionary:leafDescrDetailDict]];
            }
            NSSortDescriptor* leafDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Detail" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            [leafDescrDetailDictList sortUsingDescriptors:[NSArray arrayWithObjects:leafDescriptor,nil]];
            [branchDescrDetailDict setObject:leafDescrDetailDictList forKey:@"LeafChildren"];
            [displayList addObject:branchDescrDetailDict];
        }
    }
//    NSLog(@"self.displayList: %@", displayList);
    return displayList;
}

- (NSArray*)getLeafCodeListWithBranchLeafProductList:(NSArray*)aBranchLeafProductList leafLxCode:(NSString*)anLeafLxCode {
    NSMutableDictionary* tmpLeafCodeListDict = [NSMutableDictionary dictionaryWithCapacity:[aBranchLeafProductList count]];
    for (NSDictionary* tmpBranchLeafDict in aBranchLeafProductList) {
        [tmpLeafCodeListDict setObject:[NSNull null] forKey:[ArcosUtils convertNilToEmpty:[tmpBranchLeafDict objectForKey:anLeafLxCode]]];
    }
    return [tmpLeafCodeListDict allKeys];
}

- (NSMutableDictionary*)analyseFormTypeRawData:(NSString*)aFormType {
    NSMutableDictionary* formTypeMiscDict = [NSMutableDictionary dictionaryWithCapacity:5];
    NSRange formTypeRange = NSMakeRange(0, 1);
    NSRange branchRange = NSMakeRange(1, 1);
    NSRange leafRange = NSMakeRange(2, 1); 
    NSNumber* formTypeId = [ArcosUtils convertStringToNumber:[aFormType substringWithRange:formTypeRange]];
    NSString* branchCode = [aFormType substringWithRange:branchRange];
    NSString* leafCode = [aFormType substringWithRange:leafRange];
    NSString* branchDescrTypeCode = [NSString stringWithFormat:@"L%@", branchCode];
    NSString* leafDescrTypeCode = [NSString stringWithFormat:@"L%@", leafCode];
    NSString* branchLxCode = [NSString stringWithFormat:@"L%@Code", branchCode];
    NSString* leafLxCode = [NSString stringWithFormat:@"L%@Code", leafCode];
    [formTypeMiscDict setObject:formTypeId forKey:@"formTypeId"];
    [formTypeMiscDict setObject:branchDescrTypeCode forKey:@"branchDescrTypeCode"];
    [formTypeMiscDict setObject:leafDescrTypeCode forKey:@"leafDescrTypeCode"];
    [formTypeMiscDict setObject:branchLxCode forKey:@"branchLxCode"];
    [formTypeMiscDict setObject:leafLxCode forKey:@"leafLxCode"];
//    NSLog(@"analyseFormTypeRawData: %@ %@ %@ %@ %@", branchDescrTypeCode, leafDescrTypeCode, branchLxCode, leafLxCode, formTypeId);
    return formTypeMiscDict;    
}



@end
