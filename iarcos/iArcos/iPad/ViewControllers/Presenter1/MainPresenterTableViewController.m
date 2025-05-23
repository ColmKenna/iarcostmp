//
//  MainPresenterTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "MainPresenterTableViewController.h"

@interface MainPresenterTableViewController ()

@end

@implementation MainPresenterTableViewController
@synthesize parentMainPresenterRequestSource = _parentMainPresenterRequestSource;
@synthesize mainPresenterDataManager = _mainPresenterDataManager;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize custNameHeaderLabel = _custNameHeaderLabel;
@synthesize custAddrHeaderLabel = _custAddrHeaderLabel;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.mainPresenterDataManager = [[[MainPresenterDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)dealloc {
    self.mainPresenterDataManager = nil;
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
    self.custNameHeaderLabel = nil;
    self.custAddrHeaderLabel = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.parentMainPresenterRequestSource == PresenterRequestSourceMainMenu) {
        self.title = @"Presenter";
        [self configTitleWithColor:[UIColor clearColor]];
        [self hideHeaderLabelWithFlag:YES];
    } else {
        /*
        if ([[ArcosUtils convertNilToZero:[GlobalSharedClass shared].currentSelectedContactIUR] intValue] != 0) {
            self.title=[NSString stringWithFormat:@"Present to %@",[[OrderSharedClass sharedOrderSharedClass] currentContactName]];
        }else if ([GlobalSharedClass shared].currentSelectedLocationIUR !=nil){
            NSString* currentCustomerName=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
            self.title = [NSString stringWithFormat:@"Present to %@",currentCustomerName];
        } else {
            self.title=@"Presenter";
        }
        */
        if (self.custNameHeaderLabel == nil) {
            self.custNameHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 1, 550.0, 26.0)] autorelease];
            self.custNameHeaderLabel.textColor = [UIColor whiteColor];
            self.custNameHeaderLabel.font = [UIFont boldSystemFontOfSize:17.0];
        }
        if ([[ArcosUtils convertNilToZero:[GlobalSharedClass shared].currentSelectedContactIUR] intValue] != 0) {
            self.custNameHeaderLabel.text = [NSString stringWithFormat:@"%@ - %@", [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]], [[OrderSharedClass sharedOrderSharedClass] currentContactName]];
        } else {
            self.custNameHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
        }        
        [self.navigationController.navigationBar addSubview:self.custNameHeaderLabel];
        if (self.custAddrHeaderLabel == nil) {
            self.custAddrHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 28, 550.0, 14.0)] autorelease];
            self.custAddrHeaderLabel.font = [UIFont systemFontOfSize:12.0];
            self.custAddrHeaderLabel.textColor = [UIColor whiteColor];
        }
        self.custAddrHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerAddress]];
        [self.navigationController.navigationBar addSubview:self.custAddrHeaderLabel];
        if ([self.navigationItem.leftBarButtonItems count] == 0) {
            [self configTitleWithColor:[UIColor clearColor]];
            [self hideHeaderLabelWithFlag:NO];
        } else {
            [self configTitleWithColor:[UIColor whiteColor]];
            [self hideHeaderLabelWithFlag:YES];
        }
    }
    [self.mainPresenterDataManager retrieveMainPresenterDataList];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
}

- (void)hideHeaderLabelWithFlag:(BOOL)aFlag {
    self.custNameHeaderLabel.hidden = aFlag;
    self.custAddrHeaderLabel.hidden = aFlag;
}

- (void)configTitleWithColor:(UIColor*)aColor {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:aColor, NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:aColor}];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    if ([self.mainPresenterDataManager.displayList count] == 1) {
        NSMutableArray* subsetDisplayList = [self.mainPresenterDataManager.displayList objectAtIndex:0];
        if ([subsetDisplayList count] == 1) {
            UIButton* myButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [self mainPresenterPressedWithButton:myButton indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
    self.isNotFirstLoaded = YES;
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
    return [self.mainPresenterDataManager.displayList count];
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
    
    NSMutableArray* subsetDisplayList = [self.mainPresenterDataManager.displayList objectAtIndex:indexPath.row];
    for (int i = 0; i < [subsetDisplayList count]; i++) {
        NSMutableDictionary* descrDetailDict = [subsetDisplayList objectAtIndex:i];
        UILabel* tmpLabel = [cell.labelList objectAtIndex:i];
        tmpLabel.text = [descrDetailDict objectForKey:@"Detail"];
        
        NSNumber* imageIur = [descrDetailDict objectForKey:@"ImageIUR"];
        UIImage* anImage = nil;
        if ([imageIur intValue] > 0) {
            anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        }
        
        if (anImage == nil) {
            anImage = [UIImage imageNamed:@"Resources.png"];
        }
        UIButton* tmpBtn = [cell.btnList objectAtIndex:i];
        tmpBtn.enabled = YES;
        [tmpBtn setImage:anImage forState:UIControlStateNormal];
        UIView* tmpView = [cell.viewList objectAtIndex:i];
        tmpView.userInteractionEnabled = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark MainPresenterTableViewCellDelegate
- (void)mainPresenterPressedWithView:(UIView *)aView indexPath:(NSIndexPath *)anIndexPath {
    NSMutableArray* subsetDisplayList = [self.mainPresenterDataManager.displayList objectAtIndex:anIndexPath.row];
    NSDictionary* cellDict = [subsetDisplayList objectAtIndex:aView.tag];
    UIViewController* myResultViewController = [self retrieveNewPresenterViewControllerResult:cellDict];
    [self.navigationController pushViewController:myResultViewController animated:YES];
}
- (void)mainPresenterPressedWithButton:(UIButton *)aBtn indexPath:(NSIndexPath *)anIndexPath {
//    NSMutableArray* subsetDisplayList = [self.mainPresenterDataManager.displayList objectAtIndex:anIndexPath.row];
//    NSDictionary* cellDict = [subsetDisplayList objectAtIndex:aBtn.tag];
//    UIViewController* myResultViewController = [self retrieveNewPresenterViewControllerResult:cellDict];
//    [self.navigationController pushViewController:myResultViewController animated:YES];
}

- (UIViewController*)retrieveNewPresenterViewControllerResult:(NSDictionary*)mainPresenterCellDict {
    UIViewController* resultViewController = nil;
    NewPresenterViewController* myNewPresenterViewController = [[[NewPresenterViewController alloc] initWithNibName:@"NewPresenterViewController" bundle:nil] autorelease];
    myNewPresenterViewController.parentPresenterRequestSource = self.parentMainPresenterRequestSource;
    myNewPresenterViewController.currentDescrDetailIUR = [mainPresenterCellDict objectForKey:@"DescrDetailIUR"];
    NSMutableArray* presenterProductList = [[ArcosCoreData sharedArcosCoreData]presenterParentProducts:[mainPresenterCellDict objectForKey:@"DescrDetailIUR"]];
    
    if ([presenterProductList count] == 1) {
        NSMutableDictionary* myResultDict = [myNewPresenterViewController retrievePresenterViewControllerResult:[presenterProductList objectAtIndex:0]];
        PresenterViewController* PVC = [myResultDict objectForKey:@"MyPresenterViewController"];
        if (PVC != nil) {
//            PVC.files = [myResultDict objectForKey:@"Data"];
//            PVC.fileType = [myResultDict objectForKey:@"FileType"];
//            PVC.presenterRequestSource = self.parentMainPresenterRequestSource;
            resultViewController = PVC;
        }
    }
    if (resultViewController == nil) {
        resultViewController = myNewPresenterViewController;
    }
    return resultViewController;
}

@end
