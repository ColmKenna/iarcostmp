//
//  ArcosQLPreviewItem.h
//  Arcos
//
//  Created by David Kilmartin on 16/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface ArcosQLPreviewItem : NSObject <QLPreviewItem> {
    NSURL* _myItemURL;
    NSString* _myItemTitle;
}

@property(nonatomic, retain) NSURL* myItemURL;
@property(nonatomic, retain) NSString* myItemTitle;

@end
