//
//  MeetingAttachmentsFileViewController.h
//  iArcos
//
//  Created by David Kilmartin on 19/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "FileCommon.h"
#import "ModalPresentViewControllerDelegate.h"

@interface MeetingAttachmentsFileViewController : UIViewController {
    id<ModalPresentViewControllerDelegate> _modalDelegate;
    UIWebView* _myWebView;
//    NSString* _fileName;
    NSString* _filePath;
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> modalDelegate;
@property(nonatomic, retain) IBOutlet UIWebView* myWebView;
@property(nonatomic, retain) NSString* filePath;
//@property(nonatomic, retain) NSString* fileName;

@end

