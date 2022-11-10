//
//  ArcosMailTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailTableViewController.h"
#import "NSData+Base64.h"

@interface ArcosMailTableViewController ()

@end

@implementation ArcosMailTableViewController
//@synthesize myDelegate = _myDelegate;
@synthesize mailDelegate = _mailDelegate;
@synthesize arcosMailDataManager = _arcosMailDataManager;
@synthesize arcosMailCellFactory = _arcosMailCellFactory;
@synthesize sendButton = _sendButton;
@synthesize smtpSession = _smtpSession;
@synthesize HUD = _HUD;
@synthesize arcosStoreExcInfoDataManager = _arcosStoreExcInfoDataManager;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arcosMailDataManager = [[[ArcosMailDataManager alloc] init] autorelease];        
        self.arcosMailCellFactory = [ArcosMailCellFactory factory];
        self.arcosStoreExcInfoDataManager = [ArcosStoreExcInfoDataManager storeExcInfoInstance];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    
    [self.arcosMailDataManager createBasicData];
    self.title = self.arcosMailDataManager.subjectText;
    if ([self.title isEqualToString:@""]) {
        self.title = self.arcosMailDataManager.defaultTitleText;
    }
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
    self.sendButton = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendPressed:)] autorelease];
    [self.sendButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:self.sendButton];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[UIColor redColor]];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    }
    
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    for (UIGestureRecognizer* recognizer in self.tableView.gestureRecognizers) {
        [self.tableView removeGestureRecognizer:recognizer];
    }
    self.arcosMailDataManager = nil;
    self.arcosMailCellFactory = nil;
    self.sendButton = nil;
    self.smtpSession = nil;
    self.arcosStoreExcInfoDataManager = nil;
    
    [super dealloc];
}

- (void)closePressed:(id)sender {
    [self cleanMailData];
    [self.mailDelegate arcosMailDidFinishWithResult:ArcosMailComposeResultCancelled error:nil];
}

- (void)cleanMailData {
    NSIndexPath* bodyIndexPath = [self.arcosMailDataManager retrieveIndexPathWithTitle:self.arcosMailDataManager.bodyTitleText];
    ArcosMailBodyTableViewCell* arcosMailBodyTableViewCell = (ArcosMailBodyTableViewCell*) [self.tableView cellForRowAtIndexPath:bodyIndexPath];
    [arcosMailBodyTableViewCell cleanData];
}

