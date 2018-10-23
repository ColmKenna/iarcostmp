//
//  EditOperationViewControllerDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 25/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditOperationViewControllerDelegate <NSObject>

@optional
- (void)editFinishedWithData:(id)contentString fieldName:(NSString*)fieldName forIndexpath:(NSIndexPath*)theIndexpath;
@end
