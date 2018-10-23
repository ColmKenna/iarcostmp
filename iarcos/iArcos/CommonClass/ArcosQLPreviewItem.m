//
//  ArcosQLPreviewItem.m
//  Arcos
//
//  Created by David Kilmartin on 16/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosQLPreviewItem.h"

@implementation ArcosQLPreviewItem
@synthesize myItemURL = _myItemURL;
@synthesize myItemTitle = _myItemTitle;

- (void)dealloc {
    if (self.myItemURL != nil) { self.myItemURL = nil; }
    if (self.myItemTitle != nil) { self.myItemTitle = nil; }
    
    [super dealloc];
}

- (NSURL*)previewItemURL {
    return self.myItemURL;
}

- (NSString*)previewItemTitle {
    return self.myItemTitle;
}

@end