- (void)sendPressed:(id)sender {
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
            [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            [self.HUD hide:YES];
            return;
        }
        if ([self.arcosMailDataManager.displayList count] < 4) {
            [self.HUD hide:YES];
            return;
        }
        NSMutableDictionary* toCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:0];
        NSMutableArray* toRecipientList = [toCellDataDict objectForKey:@"FieldData"];
        NSMutableDictionary* ccCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:1];
        NSMutableArray* ccRecipientList = [ccCellDataDict objectForKey:@"FieldData"];
        if ([toRecipientList count] == 0 && [ccRecipientList count] == 0) {
            [ArcosUtils showDialogBox:@"No recipient found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            [self.HUD hide:YES];
            return;
        }
        BOOL invalidEmailAddressFlag = NO;
        for (int i = 0; i < [toRecipientList count]; i++) {
            NSString* auxToRecipient = [toRecipientList objectAtIndex:i];
            if (![ArcosValidator isEmail:[ArcosUtils trim:auxToRecipient]]) {
                invalidEmailAddressFlag = YES;
                continue;
            }
        }
        for (int i = 0; i < [ccRecipientList count]; i++) {
            NSString* auxCcRecipient = [ccRecipientList objectAtIndex:i];
            if (![ArcosValidator isEmail:[ArcosUtils trim:auxCcRecipient]]) {
                invalidEmailAddressFlag = YES;
                continue;
            }
        }
        if (invalidEmailAddressFlag) {
            [ArcosUtils showDialogBox:@"Invalid email account found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            [self.HUD hide:YES];
            return;
        }
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary* payloadDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary* messageDict = [[[NSMutableDictionary alloc] init] autorelease];
        self.arcosMailDataManager.largeAttachmentFlag = NO;
        
        if ([self.arcosMailDataManager.attachmentList count] == 1) {
            ArcosAttachmentContainer* arcosAttachmentContainer = [self.arcosMailDataManager.attachmentList objectAtIndex:0];
            int attachmentSize = [ArcosUtils convertNSUIntegerToUnsignedInt:arcosAttachmentContainer.fileData.length];
            if (attachmentSize >= self.arcosMailDataManager.minLargeAttachmentSize) {
                self.arcosMailDataManager.largeAttachmentFlag = YES;
            }
        }
        
        NSURL* url = [NSURL URLWithString:[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphURI];
        if (self.arcosMailDataManager.largeAttachmentFlag) {
            url = [NSURL URLWithString:[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphMessageURI];
        }
        
        NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
        
        [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
        
        NSMutableDictionary* subjectCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:2];
        NSString* subjectText = [subjectCellDataDict objectForKey:@"FieldData"];
        NSMutableDictionary* bodyCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:3];
        NSMutableDictionary* bodyFieldDataDict = [bodyCellDataDict objectForKey:@"FieldData"];
        NSString* bodyText = [bodyFieldDataDict objectForKey:@"Content"];
        
        [messageDict setObject:subjectText forKey:@"subject"];
        
        NSMutableArray* resToRecipientList = [NSMutableArray array];
        [messageDict setObject:resToRecipientList forKey:@"toRecipients"];
        for (int i = 0; i < [toRecipientList count]; i++) {
            NSString* auxToRecipient = [toRecipientList objectAtIndex:i];
            NSMutableDictionary* toRecipientDict = [NSMutableDictionary dictionary];
            NSMutableDictionary* emailAddressDict = [NSMutableDictionary dictionary];
            [emailAddressDict setObject:auxToRecipient forKey:@"address"];
            [toRecipientDict setObject:emailAddressDict forKey:@"emailAddress"];
            [resToRecipientList addObject:toRecipientDict];
        }
        NSMutableArray* resCcRecipientList = [NSMutableArray array];
        [messageDict setObject:resCcRecipientList forKey:@"ccRecipients"];
        for (int i = 0; i < [ccRecipientList count]; i++) {
            NSString* auxCcRecipient = [ccRecipientList objectAtIndex:i];
            NSMutableDictionary* ccRecipientDict = [NSMutableDictionary dictionary];
            NSMutableDictionary* emailAddressDict = [NSMutableDictionary dictionary];
            [emailAddressDict setObject:auxCcRecipient forKey:@"address"];
            [ccRecipientDict setObject:emailAddressDict forKey:@"emailAddress"];
            [resCcRecipientList addObject:ccRecipientDict];
        }
        
        NSMutableDictionary* bodyDict = [NSMutableDictionary dictionary];
        [messageDict setObject:bodyDict forKey:@"body"];
        if (self.arcosMailDataManager.isHTML) {
            NSIndexPath* bodyIndexPath = [self.arcosMailDataManager retrieveIndexPathWithTitle:self.arcosMailDataManager.bodyTitleText];
            ArcosMailBodyTableViewCell* arcosMailBodyTableViewCell = (ArcosMailBodyTableViewCell*) [self.tableView cellForRowAtIndexPath:bodyIndexPath];
            [arcosMailBodyTableViewCell.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute('contentEditable','false')"];
            NSString* currentHTML = [arcosMailBodyTableViewCell.myWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
            [bodyDict setObject:@"html" forKey:@"contentType"];
            [bodyDict setObject:[ArcosUtils convertNilToEmpty:currentHTML] forKey:@"content"];
        } else {
            [bodyDict setObject:@"text" forKey:@"contentType"];
            [bodyDict setObject:[ArcosUtils convertNilToEmpty:bodyText] forKey:@"content"];
        }
        
        if (self.arcosMailDataManager.largeAttachmentFlag) {
            [self createMessageWithData:messageDict request:request];
            return;
        }
        if ([self.arcosMailDataManager.attachmentList count] > 0) {
            NSMutableArray* attachmentList = [NSMutableArray array];
            for (int i = 0; i < [self.arcosMailDataManager.attachmentList count]; i++) {
                ArcosAttachmentContainer* arcosAttachmentContainer = [self.arcosMailDataManager.attachmentList objectAtIndex:i];
                NSMutableDictionary* attachmentDict = [NSMutableDictionary dictionary];
                
                [attachmentDict setObject:@"#microsoft.graph.fileAttachment" forKey:@"@odata.type"];
                [attachmentDict setObject:[ArcosUtils convertNilToEmpty:[arcosAttachmentContainer fileName]] forKey:@"name"];
                [attachmentDict setObject:[ArcosUtils getMimeTypeWithFileName:[arcosAttachmentContainer fileName]] forKey:@"contentType"];
                NSString* base64String = [arcosAttachmentContainer.fileData base64Encoding];
                [attachmentDict setObject:[ArcosUtils convertNilToEmpty:base64String] forKey:@"contentBytes"];//@"SGVsbG8gV29ybGQh"
                [attachmentList addObject:attachmentDict];
            }
            [messageDict setObject:attachmentList forKey:@"attachments"];
        }
        [payloadDictionary setObject:messageDict forKey:@"message"];
        NSData* payloadData = [NSJSONSerialization dataWithJSONObject:payloadDictionary options:NSJSONWritingPrettyPrinted error:nil];
        
        [request setHTTPBody:payloadData];
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"error %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
                NSLog(@"response status code: %d", statusCode);
                if (statusCode != 202) {
                    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                    NSLog(@"test %@ -- %@", result, data);
                    NSDictionary* resultDict = (NSDictionary*)result;
                    NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                    NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.HUD hide:YES];
                        [weakSelf cleanMailData];
                        [weakSelf.mailDelegate arcosMailDidFinishWithResult:ArcosMailComposeResultSent error:nil];
                    });
                }
            }
        }];
        [downloadTask resume];
        return;
    }
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    if (employeeDict == nil) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.HUD hide:YES];
        return;
    }
    NSDictionary* smtpConfigDict = [self.arcosMailDataManager retrieveDescrDetailWithDescrTypeCode:@"IO" descrDetailCode:@"48"];
    if (smtpConfigDict == nil) {
        [ArcosUtils showDialogBox:@"SMTP not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.HUD hide:YES];
        return;
    }
    NSString* username = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Email"]]];
//    NSString* pwd = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Password"]]];
    NSString* pwd = [self.arcosStoreExcInfoDataManager retrieveStoreExcInfo];
    NSString* tooltip = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[smtpConfigDict objectForKey:@"Tooltip"]]];
    NSArray* smtpInfoList = [tooltip componentsSeparatedByString:@","];
    if ([smtpInfoList count] < 2) {
        [ArcosUtils showDialogBox:@"SMTP not working" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.HUD hide:YES];
        return;
    }
    NSString* hostname = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[smtpInfoList objectAtIndex:0]]];
    int port = [[ArcosUtils convertStringToNumber:[smtpInfoList objectAtIndex:1]] intValue];
    self.smtpSession = [[[MCOSMTPSession alloc] init] autorelease];
    self.smtpSession.hostname = hostname;
    self.smtpSession.port = port;
    self.smtpSession.username = username;
    self.smtpSession.password = pwd;
    self.smtpSession.connectionType = MCOConnectionTypeStartTLS;
    self.smtpSession.timeout = [GlobalSharedClass shared].mailTimeout;
    MCOMessageBuilder* builder = [[[MCOMessageBuilder alloc] init] autorelease];
    if ([self.arcosMailDataManager.displayList count] < 4) {
        [self.HUD hide:YES]; 
        return;
    }    
    NSMutableDictionary* toCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:0];
    NSMutableArray* toRecipientList = [toCellDataDict objectForKey:@"FieldData"];
    NSMutableDictionary* ccCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:1];
    NSMutableArray* ccRecipientList = [ccCellDataDict objectForKey:@"FieldData"];
    if ([toRecipientList count] == 0 && [ccRecipientList count] == 0) {
        [ArcosUtils showDialogBox:@"No recipient found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.HUD hide:YES];
        return;
    }
    BOOL invalidEmailAddressFlag = NO;
    
    NSMutableDictionary* subjectCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:2];
    NSString* subjectText = [subjectCellDataDict objectForKey:@"FieldData"];
    NSMutableDictionary* bodyCellDataDict = [self.arcosMailDataManager.displayList objectAtIndex:3];
    NSMutableDictionary* bodyFieldDataDict = [bodyCellDataDict objectForKey:@"FieldData"];
    NSString* bodyText = [bodyFieldDataDict objectForKey:@"Content"];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:@"" mailbox:self.smtpSession.username]];
    NSMutableArray* toList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [toRecipientList count]; i++) {
        NSString* auxToRecipient = [toRecipientList objectAtIndex:i];
        if (![ArcosValidator isEmail:[ArcosUtils trim:auxToRecipient]]) {
            invalidEmailAddressFlag = YES;
            continue;
        }
        MCOAddress* toAddress = [MCOAddress addressWithDisplayName:@"" mailbox:auxToRecipient];
        [toList addObject:toAddress];
    }    
    [[builder header] setTo:toList];
    [toList release];
    NSMutableArray* ccList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [ccRecipientList count]; i++) {
        NSString* auxCcRecipient = [ccRecipientList objectAtIndex:i];
        if (![ArcosValidator isEmail:[ArcosUtils trim:auxCcRecipient]]) {
            invalidEmailAddressFlag = YES;
            continue;
        }
        MCOAddress* ccAddress = [MCOAddress addressWithDisplayName:@"" mailbox:auxCcRecipient];
        [ccList addObject:ccAddress];
    }
    if (invalidEmailAddressFlag) {
        [ArcosUtils showDialogBox:@"Invalid email account found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.HUD hide:YES];
        return;
    }
    [[builder header] setCc:ccList];
    [ccList release];
    [[builder header] setSubject:subjectText];
    if (self.arcosMailDataManager.isHTML) {
        NSIndexPath* bodyIndexPath = [self.arcosMailDataManager retrieveIndexPathWithTitle:self.arcosMailDataManager.bodyTitleText];
        ArcosMailBodyTableViewCell* arcosMailBodyTableViewCell = (ArcosMailBodyTableViewCell*) [self.tableView cellForRowAtIndexPath:bodyIndexPath];
        [arcosMailBodyTableViewCell.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute('contentEditable','false')"];
        NSString* currentHTML = [arcosMailBodyTableViewCell.myWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        [builder setHTMLBody:currentHTML];
    } else {
        [builder setTextBody:bodyText];
    }
    for (int i = 0; i < [self.arcosMailDataManager.attachmentList count]; i++) {        
        [builder addAttachment:[self.arcosMailDataManager.attachmentList objectAtIndex:i]];
    }    
    NSData* rfc822Data = [builder data];
    
    MCOSMTPSendOperation* sendOperation = [self.smtpSession sendOperationWithData:rfc822Data];
    __weak typeof(self) weakSelf = self;
    [sendOperation start:^(NSError* error) {
        if(error) {
            [weakSelf.HUD hide:YES];
            NSString* errorDesc = [error description];
            NSRange aRangeName = [errorDesc rangeOfString:@"credentials" options:NSCaseInsensitiveSearch];
            if (aRangeName.location != NSNotFound) {
                UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem accessing your account. Please re-enter the password" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                    UITextField* myTextField = [tmpDialogBox.textFields objectAtIndex:0];
                    [weakSelf.arcosStoreExcInfoDataManager updateStoreExcInfo:myTextField.text];
                    [weakSelf.arcosStoreExcInfoDataManager persistentStoreExcInfo];
                    [weakSelf sendPressed:nil];
                }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                    
                }];
                [tmpDialogBox addAction:cancelAction];
                [tmpDialogBox addAction:okAction];
                [tmpDialogBox addTextFieldWithConfigurationHandler:^(UITextField* textField) {
                    textField.secureTextEntry = true;
                }];
                [weakSelf presentViewController:tmpDialogBox animated:YES completion:nil];
            } else {
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@", errorDesc] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    
                }];
            }            
        } else {
            [weakSelf cleanMailData];
            [weakSelf.mailDelegate arcosMailDidFinishWithResult:ArcosMailComposeResultSent error:nil];
        }
    }];    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arcosMailDataManager.displayList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.arcosMailDataManager.displayList objectAtIndex:indexPath.row];
    NSNumber* auxCellType = [cellData objectForKey:@"CellType"];
    if ([auxCellType intValue] == 3) {
        NSMutableDictionary* auxCellDataDict = [cellData objectForKey:@"FieldData"];
        NSNumber* heightNumber = [auxCellDataDict objectForKey:@"CellHeight"];
        return [heightNumber floatValue];
    }
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {        
    NSMutableDictionary* cellData = [self.arcosMailDataManager.displayList objectAtIndex:indexPath.row];
    ArcosMailBaseTableViewCell* cell = (ArcosMailBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.arcosMailCellFactory identifierWithData:cellData]];
    if (cell == nil) {        
        cell = (ArcosMailBaseTableViewCell*)[self.arcosMailCellFactory createMailBaseTableCellWithData:cellData];
        cell.myDelegate = self;
    }
    // Configure the cell...
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ArcosMailTableViewCellDelegate
- (void)updateMailBodyHeight:(NSIndexPath*)anIndexPath{
    [self.tableView beginUpdates];
    [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:anIndexPath];
    [self.tableView endUpdates];
}

