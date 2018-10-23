//
//  CustomerSurveySectionHeader.h
//  iArcos
//
//  Created by David Kilmartin on 02/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerSurveySectionHeader : UIView {
    UILabel* _narrative;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;

@end
