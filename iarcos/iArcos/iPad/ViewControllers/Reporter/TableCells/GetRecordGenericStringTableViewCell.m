//
//  GetRecordGenericStringTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericStringTableViewCell.h"

@implementation GetRecordGenericStringTableViewCell
@synthesize contentString = _contentString;


- (void)dealloc {
    self.contentString = nil;
    
    [super dealloc];
}

- (IBAction)textInputEnded:(id)sender {
    UITextField* tf = (UITextField*)sender;
    [self.delegate inputFinishedWithData:tf.text actualData:tf.text indexPath:self.indexPath];
}

- (void)configCellWithData:(NSMutableDictionary *)aData {
    [super configCellWithData:aData];
    self.contentString.text = [aData objectForKey:@"contentString"];
}

@end
