//
//  SmallImageL5FormRowsDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 14/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "SmallImageL5FormRowsDataManager.h"

@implementation SmallImageL5FormRowsDataManager
@synthesize displayList = _displayList;
@synthesize descrDetailCode = _descrDetailCode;
@synthesize slideViewItemList = _slideViewItemList;
@synthesize currentIndexPathRow = _currentIndexPathRow;


- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];        
        self.slideViewItemList = [NSMutableArray array];
        self.currentIndexPathRow = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.descrDetailCode != nil) { self.descrDetailCode = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }
    
    
    [super dealloc];
}

- (void)createSmallImageL5SlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {        
        SmallImageSlideViewItemController* SISVIC = [[SmallImageSlideViewItemController alloc]initWithNibName:@"SmallImageSlideViewItemController" bundle:nil];
        
        [self.slideViewItemList addObject:SISVIC];
        [SISVIC release];
    }
}

- (void)fillSmallImageL5SlideViewItemWithIndex:(int)anIndex {
    SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndex];
    aSISVIC.myLabel.text = [cellDataDict objectForKey:@"Detail"];
    NSNumber* imageIur = [cellDataDict objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        //        anImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [FileCommon photosPath],@"ArcosBrocuurePage0.png"]];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
//    anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:99575]];
    [aSISVIC.myButton setImage:anImage forState:UIControlStateNormal];
    if (isCompanyImage) {
        aSISVIC.myButton.alpha = [GlobalSharedClass shared].imageCellAlpha;
    } else {
        aSISVIC.myButton.alpha = 1.0;
    }
}

- (void)clearSmallImageL5SlideViewItemWithIndex:(int)anIndex {
    SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
//    [aSISVIC.myButton setImage:nil forState:UIControlStateNormal];    
    [aSISVIC clearContent];
}

@end
