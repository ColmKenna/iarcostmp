//
//  CustomerSurveyDetailsSectionHeader.h
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerSurveyDetailsSectionHeader : UIView {
    UILabel* _narrative;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;

@end
