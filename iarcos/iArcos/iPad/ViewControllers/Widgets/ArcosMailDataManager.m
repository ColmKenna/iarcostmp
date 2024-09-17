//
//  ArcosMailDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailDataManager.h"

@implementation ArcosMailDataManager
@synthesize displayList = _displayList;
@synthesize defaultTitleText = _defaultTitleText;
@synthesize subjectText = _subjectText;
@synthesize bodyText = _bodyText;
@synthesize isHTML = _isHTML;
@synthesize toRecipients = _toRecipients;
@synthesize ccRecipients = _ccRecipients;
@synthesize attachmentList = _attachmentList;
@synthesize arcosMailDataUtils = _arcosMailDataUtils;
@synthesize bodyTitleText = _bodyTitleText;
@synthesize largeAttachmentFlag = _largeAttachmentFlag;
@synthesize minLargeAttachmentSize = _minLargeAttachmentSize;
@synthesize messageId = _messageId;
@synthesize largeFileSize = _largeFileSize;
@synthesize uploadURL = _uploadURL;
@synthesize startIndex = _startIndex;
@synthesize endIndex = _endIndex;
@synthesize fileChunkSize = _fileChunkSize;
@synthesize showSignatureFlag = _showSignatureFlag;

- (instancetype)init {
    if(self = [super init]) {
        self.defaultTitleText = @"New Message";
        self.arcosMailDataUtils = [[[ArcosMailDataUtils alloc] init] autorelease];
        self.bodyTitleText = @"Body:";
        self.subjectText = @"";
        self.bodyText = @"";
        self.toRecipients = [NSMutableArray array];
        self.ccRecipients = [NSMutableArray array];
        self.attachmentList = [NSMutableArray array];
        self.minLargeAttachmentSize = 3 * 1024 * 1024 - 10000;
        self.messageId = @"";
        self.largeFileSize = [NSNumber numberWithInt:0];
        self.uploadURL = @"";
        self.startIndex = 0;
        self.endIndex = 0;
        self.fileChunkSize = 2 * 1024 * 1024;
        self.showSignatureFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.defaultTitleText = nil;
    self.subjectText = nil;
    self.bodyText = nil;
    self.toRecipients = nil;
    self.ccRecipients = nil;
    self.attachmentList = nil;
    self.arcosMailDataUtils = nil;
    self.bodyTitleText = nil;
    self.messageId = nil;
    self.largeFileSize = nil;
    self.uploadURL = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:4];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldDesc:@"To:" fieldData:self.toRecipients]];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldDesc:@"Cc:" fieldData:self.ccRecipients]];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:2] fieldDesc:@"Subject:" fieldData:[ArcosUtils convertNilToEmpty:self.subjectText]]];
    
    NSMutableDictionary* bodyDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [bodyDataDict setObject:[ArcosUtils convertNilToEmpty:self.bodyText] forKey:@"Content"];
    NSMutableDictionary* resultDict = [self.arcosMailDataUtils calculateHeightWithText:self.bodyText];
    [bodyDataDict setObject:[resultDict objectForKey:@"TextViewHeight"] forKey:@"TextViewHeight"];
    [bodyDataDict setObject:[resultDict objectForKey:@"CellHeight"] forKey:@"CellHeight"];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] fieldDesc:self.bodyTitleText fieldData:bodyDataDict isHTML:self.isHTML]];
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldDesc:(NSString*)aFieldDesc fieldData:(id)aFieldData {
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:aCellType forKey:@"CellType"];
    [cellDataDict setObject:aFieldDesc forKey:@"FieldDesc"];
    [cellDataDict setObject:aFieldData forKey:@"FieldData"];
    
    return cellDataDict;
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldDesc:(NSString*)aFieldDesc fieldData:(id)aFieldData isHTML:(BOOL)anIsHTML {
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithDictionary:[self createCellDataWithCellType:aCellType fieldDesc:aFieldDesc fieldData:aFieldData]];
    [cellDataDict setObject:[NSNumber numberWithBool:anIsHTML] forKey:@"IsHTML"];
    
    return cellDataDict;
}

- (NSDictionary*)retrieveDescrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode ENDSWITH %@", aDescrTypeCode, aDescrDetailCode];
    NSMutableArray* resultList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([resultList count] > 0) {
        return [resultList objectAtIndex:0];
    }
    return nil;
}

- (NSIndexPath*)retrieveIndexPathWithTitle:(NSString*)aTitle {
    int index = 0;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* auxCellData = [self.displayList objectAtIndex:i];
        NSString* auxFieldDesc = [auxCellData objectForKey:@"FieldDesc"];
        if ([aTitle isEqualToString:auxFieldDesc]) {
            index = i;
            continue;
        }
    }
    return [NSIndexPath indexPathForRow:index inSection:0];
}

@end
