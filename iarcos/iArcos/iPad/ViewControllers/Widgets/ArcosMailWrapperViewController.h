//
//  ArcosMailWrapperViewController.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePresentViewControllerDelegate.h"
#import "ArcosMailTableViewController.h"

@interface ArcosMailWrapperViewController : UIViewController <CustomisePresentViewControllerDelegate, ArcosMailTableViewControllerDelegate> {
//    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ArcosMailTableViewControllerDelegate> _mailDelegate;
    UIView* _customiseContentView;
    UIScrollView* _customiseScrollContentView;
    UINavigationController* _globalNavigationController;
    NSString* _subjectText;
    NSString* _bodyText;
    BOOL _isHTML;
    NSMutableArray* _toRecipients;
    NSMutableArray* _ccRecipients;
    NSMutableArray* _attachmentList;
}

//@property (nonatomic,assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic,assign) id<ArcosMailTableViewControllerDelegate> mailDelegate;
@property (nonatomic,retain) IBOutlet UIView* customiseContentView;
@property (nonatomic,retain) IBOutlet UIScrollView* customiseScrollContentView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) NSString* subjectText;
@property(nonatomic,retain) NSString* bodyText;
@property(nonatomic,assign) BOOL isHTML;
@property(nonatomic,retain) NSMutableArray* toRecipients;
@property(nonatomic,retain) NSMutableArray* ccRecipients;
@property(nonatomic,retain) NSMutableArray* attachmentList;

@end
