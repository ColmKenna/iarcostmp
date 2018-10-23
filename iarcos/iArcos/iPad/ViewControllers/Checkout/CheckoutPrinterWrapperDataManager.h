//
//  CheckoutPrinterWrapperDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 24/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CheckoutPrinterWrapperDataManager : NSObject {
    NSString* _fieldDelimiter;
}

@property(nonatomic, retain) NSString* fieldDelimiter;

- (void)saveSignatureWithOrderNumber:(NSNumber*)anOrderNumber dataList:(NSMutableArray*)aDataList;
- (NSMutableArray*)retrieveDataList:(NSNumber*)anOrderNumber;

@end
