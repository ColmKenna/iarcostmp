//
//  PriceChangeDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceChangeDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableDictionary* _dataDict;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableDictionary* dataDict;

- (void)processRawData;
- (void)updateDataWithData:(NSString*)aData forIndexPath:(NSIndexPath*)theIndexPath;

@end
