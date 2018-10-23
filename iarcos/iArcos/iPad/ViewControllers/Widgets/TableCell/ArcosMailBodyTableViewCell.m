//
//  ArcosMailBodyTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailBodyTableViewCell.h"

@implementation ArcosMailBodyTableViewCell
@synthesize fieldContent = _fieldContent;
@synthesize myWebView = _myWebView;
@synthesize myContext = _myContext;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldContent = nil;
    self.myWebView = nil;
    self.myContext = nil;    
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    [super configCellWithData:aDataDict];
    self.fieldContent.textContainer.lineFragmentPadding = 0.0f;
    [self.fieldContent setTextContainerInset:UIEdgeInsetsMake(9.0, 0, 9.0, 0)];
    NSMutableDictionary* fieldDataDict = [aDataDict objectForKey:@"FieldData"];    
    self.fieldContent.frame = CGRectMake(self.fieldContent.frame.origin.x, self.fieldContent.frame.origin.y, self.fieldContent.frame.size.width, [[fieldDataDict objectForKey:@"TextViewHeight"] floatValue]);
    BOOL isHTMLFlag = [[aDataDict objectForKey:@"IsHTML"] boolValue];
    self.myWebView.hidden = !isHTMLFlag;
    self.fieldContent.hidden = isHTMLFlag;
    if (isHTMLFlag) {
        [self.myWebView loadHTMLString:[fieldDataDict objectForKey:@"Content"] baseURL:nil];
    } else {
        self.fieldContent.text = [fieldDataDict objectForKey:@"Content"];
    }    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString* auxText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    ArcosMailDataUtils* arcosMailDataUtils = [[ArcosMailDataUtils alloc] init];
    NSMutableDictionary* resultDict = [arcosMailDataUtils calculateHeightWithText:auxText];          
    self.fieldContent.frame = CGRectMake(self.fieldContent.frame.origin.x, self.fieldContent.frame.origin.y, self.fieldContent.frame.size.width, [[resultDict objectForKey:@"TextViewHeight"] floatValue]);
    NSMutableDictionary* tmpCellDataDict = [self.cellData objectForKey:@"FieldData"];
    [tmpCellDataDict setObject:[resultDict objectForKey:@"CellHeight"] forKey:@"CellHeight"];
    [arcosMailDataUtils release];
    [self.myDelegate updateMailBodyHeight:self.indexPath];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSMutableDictionary* tmpCellDataDict = [self.cellData objectForKey:@"FieldData"];
    [tmpCellDataDict setObject:textView.text forKey:@"Content"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute('contentEditable','true')"];    
    self.myContext = [self.myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    self.myContext[@"webViewCallback"] = ^ {        
        [weakSelf webViewCallbackProcessor];
    };    
    self.myContext[@"webViewClipboardCallback"] = ^ {
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:weakSelf
                                       selector:@selector(webViewCallbackProcessor)
                                       userInfo:nil
                                        repeats:NO];
    };    
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.addEventListener('keyup',webViewCallback,false)"];
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.addEventListener('paste',webViewClipboardCallback,false)"];
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.addEventListener('cut',webViewClipboardCallback,false)"];
    [self.myContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
        NSLog(@"JSValue: %@", [exception toString]);
    }];
    self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x, self.myWebView.frame.origin.y, self.myWebView.frame.size.width, self.myWebView.scrollView.contentSize.height);
    ArcosMailDataUtils* arcosMailDataUtils = [[ArcosMailDataUtils alloc] init];
    NSMutableDictionary* resultDict = [arcosMailDataUtils calculateHeightWithWebViewHeight:self.myWebView.scrollView.contentSize.height];
    NSMutableDictionary* tmpCellDataDict = [self.cellData objectForKey:@"FieldData"];
    [tmpCellDataDict setObject:[resultDict objectForKey:@"CellHeight"] forKey:@"CellHeight"];
    [self.myDelegate updateMailBodyHeight:self.indexPath];
    [arcosMailDataUtils release];
}

- (void)webViewCallbackProcessor {    
    ArcosMailDataUtils* arcosMailDataUtils = [[ArcosMailDataUtils alloc] init];
    NSMutableDictionary* resultDict = [arcosMailDataUtils calculateHeightWithWebViewHeight:self.myWebView.scrollView.contentSize.height];
    self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x, self.myWebView.frame.origin.y, self.myWebView.frame.size.width, [[resultDict objectForKey:@"WebViewHeight"] floatValue]);
    NSMutableDictionary* tmpCellDataDict = [self.cellData objectForKey:@"FieldData"];
    [tmpCellDataDict setObject:[resultDict objectForKey:@"CellHeight"] forKey:@"CellHeight"];
    [self.myDelegate updateMailBodyHeight:self.indexPath];
    [arcosMailDataUtils release];
}

- (void)cleanData {    
    self.fieldContent.delegate = nil;
    self.myWebView.delegate = nil;
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.removeEventListener('keyup',webViewCallback,false)"];
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.removeEventListener('paste',webViewClipboardCallback,false)"];
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.removeEventListener('cut',webViewClipboardCallback,false)"];
    self.myContext[@"webViewCallback"] = nil;    
    self.myContext[@"webViewClipboardCallback"] = nil;
    self.fieldContent = nil;
    self.myWebView = nil;
    self.myContext = nil;
}

@end
