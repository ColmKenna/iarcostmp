//
//  GetRecordGenericIntTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericIntTableViewCell.h"
#import "ArcosValidator.h"

@implementation GetRecordGenericIntTableViewCell
@synthesize contentString = _contentString;

- (void)dealloc {
    self.contentString = nil;
    
    [super dealloc];
}

- (IBAction)textInputEnded:(id)sender {
    UITextField* tf = (UITextField*)sender;
    [self.delegate inputFinishedWithData:tf.text actualData:[ArcosUtils convertStringToNumber:tf.text] indexPath:self.indexPath];
}

- (void)configCellWithData:(NSMutableDictionary *)aData {
    [super configCellWithData:aData];
    GetRecordTypeGenericBaseObject* actualContentObject = [aData objectForKey:@"actualContent"];
    self.contentString.text = [actualContentObject retrieveStringValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* tmpTextFieldStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return ([ArcosValidator isInteger:tmpTextFieldStr] || [string isEqualToString:@""]);
}

@end
