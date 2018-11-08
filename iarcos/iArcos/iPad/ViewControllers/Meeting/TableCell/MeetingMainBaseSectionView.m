//
//  MeetingMainBaseSectionView.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainBaseSectionView.h"

@implementation MeetingMainBaseSectionView
@synthesize sectionTitleLabel = _sectionTitleLabel;

- (void)dealloc {
    self.sectionTitleLabel = nil;
    
    [super dealloc];
}

- (void)configSectionViewWithData:(NSMutableDictionary*)aViewData {
    self.sectionTitleLabel.text = [aViewData objectForKey:@"SectionTitle"];
}

@end
