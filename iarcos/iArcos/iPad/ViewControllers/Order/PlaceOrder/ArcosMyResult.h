//
//  ArcosMyResult.h
//  iArcos
//
//  Created by Richard on 19/07/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "ArcosValidator.h"

@interface ArcosMyResult : NSObject {
//    int _uni;
//    int _ud;
    NSNumber* _max;
}

//@property(nonatomic, assign) int uni;
//@property(nonatomic, assign) int ud;
@property(nonatomic, retain) NSNumber* max;

- (void)processRawData:(NSString*)aProductColour;

@end

