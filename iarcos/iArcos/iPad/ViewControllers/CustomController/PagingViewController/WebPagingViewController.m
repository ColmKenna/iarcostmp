//
//  WebPagingViewController.m
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "WebPagingViewController.h"
#import "SettingManager.h"

@interface WebPagingViewController (Private)
-(void)reloadFile;
@end

@implementation WebPagingViewController
@synthesize  theWebView;
@synthesize  fileNameLable;
@synthesize indicator;
@synthesize fc;
@synthesize downloadFolder;
@synthesize downloadServer;
@synthesize theUrl;
@synthesize theFileName;
@synthesize isFileExist;
@synthesize fileType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
        // Custom initialization
        fc=[[FileCommon alloc]init];
        fc.delegate=self;
        self.downloadFolder=@"presenter";
        //self.downloadServer=@"http://www.stratait.ie/downloads/";
        self.downloadServer=[SettingManager downloadServer];
    }
    return self;
}
-(id)initWithUrl:(NSURL*)url withName:(NSString*)name{
    self = [self initWithNibName:@"WebPagingViewController" bundle:nil];
    if (self!=nil) {
        self.theUrl=url;
        self.theFileName=name;
    }
    return self;
}
-(id)initWithPath:(NSString*)path withName:(NSString*)name{
    self = [self initWithNibName:@"WebPagingViewController" bundle:nil];
    if (self!=nil) {
        self.theFileName=name;
        NSURL *url = [NSURL fileURLWithPath:path];
        self.theUrl=url;
        if ([FileCommon fileExistAtPath:path]) {
            self.isFileExist=YES;
        }else{
            self.isFileExist=NO;

            NSString* fileName=[path lastPathComponent];
            NSString* urlStirng=[NSString stringWithFormat:@"%@%@",self.downloadServer,fileName];
            //NSString* urlStirng=@"http://www.climbing.com/leadingoff/Cochise-Stronghold-275.jpg";
            NSLog(@"path to server file %@",urlStirng);
            //fileName=[urlStirng lastPathComponent];
            NSURL* serverUrl=[NSURL URLWithString:urlStirng];
            //self.theUrl=serverUrl;
            [fc downloadFileWithURL:serverUrl WithName:fileName toFolder:self.downloadFolder];
        }

    }
    return self;
}
-(id)initWithBundleFile:(NSString*)fileName withName:(NSString*)name{
    self = [super initWithNibName:@"WebPagingViewController" bundle:nil];
    if (self!=nil) {
        self.theFileName=name;

        NSString* namePart=[fileName stringByDeletingPathExtension];
        NSString* extensionPart=[fileName pathExtension];
        // get localized path for file from app bundle
        NSString *path;
        NSBundle *thisBundle = [NSBundle mainBundle];
        path = [thisBundle pathForResource:namePart ofType:extensionPart];
        
        // make a file: URL out of the path
        NSURL *instructionsURL = [NSURL fileURLWithPath:path];
        self.theUrl=instructionsURL;
    }
    return self;
}
-(void)fileDownloaded:(FileCommon *)fileCommon withError:(BOOL)anyError{
    self.isFileExist=!anyError;

    NSLog(@"%@ is download",self.theFileName);
    [self reloadFile];
    [self.indicator stopAnimating];

}
-(void)reloadFile{
//    float width=self.view.frame.size.width;
//    float height=self.view.frame.size.height;

    if ([self.fileType isEqualToString:@"VID"]) {
        NSString *videoHTML = [NSString stringWithFormat: @"<html><head><style></style></head><body> <video id='video_with_controls' height='838' width='972' controls autobuffer autoplay='false'><source src='%@' title=''  durationHint='durationofvideo'/></video></body></html>",theUrl];
        
        
        theWebView.opaque = NO;
        theWebView.backgroundColor = [UIColor clearColor];
        [theWebView loadHTMLString:videoHTML baseURL:nil]; 
    }else if([self.fileType isEqualToString: @"SOUN"]){
        NSString *audioHTML = [NSString stringWithFormat: @"<html><head><style></style></head><body><audio id='audio_with_controls' height='20' width='100' style:'height:838; width:972' controls autobuffer autoplay='false'><source src='%@' title='' /></audio></body></html>",theUrl];
        
        
        theWebView.opaque = NO;
        theWebView.backgroundColor = [UIColor clearColor];
        [theWebView loadHTMLString:audioHTML baseURL:nil]; 
    }else{
         [theWebView loadRequest:[NSURLRequest requestWithURL:theUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    }
    
}
- (void)dealloc
{
    [super dealloc];
    [fc release];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.indicator startAnimating];
    
    // Do any additional setup after loading the view from its nib.
    self.theWebView.scalesPageToFit=YES;
    self.fileNameLable.text=self.theFileName;
    
    if (self.isFileExist) {
        //[self.theWebView loadRequest:[NSURLRequest requestWithURL:self.theUrl]];
        [self reloadFile];
    }else{
        [self.theWebView loadHTMLString:@"<h1>The file is downloading</h>" baseURL:nil];
    }
    
    //set the view size
    UIInterfaceOrientation or=[UIApplication sharedApplication].statusBarOrientation;
    if (or== UIInterfaceOrientationPortrait) {
        self.theWebView.frame=CGRectMake(0, 0, 703, 599);
        self.fileNameLable.frame=CGRectMake(0, 600, 703, 55);
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.isFileExist) {
        [self.indicator stopAnimating];
    }
    NSLog(@"content load!");

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //[self.indicator stopAnimating];
    NSLog(@"content load with error %@",[error description]);
    if (!self.isFileExist) {
        [webView loadHTMLString:@"<h1>The file is not found</h>" baseURL:nil];
    }else if([error code]==102 || [error code]==-1100 ) {
        [webView loadHTMLString:@"<h1>Fail to load the file</h>" baseURL:nil];

    }
    else if([error code]==204 ) {
        [self.indicator stopAnimating];
    }


}
@end
