//
//  PresenterBridgeGridViewController.m
//  iArcos
//
//  Created by David Kilmartin on 31/07/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PresenterBridgeGridViewController.h"
#import "PresenterPDFViewController.h"

@interface PresenterBridgeGridViewController ()

@end

@implementation PresenterBridgeGridViewController
@synthesize presenterBridgeGridDataManager = _presenterBridgeGridDataManager;
@synthesize myTableView = _myTableView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.presenterBridgeGridDataManager = [[[PresenterBridgeGridDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItems = nil;
    [self.presenterBridgeGridDataManager processRawData:self.files];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.presenterBridgeGridDataManager = nil;
    self.myTableView = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.presenterBridgeGridDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* mainPresenterCellIdentifier = @"IdMainPresenterTableViewCell";
    
    MainPresenterTableViewCell* cell = (MainPresenterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:mainPresenterCellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MainPresenterTableViewCell" owner:self options:nil];
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MainPresenterTableViewCell class]] && [[(MainPresenterTableViewCell *)nibItem reuseIdentifier] isEqualToString: mainPresenterCellIdentifier]) {
                cell = (MainPresenterTableViewCell*)nibItem;
                break;
            }
        }
    }
    cell.myDelegate = self;
    cell.indexPath = indexPath;
    [cell makeCellReadyToUse];
    
    NSMutableArray* subsetDisplayList = [self.presenterBridgeGridDataManager.displayList objectAtIndex:indexPath.row];
    for (int i = 0; i < [subsetDisplayList count]; i++) {
        NSMutableDictionary* presenterDict = [subsetDisplayList objectAtIndex:i];
        UILabel* tmpLabel = [cell.labelList objectAtIndex:i];
        tmpLabel.text = [presenterDict objectForKey:@"Title"];
        
        NSNumber* imageIur = [presenterDict objectForKey:@"ImageIUR"];
        
        NSMutableDictionary* imageDict = [self.presenterBridgeGridDataManager.branchLeafMiscUtils getImageWithImageIUR:imageIur];
        UIImage* anImage = [imageDict objectForKey:@"ImageObj"];
        UIButton* tmpBtn = [cell.btnList objectAtIndex:i];
        tmpBtn.enabled = YES;
        [tmpBtn setImage:anImage forState:UIControlStateNormal];
        UIView* tmpView = [cell.viewList objectAtIndex:i];
        tmpView.userInteractionEnabled = YES;
    }
    
    return cell;
}

#pragma mark MainPresenterTableViewCellDelegate
- (void)mainPresenterPressedWithView:(UIView *)aView indexPath:(NSIndexPath *)anIndexPath {
    NSMutableArray* subsetDisplayList = [self.presenterBridgeGridDataManager.displayList objectAtIndex:anIndexPath.row];
    NSDictionary* cellDict = [subsetDisplayList objectAtIndex:aView.tag];
    NSNumber* fileType = [cellDict objectForKey:@"employeeIUR"];
    PresenterViewController* PVC = [[PresenterPDFViewController alloc] initWithNibName:@"PresenterPDFViewController" bundle:nil];
    PVC.files = [NSMutableArray arrayWithObject:cellDict];
    PVC.fileType = fileType;
    PVC.presenterRequestSource = self.presenterRequestSource;
    [self.navigationController pushViewController:PVC animated:YES];
    [PVC release];
}

@end
