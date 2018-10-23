//
//  PresenterEbookViewController.h
//  iArcos
//
//  Created by David Kilmartin on 23/02/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterViewController.h"

@interface PresenterEbookViewController : PresenterViewController <UIDocumentInteractionControllerDelegate> {
    UIBarButtonItem* _ebookBarButton;
    UIDocumentInteractionController* _docInteractionController;
    NSString* _filePath;
    NSURL* _fileURL;
}

@property(nonatomic, retain) UIBarButtonItem* ebookBarButton;
@property(nonatomic, retain) UIDocumentInteractionController* docInteractionController;
@property(nonatomic, retain) NSString* filePath;
@property(nonatomic, retain) NSURL* fileURL;

@end