- (void)updateSubjectText:(NSString *)aText {
    self.title = aText;
    if ([self.title isEqualToString:@""]) {
        self.title = self.arcosMailDataManager.defaultTitleText;
    }
}

- (void)createMessageWithData:(NSMutableDictionary*)aMessageDict request:(NSMutableURLRequest*)aRequest {
    self.HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.HUD.progress = 0.0;
    __weak typeof(self) weakSelf = self;
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:aMessageDict options:NSJSONWritingPrettyPrinted error:nil];
    [aRequest setHTTPBody:payloadData];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:aRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"createMsg error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"createMsg response status code: %d", statusCode);
            if (statusCode != 201) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"createMsg error %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"createMsg res %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                self.arcosMailDataManager.messageId = [resultDict objectForKey:@"id"];
                [self attachLargeFile];
            }
        }
    }];
    [downloadTask resume];
}

- (void)attachLargeFile {
    __weak typeof(self) weakSelf = self;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/messages/%@/attachments/createUploadSession", self.arcosMailDataManager.messageId]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary* payloadDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableDictionary* attachmentItemDict = [NSMutableDictionary dictionary];
    ArcosAttachmentContainer* arcosAttachmentContainer = [self.arcosMailDataManager.attachmentList objectAtIndex:0];
    
    self.arcosMailDataManager.largeFileSize = [NSNumber numberWithInt:[ArcosUtils convertNSUIntegerToUnsignedInt:arcosAttachmentContainer.fileData.length]];
    
    [attachmentItemDict setObject:@"file" forKey:@"attachmentType"];
    [attachmentItemDict setObject:arcosAttachmentContainer.fileName forKey:@"name"];
    [attachmentItemDict setObject:self.arcosMailDataManager.largeFileSize forKey:@"size"];
    [payloadDictionary setObject:attachmentItemDict forKey:@"AttachmentItem"];
//    NSLog(@"cc %@", payloadDictionary);
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:payloadDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:payloadData];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"attachLF error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"attachLF response status code: %d", statusCode);
            if (statusCode != 201) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"attachLF error %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"attachLF res  %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                self.arcosMailDataManager.uploadURL = [NSString stringWithFormat:@"%@", [resultDict objectForKey:@"uploadUrl"]];
