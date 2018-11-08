//
//  MeetingMainSectionViewFactory.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainSectionViewFactory.h"

@implementation MeetingMainSectionViewFactory

- (MeetingMainBaseSectionView*)getSectionViewWithData:(NSMutableDictionary*)aSectionData {
    MeetingMainBaseSectionView* sectionView = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingMainHeaderFooterViews" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        NSNumber* tagTypeNumber = [aSectionData objectForKey:@"TagType"];
        if ([nibItem isKindOfClass:[MeetingMainBaseSectionView class]] && [(MeetingMainBaseSectionView*)nibItem tag] == [tagTypeNumber integerValue]) {
            sectionView = (MeetingMainBaseSectionView*)nibItem;
            break;
        }
    }
    return sectionView;
}

@end
