//
//  QueryOrderDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 20/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderDetailTableCell.h"

@implementation QueryOrderDetailTableCell
@synthesize delegate = _delegate;
@synthesize dateLabel = _dateLabel;
@synthesize timeLabel = _timeLabel;
@synthesize detailsTextView = _detailsTextView;
@synthesize employeeLabel = _employeeLabel;
@synthesize contactLabel = _contactLabel;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self.detailsTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//    [self.detailsTextView.layer setBorderWidth:0.5];
    [self.detailsTextView.layer setCornerRadius:5.0f];
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.detailsTextView  addGestureRecognizer:doubleTap];
    doubleTap.delegate=self;
    [doubleTap release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.dateLabel = nil;
    self.timeLabel = nil;
    self.detailsTextView = nil;
    self.employeeLabel = nil;
    self.contactLabel = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer*)sender{
    [self.delegate customiseDoubleTapRecord:self.indexPath];
}

-(void)configCellWithData:(NSNumber*)heightData {
    self.detailsTextView.frame = CGRectMake(self.detailsTextView.frame.origin.x, self.detailsTextView.frame.origin.y, self.detailsTextView.frame.size.width, heightData.floatValue);
}

@end
