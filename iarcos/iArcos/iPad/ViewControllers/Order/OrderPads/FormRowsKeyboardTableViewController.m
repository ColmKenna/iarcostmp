//
//  FormRowsKeyboardTableViewController.m
//  iArcos
//
//  Created by Richard on 02/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsKeyboardTableViewController.h"

@interface FormRowsKeyboardTableViewController ()

@end

@implementation FormRowsKeyboardTableViewController
@synthesize modalDelegate = _modalDelegate;
@synthesize formRowsKeyboardDataManager = _formRowsKeyboardDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.formRowsKeyboardDataManager = [[[FormRowsKeyboardDataManager alloc] init] autorelease];
        [self.formRowsKeyboardDataManager createBasicData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
}

- (void)cancelButtonPressed {
    [self.modalDelegate didDismissModalPresentViewController];
}

- (void)dealloc {
    self.formRowsKeyboardDataManager = nil;
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"aa key %d", self.isFirstResponder);
    [self becomeFirstResponder];
    NSLog(@"cc key %d", self.isFirstResponder);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formRowsKeyboardDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    static NSString* CellIdentifier = @"IdFormRowsKeyboardTableViewCell";
    
    FormRowsKeyboardTableViewCell* cell = (FormRowsKeyboardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"FormRowsKeyboardTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[FormRowsKeyboardTableViewCell class]] && [[(FormRowsKeyboardTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (FormRowsKeyboardTableViewCell *) nibItem;
            }
        }
    }
    // Configure the cell...
    NSMutableDictionary* cellData = [self.formRowsKeyboardDataManager.displayList objectAtIndex:indexPath.row];
    cell.myDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithData:cellData];
    return cell;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)moveDownOneRow:(id)sender {
    NSLog(@"moveDownOneRow key");
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if (self.formRowsKeyboardDataManager.globalCurrentIndexPath == nil) {
        self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        if ((self.formRowsKeyboardDataManager.globalCurrentIndexPath.row + 1) < [self.tableView numberOfRowsInSection:0]) {
            self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:self.formRowsKeyboardDataManager.globalCurrentIndexPath.row + 1 inSection:0];
        }
    }

//    [self.tableView selectRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    FormRowsKeyboardTableViewCell* formRowsKeyboardTableViewCell = (FormRowsKeyboardTableViewCell*)[self.tableView cellForRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath];
    [[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex] becomeFirstResponder];
}

- (void)moveUpOneRow:(id)sender {
    NSLog(@"moveUpOneRow key");
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if (self.formRowsKeyboardDataManager.globalCurrentIndexPath == nil) {
        self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        if ((self.formRowsKeyboardDataManager.globalCurrentIndexPath.row - 1) >= 0) {
            self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:self.formRowsKeyboardDataManager.globalCurrentIndexPath.row - 1 inSection:0];
        }
    }

//    [self.tableView selectRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    FormRowsKeyboardTableViewCell* formRowsKeyboardTableViewCell = (FormRowsKeyboardTableViewCell*)[self.tableView cellForRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath];
    [[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex] becomeFirstResponder];
}

