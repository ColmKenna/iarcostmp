//
//  LargeImageL5FormRowsDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 12/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeImageL5FormRowsDataManager.h"

@implementation LargeImageL5FormRowsDataManager
@synthesize displayList = _displayList;
@synthesize descrDetailCode = _descrDetailCode;
@synthesize currentPage = _currentPage;
@synthesize previousPage = _previousPage;
@synthesize slideViewItemList = _slideViewItemList;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];        
        self.slideViewItemList = [NSMutableArray array];
        self.currentPage = 0;
        self.previousPage = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.descrDetailCode != nil) { self.descrDetailCode = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }
    
    [super dealloc];
}

- (void)createLargeImageL5SlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {        
        LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
        
        [self.slideViewItemList addObject:LISVIC];
        [LISVIC release];
    }
}

- (void)createPlaceholderLargeImageL5SlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        [self.slideViewItemList addObject:[NSNull null]];
    }
}

- (void)fillLargeImageL5SlideViewItemWithIndex:(int)anIndex {
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndex];
    NSNumber* imageIur = [cellDataDict objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
//        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:99575]];
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
}

@end
