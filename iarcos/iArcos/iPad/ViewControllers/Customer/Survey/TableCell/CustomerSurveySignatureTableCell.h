//
//  CustomerSurveySignatureTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 31/10/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "DrawingArea.h"

@interface CustomerSurveySignatureTableCell : CustomerSurveyBaseTableCell <DrawingAreaDelegate>{
    DrawingArea* _drawingAreaView;
}

@property(nonatomic, retain) IBOutlet DrawingArea* drawingAreaView;

@end

