//
//  FileMD5Calculator.h
//  iArcos
//
//  Created by David Kilmartin on 10/07/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileMD5Calculator : NSObject

- (NSString*)retrieveFileMD5WithFilePath:(NSString*)aFilePath;

@end
