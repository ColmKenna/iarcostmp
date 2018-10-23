//
//  CustomerInfoHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoHeaderViewController : UIViewController {
    UILabel* _headerTitleLabel;
    UIButton* _headerButton;
    UILabel* _headerContentLabel;
    NSString* _headerContentValue;
}

@property(nonatomic, retain) IBOutlet UILabel* headerTitleLabel;
@property(nonatomic, retain) IBOutlet UIButton* headerButton;
@property(nonatomic, retain) IBOutlet UILabel* headerContentLabel;
@property(nonatomic, retain) NSString* headerContentValue;

@end
