//
//  CustomerListingDataManager.m
//  iArcos
//
//  Created by Richard on 09/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerListingDataManager.h"

@implementation CustomerListingDataManager
@synthesize popoverOpenFlag = _popoverOpenFlag;
@synthesize useCallTableCellFlag = _useCallTableCellFlag;
@synthesize callHeaderHashMap = _callHeaderHashMap;
@synthesize textViewContentWidth = _textViewContentWidth;
@synthesize memoTextViewHeightHashMap = _memoTextViewHeightHashMap;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.popoverOpenFlag = NO;
        self.useCallTableCellFlag = NO;
        UIViewController* arcosRootViewController = [ArcosUtils getRootView];
        float width = arcosRootViewController.view.frame.size.width > arcosRootViewController.view.frame.size.height ? arcosRootViewController.view.frame.size.width : arcosRootViewController.view.frame.size.height;
        self.textViewContentWidth = (width - [GlobalSharedClass shared].mainMasterWidth) / 2.0 - 1 - 19 - 10 - 30;
//        NSLog(@"textViewContentWidth aa %f", self.textViewContentWidth);
    }
    return self;
}

- (void)dealloc {
    self.callHeaderHashMap = nil;
    self.memoTextViewHeightHashMap = nil;
    
    [super dealloc];
}

- (void)callHeaderProcessorWithDataList:(NSMutableArray*)aDataList {
    self.callHeaderHashMap = [NSMutableDictionary dictionary];
    NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    for (int i = 0; i < [aDataList count]; i++) {
        NSDictionary* tmpLocationDict = [aDataList objectAtIndex:i];
        [locationIURList addObject:[tmpLocationDict objectForKey:@"LocationIUR"]];
    }
    if ([locationIURList count] == 0) {
        return;
    }
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] retrieveOrderHeaderWithLocationIURList:locationIURList];
    if ([objectList count] == 0) {
        return;
    }
    for (int i = 0; i < [objectList count]; i++) {
        OrderHeader* tmpOrderHeader = [objectList objectAtIndex:i];
        if ([self.callHeaderHashMap objectForKey:tmpOrderHeader.LocationIUR] == nil) {
            [self.callHeaderHashMap setObject:tmpOrderHeader forKey:tmpOrderHeader.LocationIUR];
        }
    }
}

- (void)memoTextViewHeightProcessor {
//    NSLog(@"textViewContentWidth %f", self.textViewContentWidth);
    self.memoTextViewHeightHashMap = [NSMutableDictionary dictionaryWithCapacity:[self.callHeaderHashMap count]];
    NSArray* keyList = [self.callHeaderHashMap allKeys];
    for (int i = 0; i < [keyList count]; i++) {
        NSNumber* tmpLocationIUR = [keyList objectAtIndex:i];
        OrderHeader* tmpOrderHeader = [self.callHeaderHashMap objectForKey:tmpLocationIUR];
        float currentHeight = 0.0;
        float resultHeight = 0.0;
        
        if ([[ArcosUtils trim:[ArcosUtils convertNilToEmpty:tmpOrderHeader.memo.Details]] isEqualToString:@""]) {
            resultHeight = 0.0;
        } else {
            NSMutableAttributedString* attributedDetailsString = [[NSMutableAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:tmpOrderHeader.memo.Details] attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor systemOrangeColor]}];
            CGRect rect = [attributedDetailsString boundingRectWithSize:CGSizeMake(self.textViewContentWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            [attributedDetailsString release];
            currentHeight = rect.size.height + 16.0;
            resultHeight = (currentHeight > 37.0) ? currentHeight : 37.0;
        }
        [self.memoTextViewHeightHashMap setObject:[NSNumber numberWithFloat:resultHeight] forKey:tmpLocationIUR];
    }
//    NSLog(@"%@", self.memoTextViewHeightHashMap);
}

@end
