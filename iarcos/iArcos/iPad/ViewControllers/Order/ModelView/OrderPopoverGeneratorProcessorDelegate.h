//
//  OrderPopoverGeneratorProcessorDelegate.h
//  iArcos
//
//  Created by Apple on 11/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetFactory.h"

@protocol OrderPopoverGeneratorProcessorDelegate <NSObject>

- (UIPopoverController*)createOrderPopoverWithLocationIUR:(NSNumber*)aLocationIUR factory:(WidgetFactory*)aWidgetFactory;

@end

