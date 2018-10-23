//
//  ArcosGenericHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 05/02/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcosGenericHeaderViewController : UIViewController {
    UILabel* _titleLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* titleLabel;

@end
