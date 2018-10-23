//
//  CustomerWeeklyMainTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 07/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerWeeklyMainTableCell.h"
#import "ArcosValidator.h"

@implementation CustomerWeeklyMainTableCell
@synthesize delegate;
@synthesize contentString;
@synthesize cellData;
@synthesize indexPath;

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

-(void)configCellWithData:(NSMutableDictionary*)theCellData {
    self.cellData = theCellData;
    self.contentString.text = [theCellData objectForKey:@"Narrative"];
    self.contentString.delegate = self;
    if ([[theCellData objectForKey:@"HasRecord"] boolValue]) {
        UIColor* myColor = [UIColor colorWithRed:1.0 green:1.0 blue:224.0/255.0 alpha:1.0];
        self.backgroundColor = myColor;
        self.contentString.backgroundColor = myColor;
    } else {
        UIColor* myColor = [UIColor whiteColor];
        self.backgroundColor = myColor;
        self.contentString.backgroundColor = myColor;
    }
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.contentString != nil) { self.contentString = nil; }
    if (self.cellData != nil) { self.cellData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }    
            
    [super dealloc];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate inputFinishedWithData:textView.text forIndexpath:self.indexPath];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:[self.delegate retrieveParentViewController]];
}

@end
