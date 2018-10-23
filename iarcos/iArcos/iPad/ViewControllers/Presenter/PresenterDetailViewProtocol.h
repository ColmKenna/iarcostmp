//
//  PresenterDetailViewProtocol.h
//  Arcos
//
//  Created by David Kilmartin on 11/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PresenterDetailViewProtocol <NSObject>
-(void)resetResource:(NSMutableArray*)resource WithGrouType:(NSString*)type;
-(void)resetResource:(NSMutableArray*)resource;
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end
