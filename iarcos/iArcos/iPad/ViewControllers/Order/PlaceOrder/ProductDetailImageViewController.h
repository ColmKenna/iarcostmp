//
//  ProductDetailImageViewController.h
//  Arcos
//
//  Created by David Kilmartin on 13/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SettingManager.h"
#import "ArcosUtils.h"
#import "CallGenericServices.h"

@interface ProductDetailImageViewController : UIViewController {
    UIImageView* _bigProductCodeImageView;
    NSString* _imageResourceLocator;
//    MBProgressHUD* _HUD;
    BOOL _isNotFirstLoaded;
    NSString* _productCode;
    CallGenericServices* _callGenericServices;
    UIImage* _mediumImage;
    BOOL _showMediumImageExclusively;
    NSString* _largeImageName;
}

@property(nonatomic, retain) IBOutlet UIImageView* bigProductCodeImageView;
@property(nonatomic, retain) NSString* imageResourceLocator;
//@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) NSString* productCode;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) UIImage* mediumImage;
@property(nonatomic, assign) BOOL showMediumImageExclusively;
@property(nonatomic, retain) NSString* largeImageName;

@end