//                NSLog(@"attachLF url: %@", self.arcosMailDataManager.uploadURL);
                self.arcosMailDataManager.startIndex = 0;
                [self uploadLargeFile];
            }
        }
    }];
    [downloadTask resume];
}

- (void)uploadLargeFile {
    __weak typeof(self) weakSelf = self;
    int rangeLength = self.arcosMailDataManager.fileChunkSize;
    self.arcosMailDataManager.endIndex = self.arcosMailDataManager.startIndex + self.arcosMailDataManager.fileChunkSize - 1;
    if (self.arcosMailDataManager.endIndex >= [self.arcosMailDataManager.largeFileSize intValue] - 1) {
        self.arcosMailDataManager.endIndex = [self.arcosMailDataManager.largeFileSize intValue] - 1;
        rangeLength = self.arcosMailDataManager.endIndex - self.arcosMailDataManager.startIndex + 1;
    }
//    NSLog(@"range: %d %d %d", self.arcosMailDataManager.startIndex, self.arcosMailDataManager.endIndex, [self.arcosMailDataManager.largeFileSize intValue]);
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.arcosMailDataManager.uploadURL]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", self.arcosMailDataManager.fileChunkSize] forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"bytes %d-%d/%d", self.arcosMailDataManager.startIndex, self.arcosMailDataManager.endIndex, [self.arcosMailDataManager.largeFileSize intValue]] forHTTPHeaderField:@"Content-Range"];
    ArcosAttachmentContainer* arcosAttachmentContainer = [self.arcosMailDataManager.attachmentList objectAtIndex:0];
        
    NSRange partOfFileRange = NSMakeRange(self.arcosMailDataManager.startIndex, rangeLength);
    NSData* partOfFileData = [arcosAttachmentContainer.fileData subdataWithRange:partOfFileRange];
    [request setHTTPBody:partOfFileData];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"uploadLF error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"uploadLF response status code: %d", statusCode);
            if (statusCode == 200 || statusCode == 201) {
//                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"uploadLF res %@ -- %@", result, data);
                self.arcosMailDataManager.startIndex = self.arcosMailDataManager.endIndex + 1;
                float progressValue = self.arcosMailDataManager.startIndex * 1.0 / [self.arcosMailDataManager.largeFileSize intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.HUD.progress = progressValue;
                });
                if (statusCode == 201) {
                    [self sendMessage];
                    return;
                }
                [self uploadLargeFile];
                
            } else {//special condition
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"uploadLF error %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)sendMessage {
    __weak typeof(self) weakSelf = self;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/messages/%@/send", self.arcosMailDataManager.messageId]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];

    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"sendMsg error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"sendMsg response status code: %d", statusCode);
            if (statusCode != 202) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"sendMsg test %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"sendMsg res %@ -- %@", result, data);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [weakSelf cleanMailData];
                    [weakSelf.mailDelegate arcosMailDidFinishWithResult:ArcosMailComposeResultSent error:nil];
                });
            }
        }
    }];
    [downloadTask resume];
}

@end
