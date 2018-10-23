//
//  ArcosMailCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailCellFactory.h"
@interface ArcosMailCellFactory ()

- (ArcosMailBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdentifier;

@end

@implementation ArcosMailCellFactory
@synthesize recipientTableViewCellId = _recipientTableViewCellId;
@synthesize subjectTableViewCellId = _subjectTableViewCellId;
@synthesize bodyTableViewCellId = _bodyTableViewCellId;

- (instancetype)init {
    if(self = [super init]) {
        self.recipientTableViewCellId = @"IdArcosMailRecipientTableViewCell";
        self.subjectTableViewCellId = @"IdArcosMailSubjectTableViewCell";
        self.bodyTableViewCellId = @"IdArcosMailBodyTableViewCell";
    }
    return self;
}

+ (instancetype)factory {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.recipientTableViewCellId = nil;
    self.subjectTableViewCellId = nil;
    self.bodyTableViewCellId = nil;
    
    [super dealloc];
}

- (ArcosMailBaseTableViewCell*)createMailBaseTableCellWithData:(NSMutableDictionary*)aDataDict {
    return [self getCellWithIdentifier:[self identifierWithData:aDataDict]];
}

- (ArcosMailBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdentifier {
    ArcosMailBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ArcosMailTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[ArcosMailBaseTableViewCell class]] && [[(ArcosMailBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString: anIdentifier]) {
            cell = (ArcosMailBaseTableViewCell*)nibItem;
            break;
        }
    }    
    return cell;
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aDataDict {
    NSNumber* cellType = [aDataDict objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 1:
            identifier = self.recipientTableViewCellId;
            break;
        case 2:
            identifier = self.subjectTableViewCellId;
            break;
        case 3:
            identifier = self.bodyTableViewCellId;
            break;
            
        default:
            identifier = self.recipientTableViewCellId;
            break;
    }
    return identifier;
}

@end
