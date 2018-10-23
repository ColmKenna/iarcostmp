//
//  TwoBigImageLevelCodeDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwoBigImageLevelCodeDelegate <NSObject>
-(void)bigImageLevelCodeWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath;
@end
