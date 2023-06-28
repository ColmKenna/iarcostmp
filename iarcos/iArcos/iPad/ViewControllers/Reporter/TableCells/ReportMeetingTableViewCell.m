//
//  ReportMeetingTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 17/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportMeetingTableViewCell.h"
#import "ArcosUtils.h"
@interface ReportMeetingTableViewCell()

- (NSString*)retrieveDatetime:(NSString*)aDatetimeStr;

@end

@implementation ReportMeetingTableViewCell
@synthesize reasonLabel = _reasonLabel;
@synthesize venueLabel = _venueLabel;
@synthesize typeLabel = _typeLabel;
@synthesize statusLabel = _statusLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.reasonLabel = nil;
    self.venueLabel = nil;
    self.typeLabel = nil;
    self.statusLabel = nil;
    
    [super dealloc];
}

-(void)setDataXML:(CXMLElement*)element{
    NSMutableDictionary* elementDict = [self convertElementToDict:element];
    /*
    for (int i = 0; i < element.childCount; i++) {
        if (![[element childAtIndex:i].name isEqualToString:@"text"] && [[element childAtIndex:i]stringValue] != nil) {
//            NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name, [ArcosUtils convertNSUIntegerToUnsignedInt:[[element childAtIndex:i].name length]],[[element childAtIndex:i]stringValue], [ArcosUtils convertNSUIntegerToUnsignedInt:[[[element childAtIndex:i] stringValue] length]]);
            
            [elementDict setObject:[[element childAtIndex:i] stringValue] forKey:[element childAtIndex:i].name];
        }
        
    }
    */
    NSString* dateTimeStr = [self retrieveDatetime:[elementDict objectForKey:@"Date"]];
    self.reasonLabel.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@", dateTimeStr, [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[elementDict objectForKey:@"Reason"]]]]];
    self.venueLabel.text = [elementDict objectForKey:@"Venue"];
    self.typeLabel.text = [elementDict objectForKey:@"Type"];
    self.statusLabel.text = [elementDict objectForKey:@"Status"];
}

- (NSString*)retrieveDatetime:(NSString*)aDatetimeStr {
    NSString* myResultDatetime = @"";
    @try {
        NSScanner* scanner = [NSScanner scannerWithString:aDatetimeStr];
        NSString* tFlag = @"T";
        NSString* plusFlag = @"+";
        NSString* hyphenFlag = @"-";
        NSString* colonFlag = @":";
        NSString* forwardSlashFlag = @"/";
        NSString* dateStr = @"";
        NSString* timeStr = @"";
        [scanner scanUpToString:tFlag intoString:&dateStr];
        [scanner scanString:tFlag intoString:nil];
        [scanner scanUpToString:plusFlag intoString:&timeStr];
        NSArray* dateList = [dateStr componentsSeparatedByString:hyphenFlag];
        NSArray* reversedDateList = [[dateList reverseObjectEnumerator] allObjects];
        NSString* resultDateStr = [reversedDateList componentsJoinedByString:forwardSlashFlag];
        NSArray* timeList = [timeStr componentsSeparatedByString:colonFlag];
        NSString* resultTimeStr = [NSString stringWithFormat:@"%@:%@", [timeList objectAtIndex:0], [timeList objectAtIndex:1]];
        myResultDatetime = [NSString stringWithFormat:@"%@ %@", resultDateStr, resultTimeStr];
    } @catch (NSException* exception) {
        myResultDatetime = @"";
    }
    return myResultDatetime;
}

@end
