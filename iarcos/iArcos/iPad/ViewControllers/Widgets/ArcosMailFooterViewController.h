//
//  ArcosMailFooterViewController.h
//  iArcos
//
//  Created by Richard on 13/09/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ArcosMailFooterViewController : UIViewController {
    UIView* _templateView;
    UIImageView* _myImageView;
}

@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) IBOutlet UIImageView* myImageView;

@end