- (void)moveRightOneField:(id)sender {
    NSLog(@"moveRightOneField key");
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if (self.formRowsKeyboardDataManager.globalCurrentIndexPath == nil) {
        self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }

    [self.tableView selectRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    FormRowsKeyboardTableViewCell* formRowsKeyboardTableViewCell = (FormRowsKeyboardTableViewCell*)[self.tableView cellForRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath];
    if (self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex < [formRowsKeyboardTableViewCell.textFieldList count] - 1) {
        [[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex + 1] becomeFirstResponder];
    } else {
        [[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:0] becomeFirstResponder];
    }
}

- (void)moveLeftOneField:(id)sender {
    NSLog(@"moveLeftOneField key");
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if (self.formRowsKeyboardDataManager.globalCurrentIndexPath == nil) {
        self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }

    [self.tableView selectRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    FormRowsKeyboardTableViewCell* formRowsKeyboardTableViewCell = (FormRowsKeyboardTableViewCell*)[self.tableView cellForRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath];
    if (self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex > 0) {
        [[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex - 1] becomeFirstResponder];
    } else {
        [[formRowsKeyboardTableViewCell.textFieldList lastObject] becomeFirstResponder];
    }
}

- (void)enterValueToField:(id)sender {
    NSLog(@"enterValueToField key");
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    /*
    if (self.formRowsKeyboardDataManager.globalCurrentIndexPath == nil) {
        self.formRowsKeyboardDataManager.globalCurrentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    FormRowsKeyboardTableViewCell* formRowsKeyboardTableViewCell = (FormRowsKeyboardTableViewCell*)[self.tableView cellForRowAtIndexPath:self.formRowsKeyboardDataManager.globalCurrentIndexPath];
    [[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:formRowsKeyboardTableViewCell.currentTextFieldIndex] becomeFirstResponder];
    UITextField* currentTextField = (UITextField*)[formRowsKeyboardTableViewCell.textFieldList objectAtIndex:formRowsKeyboardTableViewCell.currentTextFieldIndex];
    currentTextField.text = [NSString stringWithFormat:@"%@1", currentTextField.text];
     */
}

//- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event {
//    [super pressesBegan:presses withEvent:event];
//}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event {
    [super pressesEnded:presses withEvent:event];
    for (UIPress* aPress in presses) {
        if (aPress.key.modifierFlags == UIKeyModifierAlternate) {
            NSLog(@"UIKeyModifierAlternate");
            if ([self.formRowsKeyboardDataManager.displayList count] == 0) {
                return;
            }
            if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardUpArrow) {
                NSLog(@"page up");
                NSArray* indexPathsVisibleRows = [self.tableView indexPathsForVisibleRows];
                if ([indexPathsVisibleRows count] > 0) {
                    NSIndexPath* topIndexPath = [indexPathsVisibleRows objectAtIndex:0];
                    int rowNumber = 0;
                    int nextRowNumber = [ArcosUtils convertNSIntegerToInt:topIndexPath.row] - 15;
                    if (nextRowNumber > rowNumber) {
                        rowNumber = nextRowNumber;
                    }
                    NSIndexPath* resultIndexPath = [NSIndexPath indexPathForRow:rowNumber inSection:0];
                    [self.tableView scrollToRowAtIndexPath:resultIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardDownArrow) {
                NSLog(@"page down");
                NSArray* indexPathsVisibleRows = [self.tableView indexPathsForVisibleRows];
                if ([indexPathsVisibleRows count] > 0) {
                    NSIndexPath* bottomIndexPath = [indexPathsVisibleRows lastObject];
                    int rowNumber = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.formRowsKeyboardDataManager.displayList count] - 1];
                    int nextRowNumber = [ArcosUtils convertNSIntegerToInt:bottomIndexPath.row] + 15;
                    if (nextRowNumber < rowNumber) {
                        rowNumber = nextRowNumber;
                    }
                    NSIndexPath* resultIndexPath = [NSIndexPath indexPathForRow:rowNumber inSection:0];
                    [self.tableView scrollToRowAtIndexPath:resultIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        } else {
            if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardReturnOrEnter || aPress.key.keyCode == UIKeyboardHIDUsageKeyboardDownArrow) {
                [self moveDownOneRow:nil];
            } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardUpArrow) {
                [self moveUpOneRow:nil];
            } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardLeftArrow) {
                [self moveLeftOneField:nil];
            } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardRightArrow) {
                [self moveRightOneField:nil];
            } else {
                
            }
        }
        
    }
}


#pragma mark - FormRowsKeyboardTableViewCellDelegate

- (void)configGlobalCurrentTextFieldIndex:(int)anIndex {
    self.formRowsKeyboardDataManager.globalCurrentTextFieldIndex = anIndex;
}

- (void)configGlobalCurrentIndexPath:(NSIndexPath *)anIndexPath {
    self.formRowsKeyboardDataManager.globalCurrentIndexPath = anIndexPath;
}

- (void)inputFinishedWithData:(NSString *)aData forIndexPath:(NSIndexPath *)anIndexPath {
    [self.formRowsKeyboardDataManager processInputFinishedWithData:aData forIndexPath:anIndexPath];
}

- (NSNumber*)retrieveCurrentTextFieldValueWithIndex:(int)anIndex forIndexPath:(NSIndexPath*)anIndexPath {
    return [self.formRowsKeyboardDataManager processRetrieveCurrentTextFieldValueWithIndex:anIndex forIndexPath:anIndexPath];
}

- (int)retrieveGlobalCurrentTextFieldIndex {
    return [self.formRowsKeyboardDataManager processRetrieveGlobalCurrentTextFieldIndex];
}

- (void)configGlobalCurrentTextFieldHighlightedFlag:(BOOL)aFlag {
    self.formRowsKeyboardDataManager.globalCurrentTextFieldHighlightedFlag = aFlag;
}

- (BOOL)retrieveGlobalCurrentTextFieldHighlightedFlag {
    return self.formRowsKeyboardDataManager.globalCurrentTextFieldHighlightedFlag;
}

- (NSIndexPath*)retrieveGlobalCurrentIndexPath {
    return self.formRowsKeyboardDataManager.globalCurrentIndexPath;
}

@end
