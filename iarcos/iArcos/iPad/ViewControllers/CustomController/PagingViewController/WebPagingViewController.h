//
//  WebPagingViewController.h
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"

@interface WebPagingViewController : UIViewController<FileCommonDelegate,UIWebViewDelegate> {
    IBOutlet UIWebView* theWebView;
    IBOutlet UILabel* fileNameLable;
    IBOutlet UIActivityIndicatorView* indicator;
    NSURL* theUrl;
    
    FileCommon* fc;
    NSString* downloadServer;
    NSString* downloadFolder;
    NSString* theFileName;
    BOOL isFileExist;
    
    NSString* fileType;
    
}
@property(nonatomic,retain) IBOutlet UIWebView* theWebView;
@property(nonatomic,retain) IBOutlet UILabel* fileNameLable;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView* indicator;

@property(nonatomic,retain) NSURL* theUrl;

@property(nonatomic,retain)     FileCommon* fc;
@property(nonatomic,retain)   NSString* downloadServer;
@property(nonatomic,retain)   NSString* downloadFolder;
@property(nonatomic,retain)  NSString* theFileName;
@property(nonatomic,assign)    BOOL isFileExist;
@property(nonatomic,retain)  NSString* fileType;


-(id)initWithUrl:(NSURL*)url withName:(NSString*)name;
-(id)initWithPath:(NSString*)path withName:(NSString*)name;
-(id)initWithBundleFile:(NSString*)fileName withName:(NSString*)name;
@end
