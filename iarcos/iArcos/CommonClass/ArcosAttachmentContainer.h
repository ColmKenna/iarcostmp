//
//  ArcosAttachmentContainer.h
//  iArcos
//
//  Created by Apple on 01/01/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArcosAttachmentContainer : NSObject {
    NSString* _fileName;
    NSData* _fileData;
}

@property(nonatomic, retain) NSString* fileName;
@property(nonatomic, retain) NSData* fileData;

- (instancetype)initWithData:(NSData*)aData fileName:(NSString*)aFileName;
+ (ArcosAttachmentContainer*)attachmentWithData:(NSData*)aData fileName:(NSString*)aFileName;

@end


