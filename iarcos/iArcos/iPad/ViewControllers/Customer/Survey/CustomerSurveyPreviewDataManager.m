//
//  CustomerSurveyPreviewDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 20/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyPreviewDataManager.h"

@implementation CustomerSurveyPreviewDataManager
@synthesize displayList = _displayList;
@synthesize slideViewItemList = _slideViewItemList;
@synthesize currentPage = _currentPage;

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];
        self.slideViewItemList = [NSMutableArray array]; 
        self.currentPage = 0;
    }
    
    return self;
}

-(void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }
    
    [super dealloc];
}

- (void)createPhotoSlideBasicDataWithAnswer:(NSString*)anAnswer {
    self.displayList = [NSMutableArray array];
    if ([anAnswer isEqualToString:@""]) return;
    NSArray* fileNameList = [anAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
    for (int i = 0; i < [fileNameList count]; i++) {
        NSString* fileName = [fileNameList objectAtIndex:i];
        [self.displayList addObject:fileName];
    }
}


- (void)createPhotoSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        PresenterSlideViewItemController* PSVIC = [[PresenterSlideViewItemController alloc] initWithNibName:@"PresenterSlideViewItemController" bundle:nil];        
        [self.slideViewItemList addObject:PSVIC];
        [PSVIC release];
    }
}

- (NSString*)filePathWithFileName:(NSString*)aFileName {
    return [NSString stringWithFormat:@"%@/%@", [FileCommon surveyPath], aFileName];
}

- (void)fillPhotoSlideViewItem:(PresenterSlideViewItemController*)psvic index:(int)anIndex {
    NSString* fileName = [self.displayList objectAtIndex:anIndex];
    NSString* filePath = [self filePathWithFileName:fileName];
    UIImage* anImage = [UIImage imageWithContentsOfFile:filePath];
    PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    aPSVIC.myImage.image = anImage;
}

- (void)emptyPhotoSlideViewItemWithIndex:(int)anIndex {
    for (int i = 0; i < [self.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.slideViewItemList objectAtIndex:i];
        aPSVIC.myImage.image = nil;
    }
}

@end
