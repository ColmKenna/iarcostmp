//
//  FileSharedClass.h
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface FileSharedClass : NSObject {
    
}
+ (FileSharedClass *)sharedFileSharedClass;
-(id)init;

-(BOOL)createFolder:(NSString*)folderName;
-(BOOL)fileExistInFolder:(NSString*)folderName withFileName:(NSString*)fileName;
-(BOOL)saveFileToFolder:(NSString*)folderName withName:(NSString*)fileName withData:(NSData*)data;
@end
