//
//  PresenterFileTypeConverter.m
//  iArcos
//
//  Created by David Kilmartin on 26/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PresenterFileTypeConverter.h"

@implementation PresenterFileTypeConverter

//9 == 1  url
//1,2,6,7,8,10,12 == 2 file

+ (int)retrieveCustomizedFileType:(NSNumber*)aFileType {
    int result = -1;
    switch ([aFileType intValue]) {
        case 9:
            result = 1;
            break;
        case 1:
        case 2:
        case 6:
        case 7:
        case 8:
        case 10:
        case 12: {
            result = 2;
        }
            break;
        default:
            break;
    }
    return result;
}

@end
