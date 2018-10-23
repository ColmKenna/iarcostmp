//
//  OrderDetailTextViewTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailTextViewTableCell.h"
#import "ArcosValidator.h"

@implementation OrderDetailTextViewTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextView = _fieldValueTextView;
@synthesize isStyleSet = _isStyleSet;

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

- (void)dealloc {    
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueTextView != nil) { self.fieldValueTextView = nil; }        
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {    
    if (!self.isStyleSet) {
        [self.fieldValueTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.fieldValueTextView.layer setBorderWidth:0.5];
        [self.fieldValueTextView.layer setCornerRadius:5.0f];
        self.isStyleSet = YES;
    }    
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    self.fieldValueTextView.text = [theData objectForKey:@"FieldData"];
    if (self.isNotEditable) {
        self.fieldValueTextView.textColor = [UIColor blackColor];
        self.fieldValueTextView.editable = NO;
    } else {
        self.fieldValueTextView.textColor = [UIColor blueColor];
        self.fieldValueTextView.editable = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate inputFinishedWithData:[ArcosUtils trim:textView.text] forIndexpath:self.indexPath];    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UIViewController* tmpTarget = nil;
    if ([self.delegate respondsToSelector:@selector(retrieveParentViewController)]) {
        tmpTarget = [self.delegate retrieveParentViewController];
    }
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:tmpTarget];
}

@end
