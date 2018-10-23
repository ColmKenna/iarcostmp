//
//  OrderProductTableCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 02/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderProductTableCellDelegate <NSObject>

- (void)displayBigProductImageWithProductCode:(NSString*)aProductCode;
- (void)displayProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath*)anIndexPath;
@optional
- (void)toggleShelfImageWithData:(NSMutableDictionary*)aCellData;

@end
