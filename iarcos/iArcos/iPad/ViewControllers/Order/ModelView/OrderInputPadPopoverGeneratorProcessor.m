//
//  OrderInputPadPopoverGeneratorProcessor.m
//  iArcos
//
//  Created by Apple on 11/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderInputPadPopoverGeneratorProcessor.h"

@implementation OrderInputPadPopoverGeneratorProcessor

- (WidgetViewController*)createOrderPopoverWithLocationIUR:(NSNumber*)aLocationIUR factory:(WidgetFactory*)aWidgetFactory {
    return [aWidgetFactory CreateOrderInputPadWidgetWithLocationIUR:aLocationIUR];
}

@end
