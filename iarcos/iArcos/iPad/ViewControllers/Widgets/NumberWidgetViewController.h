//
//  NumberWidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
typedef enum {
    NumberIntType = 0,
    NumberDecimalType = 1,
    NumberPrecentageType = 2
} NumberWidgetType;

@interface NumberWidgetViewController : WidgetViewController {
    
}

@end
