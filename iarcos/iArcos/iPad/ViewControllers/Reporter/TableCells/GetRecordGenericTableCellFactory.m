//
//  GetRecordGenericTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericTableCellFactory.h"
@interface GetRecordGenericTableCellFactory()

- (GetRecordGenericBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier;

@end

@implementation GetRecordGenericTableCellFactory

+ (instancetype)factory {
    return [[[self alloc] init] autorelease];
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    int fieldTypeCode = [[aData objectForKey:@"fieldTypeCode"] intValue];
    NSString* identifier = nil;
    switch (fieldTypeCode) {
        case 0:
            identifier = @"IdGetRecordGenericIURTableViewCell";
            break;
        case 1:
            identifier = @"IdGetRecordGenericStringTableViewCell";
            break;
        case 2:
            identifier = @"IdGetRecordGenericBooleanTableViewCell";
            break;
        case 3:
            identifier = @"IdGetRecordGenericDateTableViewCell";
            break;
        case 4:
            identifier = @"IdGetRecordGenericIntTableViewCell";
            break;
        case 5:
            identifier = @"IdGetRecordGenericDecimalTableViewCell";
            break;
            
        default:
            identifier = @"IdGetRecordGenericStringTableViewCell";
            break;
    }
    return identifier;
}

- (GetRecordGenericBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    GetRecordGenericBaseTableViewCell* cell = nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GetRecordGenericTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[GetRecordGenericBaseTableViewCell class]] && [[(GetRecordGenericBaseTableViewCell *)nibItem reuseIdentifier] isEqualToString: anIdendifier]) {
            cell = nibItem;
            break;
        }
    }
    return cell;
}

- (GetRecordGenericBaseTableViewCell*)createGetRecordGenericBaseTableViewCellWithData:(NSMutableDictionary*)aData {
    return (GetRecordGenericBaseTableViewCell*)[self getCellWithIdentifier:[self identifierWithData:aData]];
}

@end
