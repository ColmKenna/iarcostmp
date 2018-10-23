//
//  CustomerNewsTaskTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerNewsTaskTableCell.h"

@implementation CustomerNewsTaskTableCell
@synthesize actionDelegate = _actionDelegate;
@synthesize myTitle = _myTitle;
@synthesize myDetails = _myDetails;
@synthesize linkAddress = _linkAddress;
@synthesize type = _type;
//@synthesize arcosGenericClass = _arcosGenericClass;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.myDetails.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.myDetails.layer setBorderWidth:0.5];
    [self.myDetails.layer setCornerRadius:5.0f];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//    [self.myDetails addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.myDetails addGestureRecognizer:doubleTap];
//    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [doubleTap release];
//    [singleTap release];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap2Gesture:)];
    [self.linkAddress addGestureRecognizer:singleTap2];
    [singleTap2 release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.myTitle = nil;
    self.myDetails = nil;
    self.linkAddress = nil;
    self.type = nil;
//    self.arcosGenericClass = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer*)sender{
//    [self.delegate selectQueryOrderMasterTableCellRecord:self.indexPath];
    NSLog(@"double tap");
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    NSLog(@"single tap");
}

-(void)handleSingleTap2Gesture:(UITapGestureRecognizer*)sender {
    if ([self.type intValue] == 1) {
        [self.actionDelegate selectNewsTableCellRecord:self.indexPath];
    } else if ([self.type intValue] == 2) {
        [self.actionDelegate selectTaskTableCellRecord:self.indexPath];
    }
}

-(void)configCellWithData:(NSNumber*)heightData {
    self.myDetails.frame = CGRectMake(self.myDetails.frame.origin.x, self.myDetails.frame.origin.y, self.myDetails.frame.size.width, heightData.floatValue);
    self.linkAddress.frame = CGRectMake(self.linkAddress.frame.origin.x, heightData.floatValue + 7.0, self.linkAddress.frame.size.width, self.linkAddress.frame.size.height);
}


@end
