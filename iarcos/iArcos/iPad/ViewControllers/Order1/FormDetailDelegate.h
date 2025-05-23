//
//  FormDetailDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 06/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FormDetailDelegate <NSObject>

- (void)didSelectFormDetailRow:(NSDictionary*)cellData;
- (void)removeSubviewInOrderPadTemplate;
- (UIViewController*)retrieveCurrentViewController;
@end
