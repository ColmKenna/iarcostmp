//
//  CustomerSurveyPhotoTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 22/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyPhotoTableCell.h"
#import "ArcosUtils.h"

@implementation CustomerSurveyPhotoTableCell
@synthesize narrative = _narrative;
@synthesize photoButton = _photoButton;
@synthesize previewButton = _previewButton;
@synthesize pressCount = _pressCount;

- (void)dealloc {
    self.narrative = nil;
    self.photoButton = nil;
    self.previewButton = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.narrative.text = [theData objectForKey:@"Narrative"];
    NSString* myAnswer = [theData objectForKey:@"Answer"];
    if ([myAnswer isEqualToString:@""]) {
        self.previewButton.hidden = YES;
        self.photoButton.hidden = NO;
    } else {
        self.previewButton.hidden = NO;
        self.photoButton.hidden = YES;
        NSArray* auxFileNameList = [myAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
        NSString* previewText = @"PREVIEW";
        int fileNameListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[auxFileNameList count]];
        if ([auxFileNameList count] > 1) {
            previewText = [NSString stringWithFormat:@"%@(%d)", previewText, fileNameListCount];
        }
        [self.previewButton setTitle:previewText forState:UIControlStateNormal];
    }
    [self configNarrativeWithLabel:self.narrative];
}

- (IBAction)pressPhotoButton:(id)sender {
    [self.delegate pressPhotoButtonDelegateWithIndexPath:self.indexPath];
}

- (IBAction)pressPreviewButton:(id)sender {
    [self.delegate pressPreviewButtonDelegateWithIndexPath:self.indexPath];
}


@end
