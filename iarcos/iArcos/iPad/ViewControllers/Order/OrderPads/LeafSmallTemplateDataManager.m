//
//  LeafSmallTemplateDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 19/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LeafSmallTemplateDataManager.h"

@implementation LeafSmallTemplateDataManager
@synthesize displayList = _displayList;
@synthesize branchDetail = _branchDetail;
@synthesize branchDescrDetailCode = _branchDescrDetailCode;
@synthesize slideViewItemList = _slideViewItemList;
@synthesize currentPage = _currentPage;
@synthesize itemPerPage = _itemPerPage;
@synthesize previousPage = _previousPage;
@synthesize bufferSize = _bufferSize;
@synthesize halfBufferSize = _halfBufferSize;
@synthesize pagedDisplayList = _pagedDisplayList;
@synthesize branchLeafMiscUtils = _branchLeafMiscUtils;
@synthesize pageIndexList = _pageIndexList;
@synthesize pageIndexDict = _pageIndexDict;
@synthesize branchLxCode = _branchLxCode;
@synthesize leafLxCode = _leafLxCode;
@synthesize selectedIndexPath = _selectedIndexPath;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];        
        self.slideViewItemList = [NSMutableArray array];
        self.currentPage = 0;
        self.itemPerPage = 6;
        self.previousPage = 0;
        self.bufferSize = 7;
        self.halfBufferSize = self.bufferSize / 2;
        self.pagedDisplayList = [NSMutableArray array];        
        self.branchLeafMiscUtils = [[[BranchLeafMiscUtils alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.branchDetail != nil) { self.branchDetail = nil; }
    if (self.branchDescrDetailCode != nil) { self.branchDescrDetailCode = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }
    if (self.pagedDisplayList != nil) { self.pagedDisplayList = nil; }
    if (self.branchLeafMiscUtils != nil) { self.branchLeafMiscUtils = nil; }
    if (self.pageIndexList != nil) { self.pageIndexList = nil; }
    if (self.pageIndexDict != nil) { self.pageIndexDict = nil; }
    if (self.branchLxCode != nil) { self.branchLxCode = nil; }
    if (self.leafLxCode != nil) { self.leafLxCode = nil; }
    if (self.selectedIndexPath != nil) { self.selectedIndexPath = nil; }    
    
    [super dealloc];
}

- (void)createLeafSmallTemplateViewItemData {
    self.pagedDisplayList = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [self.displayList count]; i++) {
        [subsetDisplayList addObject:[self.displayList objectAtIndex:i]];
        if ((i + 1) % self.itemPerPage == 0) {
            [self.pagedDisplayList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [self.pagedDisplayList addObject:subsetDisplayList];        
    }
    /*
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.pagedDisplayList count]];
    for (int i = 0; i < [self.pagedDisplayList count]; i++) {
        LeafSmallTemplateViewItemController* LSTVIC = [[LeafSmallTemplateViewItemController alloc] initWithNibName:@"LeafSmallTemplateViewItemController" bundle:nil];
        LSTVIC.indexPathRow = i;
        LSTVIC.itemPerPage = self.itemPerPage;
        [self.slideViewItemList addObject:LSTVIC];
        [LSTVIC release];
    }
     */
}

- (void)fillLeafSmallTemplateViewItemWithIndex:(int)anIndex {
    LeafSmallTemplateViewItemController* anLSTVIC = [self.slideViewItemList objectAtIndex:anIndex];
    NSMutableArray* subsetDisplayList = [self.pagedDisplayList objectAtIndex:anIndex];
    [anLSTVIC getCellReadyToUse];    
    for (int i = 0; i < [subsetDisplayList count]; i++) {
        NSMutableDictionary* descrDetailDict = [subsetDisplayList objectAtIndex:i];
        UILabel* tmpLabel = [anLSTVIC.labelList objectAtIndex:i];        
        tmpLabel.text = [descrDetailDict objectForKey:@"Detail"];
        NSNumber* imageIur = [descrDetailDict objectForKey:@"ImageIUR"];
        NSMutableDictionary* imageDict = [self.branchLeafMiscUtils getImageWithImageIUR:imageIur];
        UIButton* tmpBtn = [anLSTVIC.btnList objectAtIndex:i];
        tmpBtn.enabled = YES;
        [tmpBtn setImage:[imageDict objectForKey:@"ImageObj"] forState:UIControlStateNormal];
//        if ([[imageDict objectForKey:@"CompanyImage"] boolValue]) {
//            tmpBtn.alpha = [GlobalSharedClass shared].imageCellAlpha;
//        } else {
//            tmpBtn.alpha = 1.0;
//        }
    }
}

- (void)createPlaceholderLeafSmallTemplateViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.pagedDisplayList count]];
    for (int i = 0; i < [self.pagedDisplayList count]; i++) {
        [self.slideViewItemList addObject:[NSNull null]];
    }
}

- (void)createPageIndexList:(int)aFormTypeNumber {
    self.pageIndexList = [NSMutableArray array];
    self.pageIndexDict = [NSMutableDictionary dictionary];
    if ([self.displayList count] == 0 || aFormTypeNumber == [[GlobalSharedClass shared].formRowFormTypeNumber intValue]) return;
    NSString* currentChar = @"";
    if ([self.displayList count] > 0) {
        NSMutableDictionary* aDescrDetailDict = [self.displayList objectAtIndex:0];
        NSString* detail = [aDescrDetailDict objectForKey:@"Detail"];
        if (detail != nil) {
            if ([detail length] >= 1) {
                currentChar = [detail substringToIndex:1];
            } else {
                currentChar = @" ";
            }            
        }
        [self.pageIndexList addObject:currentChar];
        [self.pageIndexDict setObject:[NSNumber numberWithInt:0] forKey:currentChar];
    }
    for (int i = 1; i < [self.displayList count]; i++) {
        NSMutableDictionary* aDescrDetailDict = [self.displayList objectAtIndex:i];
        NSString* detail = [aDescrDetailDict objectForKey:@"Detail"];        
        if (detail == nil || [detail isEqualToString:@""]) {
            detail = @" ";
        }
        if ([currentChar caseInsensitiveCompare:[detail substringToIndex:1]]==NSOrderedSame) {            
            
        } else {
            //get the current char
            currentChar = [detail substringToIndex:1];
            [self.pageIndexList addObject:currentChar];
            int pageNumber = i / self.itemPerPage;
            [self.pageIndexDict setObject:[NSNumber numberWithInt:pageNumber] forKey:currentChar];
        }
    }    
}

@end
