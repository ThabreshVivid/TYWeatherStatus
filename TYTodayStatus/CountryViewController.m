//
//  CountryViewController.m
//  TYTodayStatus
//
//  Created by Thabresh on 8/11/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "CountryViewController.h"
#define BACK_LOGO [UIImage imageNamed:@"back"]
@interface CountryViewController ()
{
    NSArray *countriesList;
}
@end

@implementation CountryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.arrCities.count==0) {
        self.navigationItem.title = @"Countries";
    }else{
        self.navigationItem.title = @"Cities";
    }
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:BACK_LOGO style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
    self.navigationController.navigationBarHidden = NO;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TYCountries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    countriesList = (NSArray *)parsedObject;
    [self.tableView reloadData];
    NSArray * cells = self.tableView.visibleCells;
    CGFloat tableHeight = self.tableView.bounds.size.height;
    
    for (UITableViewCell*cell in cells) {
        cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
    }
    NSInteger index = 0;
    for (UITableViewCell*cell in cells) {
        [UIView animateWithDuration:2.0 delay:0.05 * index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
        index += 1;
    }
}

-(void) backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCities.count?self.arrCities.count:countriesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    if (self.arrCities.count==0) {
        cell.textLabel.text = [countriesList valueForKey:@"name"][indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Code %@ ,Dialer code%@",[countriesList valueForKey:@"code"][indexPath.row],[countriesList valueForKey:@"dial_code"][indexPath.row]];
    }else{
         cell.textLabel.text = self.arrCities[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (self.arrCities.count==0) {
             [self.delegate didSelectCountry:[countriesList objectAtIndex:[tableView indexPathForSelectedRow].row]andStatus:self.isCountry];
     }else{
             [self.delegate didSelectCountry:[self.arrCities objectAtIndex:[tableView indexPathForSelectedRow].row]andStatus:self.isCountry];
     }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
