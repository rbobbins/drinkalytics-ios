//
//  LeaderboardViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "Person.h"
#import "HTTPController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"called");
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        HTTPController *http = [[HTTPController alloc] init];
        NSDictionary *rankings = [[NSDictionary alloc] initWithDictionary:[http getRankings]] ;
        
        [self setRankings:rankings];
        [self setSeniorMode:[[NSUserDefaults standardUserDefaults] valueForKey:@"userIsSenior"]];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if (self.seniorMode) {
        [self.navigationItem setTitle:@"Leaderboard"];
    } else {
        [self.navigationItem setTitle:@"This could be you next year!"];
    }
            [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self.rankings count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell;
    if (indexPath.section == 0) {
        NSInteger totalDrinks = 0;
        for (Person *person in [self.rankings allValues]) {
            totalDrinks = totalDrinks + person.numberOfDrinks;
        }
        NSInteger remainingDrinks = 2013 - totalDrinks;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%i down. %i to go.", totalDrinks, remainingDrinks];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat progressWidth = cell.bounds.size.width - 20;
        CGFloat progressHeight = cell.bounds.size.height;
        CGFloat originX = cell.bounds.origin.x + 10;
        CGFloat originY = cell.bounds.origin.y;
        
        UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, progressWidth, progressHeight)];
        
        [cell addSubview:progressBar];
        
        CGFloat doneWidth = (progressWidth - 30) / 2013 * totalDrinks ;
        UIView *done = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doneWidth, progressHeight)];
        [done setBackgroundColor:[UIColor greenColor]];
        
        CGFloat remainingWidth = progressWidth - doneWidth;
        UIView *remaining = [[UIView alloc] initWithFrame:CGRectMake(doneWidth, 0, remainingWidth, progressHeight)];
        [remaining setBackgroundColor:[UIColor lightGrayColor]];
        [progressBar addSubview:done];
        [progressBar addSubview:remaining];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:progressBar];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        NSString *rank = [NSString stringWithFormat:@"%i", (indexPath.row + 1)];
        Person *person = (Person *)[self.rankings objectForKey:rank];

        cell.textLabel.text = person.userId;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", person.numberOfDrinks];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
