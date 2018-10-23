//
//  ArcosCustomiseAnimation.m
//  Arcos
//
//  Created by David Kilmartin on 19/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ArcosCustomiseAnimation.h"

@implementation ArcosCustomiseAnimation
@synthesize delegate = _delegate;

- (id)init{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc
{     
    [super dealloc];    
}

-(void)addPushViewAnimation:(UIViewController*)rootView withController:(UINavigationController*) globalNavigationController {
    // top: 2, bottom: 1, left: 4, right:3
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    NSLog(@"%f, %f, %f, %f",rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.height, rootView.view.frame.size.width);
    float width = 0.0f;
    float height = 0.0f;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        width = rootView.view.frame.size.width > rootView.view.frame.size.height ? rootView.view.frame.size.width : rootView.view.frame.size.height;
        height = rootView.view.frame.size.width < rootView.view.frame.size.height ? rootView.view.frame.size.width : rootView.view.frame.size.height;
        globalNavigationController.view.frame = CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, width, height);
    } else if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
        width = rootView.view.frame.size.width < rootView.view.frame.size.height ? rootView.view.frame.size.width : rootView.view.frame.size.height;
        height = rootView.view.frame.size.width > rootView.view.frame.size.height ? rootView.view.frame.size.width : rootView.view.frame.size.height;
        globalNavigationController.view.frame = CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, width, height);
    }
    [rootView addChildViewController:globalNavigationController];
    [rootView.view addSubview:globalNavigationController.view];
    [globalNavigationController didMoveToParentViewController:rootView];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
//    NSLog(@"orientation:%d",orientation);
    if ([ArcosUtils systemVersionGreaterThanSeven]) {
        [animation setSubtype:kCATransitionFromRight];
    } else {
        switch (orientation) {
            case 1:
                [animation setSubtype:kCATransitionFromRight];
                break;
            case 2:
                //done
                [animation setSubtype:kCATransitionFromLeft];
                break;
            case 3:
                [animation setSubtype:kCATransitionFromTop];
                break;
            case 4:
                //done
                [animation setSubtype:kCATransitionFromBottom];
                break;
                
            default:
                break;
        }
    }
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];                                
    [rootView.view.layer addAnimation:animation forKey:nil];
}

-(void)dismissPushViewAnimation:(UIViewController*)rootView withController:(UINavigationController*) globalNavigationController {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [UIView animateWithDuration:0.3 animations:^{
//        NSLog(@"animations");
        CATransition* animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType:kCATransitionPush];
        if ([ArcosUtils systemVersionGreaterThanSeven]) {
            [animation setSubtype:kCATransitionFromLeft];
        } else {
            switch (orientation) {
                case 1:
                    [animation setSubtype:kCATransitionFromLeft];
                    break;
                case 2:
                    //done
                    [animation setSubtype:kCATransitionFromRight];
                    break;
                case 3:
                    [animation setSubtype:kCATransitionFromBottom];
                    break;
                case 4:
                    //done
                    [animation setSubtype:kCATransitionFromTop];
                    break;
                    
                default:
                    break;
            }
        }
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];                                
        [rootView.view.layer addAnimation:animation forKey:nil];    
    } completion:^(BOOL finished){
//        NSLog(@"animations BOOL finished");
        [globalNavigationController willMoveToParentViewController:nil];
        [globalNavigationController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.0];
        [globalNavigationController removeFromParentViewController];
        [self.delegate dismissPushViewCallBack];
    }];
}

@end
