//
//  ArcosAttachmentContainer.m
//  iArcos
//
//  Created by Apple on 01/01/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "ArcosAttachmentContainer.h"

@implementation ArcosAttachmentContainer
@synthesize fileName = _fileName;
@synthesize fileData = _fileData;

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithData:(NSData*)aData fileName:(NSString*)aFileName {
    self = [super init];
    if (self) {
        self.fileData = aData;
        self.fileName = aFileName;
    }
    return self;
}

+ (ArcosAttachmentContainer*)attachmentWithData:(NSData*)aData fileName:(NSString*)aFileName {
    return [[[ArcosAttachmentContainer alloc] initWithData:aData fileName:aFileName] autorelease];
}

- (void)dealloc {
    self.fileName = nil;
    self.fileData = nil;
    
    [super dealloc];
}

@end
