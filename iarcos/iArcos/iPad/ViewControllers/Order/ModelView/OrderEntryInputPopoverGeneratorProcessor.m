//
//  OrderEntryInputPopoverGeneratorProcessor.m
//  iArcos
//
//  Created by Apple on 11/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputPopoverGeneratorProcessor.h"

@implementation OrderEntryInputPopoverGeneratorProcessor

- (UIPopoverController*)createOrderPopoverWithLocationIUR:(NSNumber*)aLocationIUR factory:(WidgetFactory*)aWidgetFactory {
    return [aWidgetFactory CreateOrderEntryInputWidgetWithLocationIUR:aLocationIUR];
}

@end
