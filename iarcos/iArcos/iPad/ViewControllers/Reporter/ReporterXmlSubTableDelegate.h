//
//  ReporterXmlSubTableDelegate.h
//  iArcos
//
//  Created by Richard on 06/02/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ReporterXmlSubTableDelegate <NSObject>

- (void)subTableFooterPressed;
- (void)subTableRowPressedWithLinkIUR:(NSString *)aLinkIUR;

@end

