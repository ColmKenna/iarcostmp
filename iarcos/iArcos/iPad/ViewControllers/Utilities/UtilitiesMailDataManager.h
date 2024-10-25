//
//  UtilitiesMailDataManager.h
//  iArcos
//
//  Created by Richard on 24/10/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosConstantsDataManager.h"
#import "ArcosUtils.h"

@interface UtilitiesMailDataManager : NSObject

- (void)renewPressedProcessor:(BOOL)aShowErrorMsgFlag errorMsg:(NSString*)anErrorMsg target:(UIViewController*)aTarget failedHandler:(void (^)(void))failedHandler successfulHandler:(void (^)(void))successfulHandler;

@end

