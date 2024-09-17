//
//  ArcosMailDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"
#import "ArcosMailDataUtils.h"
#import "ArcosCoreData.h"
#import "PresenterFileTypeConverter.h"

@interface ArcosMailDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _defaultTitleText;
    NSString* _subjectText;
    NSString* _bodyText;
    BOOL _isHTML;
    NSMutableArray* _toRecipients;
    NSMutableArray* _ccRecipients;
    NSMutableArray* _attachmentList;
    ArcosMailDataUtils* _arcosMailDataUtils;
    NSString* _bodyTitleText;    
    BOOL _largeAttachmentFlag;
    int _minLargeAttachmentSize;
    NSString* _messageId;
    NSNumber* _largeFileSize;
    NSString* _uploadURL;
    int _startIndex;
    int _endIndex;
    int _fileChunkSize;
    BOOL _showSignatureFlag;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* defaultTitleText;
@property(nonatomic,retain) NSString* subjectText;
@property(nonatomic,retain) NSString* bodyText;
@property(nonatomic,assign) BOOL isHTML;
@property(nonatomic,retain) NSMutableArray* toRecipients;
@property(nonatomic,retain) NSMutableArray* ccRecipients;
@property(nonatomic,retain) NSMutableArray* attachmentList;
@property(nonatomic,retain) ArcosMailDataUtils* arcosMailDataUtils;
@property(nonatomic,retain) NSString* bodyTitleText;
@property(nonatomic,assign) BOOL largeAttachmentFlag;
@property(nonatomic,assign) int minLargeAttachmentSize;
@property(nonatomic,retain) NSString* messageId;
@property(nonatomic,retain) NSNumber* largeFileSize;
@property(nonatomic,retain) NSString* uploadURL;
@property(nonatomic,assign) int startIndex;
@property(nonatomic,assign) int endIndex;
@property(nonatomic,assign) int fileChunkSize;
@property(nonatomic,assign) BOOL showSignatureFlag;

- (void)createBasicData;
- (NSDictionary*)retrieveDescrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode;
- (NSIndexPath*)retrieveIndexPathWithTitle:(NSString*)aTitle;

@end
