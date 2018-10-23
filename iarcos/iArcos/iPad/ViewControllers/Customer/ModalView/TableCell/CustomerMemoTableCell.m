//
//  CustomerMemoTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerMemoTableCell.h"


@implementation CustomerMemoTableCell
@synthesize date;
@synthesize employee;
@synthesize contact;
@synthesize memo;
@synthesize bgImageView;
@synthesize subBgImageView = _subBgImageView;
@synthesize dateImageView;
@synthesize verticalImageView;
@synthesize horizontalImageView;
@synthesize memoType;
@synthesize indexPath;
@synthesize delegate;

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

- (void)dealloc
{
    if (self.date != nil) { self.date = nil; }
    if (self.employee != nil) { self.employee = nil; }
    if (self.contact != nil) { self.contact = nil; }
    if (self.memo != nil) { self.memo = nil; }    
    if (self.bgImageView != nil) { self.bgImageView = nil; }
    self.subBgImageView = nil;
    if (self.dateImageView != nil) { self.dateImageView = nil; }
    if (self.verticalImageView != nil) { self.verticalImageView = nil; }
    if (self.horizontalImageView != nil) { self.horizontalImageView = nil; } 
    if (self.memoType != nil) { self.memoType = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    
    [super dealloc];
    
//    [date release];
//    [employee release];
//    [contact release];
//    [memo release];
//    [bgImageView release];   
}

-(void)configCellWithIndexPath:(NSIndexPath*) anIndexPath {
    self.indexPath = anIndexPath;
    self.memo.delegate = self;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate inputFinishedWithData:textView.text forIndexpath:self.indexPath];
}

@end
