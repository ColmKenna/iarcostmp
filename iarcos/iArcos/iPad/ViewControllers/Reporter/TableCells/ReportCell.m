//
//  ReportCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(NSMutableDictionary *)data{
    
}
-(void)setDataXML:(CXMLElement*)element{
    
}
- (NSString*)retrieveDate:(NSString*)aDateStr {
    NSString* myResultDate = @"";
    @try {
        NSString* hyphenFlag = @"-";
        NSString* forwardSlashFlag = @"/";
        NSArray* dateList = [aDateStr componentsSeparatedByString:hyphenFlag];
        NSArray* reversedDateList = [[dateList reverseObjectEnumerator] allObjects];
        myResultDate = [reversedDateList componentsJoinedByString:forwardSlashFlag];
    } @catch (NSException* exception) {
        myResultDate = @"";
    }
    return myResultDate;
}

- (NSMutableDictionary*)convertElementToDict:(CXMLElement*)anElement {
    NSMutableDictionary* auxElementDict = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i=0; i<anElement.childCount; i++) {
        
        if (![[anElement childAtIndex:i].name isEqualToString:@"text"]&&[[anElement childAtIndex:i]stringValue]!=nil) {
            //NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name,[[element childAtIndex:i].name length],[[element childAtIndex:i]stringValue],[[[element childAtIndex:i]stringValue]length]);
            
            [auxElementDict setObject:[ArcosUtils convertNilToEmpty:[[anElement childAtIndex:i]stringValue]] forKey:[ArcosUtils convertNilToEmpty:[anElement childAtIndex:i].name]];
        }
        
    }
    return auxElementDict;
}

@end
