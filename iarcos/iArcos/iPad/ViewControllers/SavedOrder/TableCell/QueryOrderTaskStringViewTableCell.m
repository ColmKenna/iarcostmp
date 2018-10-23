//
//  QueryOrderTaskStringViewTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskStringViewTableCell.h"

@implementation QueryOrderTaskStringViewTableCell
@synthesize fieldDesc = _fieldDesc;
@synthesize contentString = _contentString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    self.fieldDesc = nil;
    self.contentString = nil;
    
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self.contentString.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.contentString.layer setBorderWidth:0.5];
    [self.contentString.layer setCornerRadius:5.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
    self.contentString.text = [theData objectForKey:@"contentString"];
    
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.editable = YES;
        self.contentString.textColor = [UIColor blueColor];
    } else {
        self.contentString.editable = NO;
        self.contentString.textColor = [UIColor blackColor];
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate inputFinishedWithData:textView.text actualData:textView.text forIndexpath:self.indexPath];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger oldLength = [textView.text length];
    NSUInteger replacementLength = [text length];
    NSUInteger rangeLength = range.length;
    
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
//    NSLog(@"length: %d %d %d %d %@", oldLength, replacementLength, rangeLength, newLength, text);
    BOOL flag = newLength <= 250;
    return flag;
}

@end
