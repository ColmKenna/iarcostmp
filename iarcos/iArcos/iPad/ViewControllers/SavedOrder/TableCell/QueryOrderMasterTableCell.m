//
//  QueryOrderMasterTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 20/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderMasterTableCell.h"

@implementation QueryOrderMasterTableCell
@synthesize delegate = _delegate;
@synthesize nameLabel = _nameLabel;
@synthesize addressLabel = _addressLabel;
@synthesize detailsTextView = _detailsTextView;
@synthesize dateLabel = _dateLabel;
@synthesize timeLabel = _timeLabel;
@synthesize indexPath = _indexPath;
@synthesize closeImageView = _closeImageView;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self.detailsTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.detailsTextView.layer setBorderWidth:0.5];
    [self.detailsTextView.layer setCornerRadius:5.0f];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.detailsTextView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.detailsTextView  addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    singleTap.delegate=self;
    doubleTap.delegate=self;
    [singleTap release];
    [doubleTap release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    self.nameLabel = nil;
    self.addressLabel = nil;
    self.detailsTextView = nil;
    self.dateLabel = nil;
    self.timeLabel = nil;
    self.indexPath = nil;
    self.closeImageView = nil;
    
    [super dealloc];
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    [self.delegate selectQueryOrderMasterTableCellRecord:self.indexPath];
    return NO;
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender{
    [self.delegate selectQueryOrderMasterTableCellRecord:self.indexPath];
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer*)sender{
    [self.delegate doubleTapQueryOrderMasterTableCellRecord:self.indexPath];
}

-(void)configCellWithData:(NSNumber*)heightData {
    self.detailsTextView.frame = CGRectMake(self.detailsTextView.frame.origin.x, self.detailsTextView.frame.origin.y, self.detailsTextView.frame.size.width, heightData.floatValue);
}

@end
