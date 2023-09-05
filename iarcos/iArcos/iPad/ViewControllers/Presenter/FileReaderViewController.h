//
//  FileReaderViewController.h
//  Arcos
//
//  Created by David Kilmartin on 08/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"

@interface FileReaderViewController : UIViewController <WidgetFactoryDelegate,UIActionSheetDelegate>{
    IBOutlet UIWebView* fileContentView;
    NSURL* fileURL;
    NSMutableDictionary* theData;
    
    //order input popover
//    UIPopoverController* inputPopover;
    WidgetFactory* factory;
}
@property(nonatomic,retain) IBOutlet UIWebView* fileContentView;
@property(nonatomic,retain) NSURL* fileURL;
@property(nonatomic,retain) NSMutableDictionary* theData;
@property(nonatomic,retain) WidgetFactory* factory;

-(void)loadFile:(NSURL*)aURL;
@end
