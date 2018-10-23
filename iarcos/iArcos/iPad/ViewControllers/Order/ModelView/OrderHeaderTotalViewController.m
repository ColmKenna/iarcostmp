//
//  OrderHeaderTotalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 18/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderHeaderTotalViewController.h"
#import "GlobalSharedClass.h"

@implementation OrderHeaderTotalViewController
@synthesize totalValue;
@synthesize totalOrders;
@synthesize totalPoints;
@synthesize averageValue;
@synthesize dailyTarget;
@synthesize weeklyTarget;
@synthesize monthlyTarget;
@synthesize yearlyTarget;
@synthesize dailyPrecentage;
@synthesize weeklyPrecentage;
@synthesize monthlyPrecentage;
@synthesize yearlyPrecentage;
@synthesize delegate;
@synthesize theData;
@synthesize fromDateLabel;
@synthesize toDateLabel;
@synthesize dailyLabel;
@synthesize weeklyLabel;
@synthesize monthlyLabel;
@synthesize yearlyLabel;
@synthesize summaryTypeLabel;
@synthesize passImage;
@synthesize  bottomStatement;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)dealloc
{
    [totalPoints release];
    [totalOrders release];
    [totalValue release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.9f];

    totalOrders.text=[[self.theData objectForKey:@"totalOrders"]stringValue];
    totalValue.text=[NSString stringWithFormat:@"%1.2f",[[self.theData objectForKey:@"totalValue"]floatValue]];
    totalPoints.text=[[self.theData objectForKey:@"totalPoints"]stringValue];
    averageValue.text=[NSString stringWithFormat:@"%1.2f",[[self.theData objectForKey:@"averageValue"]floatValue]];

    NSLog(@"%@---%@---%@",[[self.theData objectForKey:@"totalOrders"]stringValue],[[self.theData objectForKey:@"totalValue"]stringValue],[[self.theData objectForKey:@"totalPoints"]stringValue]);
    //targets
    dailyTarget.text=[NSString stringWithFormat:@"%1.2f",[[self.theData objectForKey:@"dailyTarget"]floatValue]];
    weeklyTarget.text=[NSString stringWithFormat:@"%1.2f",[[self.theData objectForKey:@"weeklyTarget"]floatValue]];
    monthlyTarget.text=[NSString stringWithFormat:@"%1.2f",[[self.theData objectForKey:@"monthlyTarget"]floatValue]];
    yearlyTarget.text=[NSString stringWithFormat:@"%1.2f",[[self.theData objectForKey:@"yearlyTarget"]floatValue]];
    //targets presentage
    float dailyPer=[[self.theData objectForKey:@"dailyPresentage"]floatValue];
    float weeklyPer=[[self.theData objectForKey:@"weekPresentage"]floatValue];
    float monthlyPer=[[self.theData objectForKey:@"monthPresentage"]floatValue];
    float yearlyPer=[[self.theData objectForKey:@"yearPresentage"]floatValue];
    
    dailyPrecentage.text=[NSString stringWithFormat:@"%1.2f%%   Done",dailyPer];
    if (dailyPer<100) {
        [dailyPrecentage setTextColor:[UIColor orangeColor]];
    }
    weeklyPrecentage.text=[NSString stringWithFormat:@"%1.2f%%   Done",weeklyPer];
    if (weeklyPer<100) {
        [weeklyPrecentage setTextColor:[UIColor orangeColor]];
    }
    monthlyPrecentage.text=[NSString stringWithFormat:@"%1.2f%%   Done",monthlyPer];
    if (monthlyPer<100) {
        [monthlyPrecentage setTextColor:[UIColor orangeColor]];
    }
    yearlyPrecentage.text=[NSString stringWithFormat:@"%1.2f%%   Done",yearlyPer];
    if (yearlyPer<100) {
        [yearlyPrecentage setTextColor:[UIColor orangeColor]];
    }
    
    //display type
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    switch ([[self.theData objectForKey:@"orderDisplyType"]intValue]) {
        case 0:
        {
            summaryTypeLabel.text=@"All";
            fromDateLabel.text=[formatter stringFromDate:[[GlobalSharedClass shared]thisYear]];
            toDateLabel.text=[formatter stringFromDate:[NSDate date]];
            
            NSString* over=@"";
            if (yearlyPer<100) {
                [passImage setImage:[UIImage imageNamed:@"cross.png"]];
                [bottomStatement setTextColor:[UIColor redColor]];
                over=@"to";
            }else{
                [passImage setImage:[UIImage imageNamed:@"tick.png"]];
                [bottomStatement setTextColor:[UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
                over=@"over";
            }
            
            float diff=fabsf([[self.theData objectForKey:@"yearlyTarget"]floatValue]-[[self.theData objectForKey:@"totalValue"]floatValue]);
            NSString* bottomString=[NSString stringWithFormat:@"%1.2f (%1.2f%%) %@ your yearly target !",diff,fabsf(100-yearlyPer),over];
            bottomStatement.text=bottomString;
            
            break;
        }
        case 1:
        {
            summaryTypeLabel.text=@"Daily";
            [dailyLabel setBackgroundColor:[UIColor orangeColor]];
            fromDateLabel.text=[formatter stringFromDate:[NSDate date]];
            toDateLabel.text=[formatter stringFromDate:[NSDate date]];
            

            NSString* over=@"";
            if (dailyPer<100) {
                [passImage setImage:[UIImage imageNamed:@"cross.png"]];
                [bottomStatement setTextColor:[UIColor redColor]];
                over=@"to";
            }else{
                [passImage setImage:[UIImage imageNamed:@"tick.png"]];
                [bottomStatement setTextColor:[UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
                over=@"over";
            }
            
            float diff=fabsf([[self.theData objectForKey:@"dailyTarget"]floatValue]-[[self.theData objectForKey:@"totalValue"]floatValue]);
            NSString* bottomString=[NSString stringWithFormat:@"%1.2f (%1.2f%%) %@ your daily target !",diff,fabsf(100-dailyPer),over];
            bottomStatement.text=bottomString;
            break;
        }
        case 2:
        {
            summaryTypeLabel.text=@"Weekly";
            [weeklyLabel setBackgroundColor:[UIColor orangeColor]];
            fromDateLabel.text=[formatter stringFromDate:[[GlobalSharedClass shared]thisWeek]];
            toDateLabel.text=[formatter stringFromDate:[NSDate date]];
            
            NSString* over=@"";
            if (weeklyPer<100) {
                [passImage setImage:[UIImage imageNamed:@"cross.png"]];
                [bottomStatement setTextColor:[UIColor redColor]];
                over=@"to";
            }else{
                [passImage setImage:[UIImage imageNamed:@"tick.png"]];
                [bottomStatement setTextColor:[UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
                over=@"over";
            }
            
            float diff=fabsf([[self.theData objectForKey:@"weeklyTarget"]floatValue]-[[self.theData objectForKey:@"totalValue"]floatValue]);
            NSString* bottomString=[NSString stringWithFormat:@"%1.2f (%1.2f%%) %@ your weekly target !",diff,fabsf(100-weeklyPer),over];
            bottomStatement.text=bottomString;
            break;
        }
        case 3:
        {
            summaryTypeLabel.text=@"Monthly";
            [monthlyLabel setBackgroundColor:[UIColor orangeColor]];
            fromDateLabel.text=[formatter stringFromDate:[[GlobalSharedClass shared]thisMonth]];
            toDateLabel.text=[formatter stringFromDate:[NSDate date]];

            NSString* over=@"";
            if (monthlyPer<100) {
                [passImage setImage:[UIImage imageNamed:@"cross.png"]];
                [bottomStatement setTextColor:[UIColor redColor]];
                over=@"to";
            }else{
                [passImage setImage:[UIImage imageNamed:@"tick.png"]];
                [bottomStatement setTextColor:[UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
                over=@"over";
                
            }
            
            
            float diff=fabsf([[self.theData objectForKey:@"monthlyTarget"]floatValue]-[[self.theData objectForKey:@"totalValue"]floatValue]);
            NSString* bottomString=[NSString stringWithFormat:@"%1.2f (%1.2f%%) %@ your monthly target !",diff,fabsf(100-monthlyPer),over];
            bottomStatement.text=bottomString;
            
            break;
        }
        case 4:
        {
            summaryTypeLabel.text=@"Yearly";
            [yearlyLabel setBackgroundColor:[UIColor orangeColor]];
            fromDateLabel.text=[formatter stringFromDate:[[GlobalSharedClass shared]thisYear]];
            toDateLabel.text=[formatter stringFromDate:[NSDate date]];
            
            NSString* over=@"";
            if (yearlyPer<100) {
                [passImage setImage:[UIImage imageNamed:@"cross.png"]];
                [bottomStatement setTextColor:[UIColor redColor]];
                over=@"to";
            }else{
                [passImage setImage:[UIImage imageNamed:@"tick.png"]];
                [bottomStatement setTextColor:[UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
                over=@"over";
            }
            
            float diff=fabsf([[self.theData objectForKey:@"yearlyTarget"]floatValue]-[[self.theData objectForKey:@"totalValue"]floatValue]);
            NSString* bottomString=[NSString stringWithFormat:@"%1.2f (%1.2f%%) %@ your yearly target !",diff,fabsf(100-yearlyPer),over];
            bottomStatement.text=bottomString;
            break;
        }
        default:
            break;
    }
    [formatter release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    

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
//actions
-(IBAction)donePressed:(id)sender{
    [self.delegate didDismissModalView];
    
}

@end
