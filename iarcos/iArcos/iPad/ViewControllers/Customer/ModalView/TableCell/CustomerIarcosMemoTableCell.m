//
//  CustomerIarcosMemoTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosMemoTableCell.h"
#import "ArcosValidator.h"

@implementation CustomerIarcosMemoTableCell
@synthesize date;
@synthesize employee;
@synthesize contact;
@synthesize memo;
@synthesize memoType;
@synthesize indexPath;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.date = nil;
    self.employee = nil;
    self.contact = nil;
    self.memo = nil;
    self.memoType = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

-(void)configCellWithIndexPath:(NSIndexPath*) anIndexPath {
    self.indexPath = anIndexPath;
    self.memo.delegate = self;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate inputFinishedWithData:textView.text forIndexpath:self.indexPath];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UIViewController* tmpTarget = nil;
    if ([self.delegate respondsToSelector:@selector(retrieveParentViewController)]) {
        tmpTarget = [self.delegate retrieveParentViewController];
    }
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:[self.delegate retrieveParentViewController]];
}

@end
