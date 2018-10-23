//
//  GetRecordGenericBooleanTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBooleanTableViewCell.h"

@implementation GetRecordGenericBooleanTableViewCell
@synthesize contentString = _contentString;

- (void)dealloc {
    self.contentString = nil;
    
    [super dealloc];
}

- (IBAction)switchValueChanged:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    NSNumber* returnValue = sw.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    [self.delegate inputFinishedWithData:returnValue actualData:returnValue indexPath:self.indexPath];
}

- (void)configCellWithData:(NSMutableDictionary *)aData {
    [super configCellWithData:aData];
    GetRecordTypeGenericBaseObject* actualContentObject = [aData objectForKey:@"actualContent"];
    self.contentString.on = [actualContentObject.resultContent boolValue];
}

@end
