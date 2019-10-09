//
//  CustomerSurveyPhotoTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 22/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyBaseTableCell.h"
#import "ArcosBorderUIButton.h"
#import "ArcosBorderBackgroundUIButton.h"

@interface CustomerSurveyPhotoTableCell : CustomerSurveyBaseTableCell {
//    UILabel* _narrative;
    ArcosBorderUIButton* _photoButton;
    ArcosBorderBackgroundUIButton* _previewButton;
    int _pressCount;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet ArcosBorderUIButton* photoButton;
@property(nonatomic, retain) IBOutlet ArcosBorderBackgroundUIButton* previewButton;
@property(nonatomic, assign) int pressCount;

- (IBAction)pressPhotoButton:(id)sender;
- (IBAction)pressPreviewButton:(id)sender;

@end
