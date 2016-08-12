//
//  TYWeather.m
//  TYTodayStatus
//
//  Created by Thabresh on 8/12/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "TYWeather.h"
#import "YWeatherAPI.h"
#import "AppDelegate.h"
#import "WeatherInfo.h"
#import "WeatherDaysInfo.h"
#define BACK_LOGO [UIImage imageNamed:@"back"]
@interface TYWeather ()
{
    NSMutableArray *infoArr;
    NSArray *infoNext10daysWeather;
}
@end

@implementation TYWeather

- (void)viewDidLoad {
    [super viewDidLoad];
    infoArr = [NSMutableArray new];
    [self.weatherTbl setFrame:self.view.frame];
    [self.weatherTbl registerNib:[UINib nibWithNibName:@"WeatherInfo" bundle:nil] forCellReuseIdentifier:@"WeatherInfo"];
    [self.weatherTbl registerNib:[UINib nibWithNibName:@"WeatherDaysInfo" bundle:nil] forCellReuseIdentifier:@"WeatherDaysInfo"];
    [[YWeatherAPI sharedManager] temperatureForLocation:self.locationName
                                                success:^(NSDictionary* result)
     {
         [self.showAct setHidden:YES];
         self.navigationItem.title = [result objectForKey:kYWACity];
         AppDelegate *app =[[UIApplication sharedApplication]delegate];
         NSDictionary *query = [app.weatherDetail objectForKey:@"query"];
         NSDictionary *results = [query objectForKey:@"results"];
         NSDictionary *channel = [results objectForKey:@"channel"];
         NSArray *astronomy = [channel valueForKey:@"astronomy"];
         [infoArr addObject:[NSString stringWithFormat:@"sunrise :%@",[astronomy valueForKey:@"sunrise"]]];
         [infoArr addObject:[NSString stringWithFormat:@"sunset :%@",[astronomy valueForKey:@"sunset"]]];
         NSArray *condition = [[channel objectForKey:@"item"]valueForKey:@"condition"];
         infoNext10daysWeather = [[channel objectForKey:@"item"]valueForKey:@"forecast"];
         self.navigationItem.prompt= [condition valueForKey:@"text"];
         [infoArr addObject:[NSString stringWithFormat:@"temp :%@",[condition valueForKey:@"temp"]]];
         [infoArr addObject:[NSString stringWithFormat:@"Condition :%@",[condition valueForKey:@"text"]]];
         [infoArr addObject:[NSString stringWithFormat:@"City :%@",[result objectForKey:kYWACity]]];
         [infoArr addObject:[NSString stringWithFormat:@"Country :%@",[result objectForKey:kYWACountry]]];
         [infoArr addObject:[NSString stringWithFormat:@"Latitude :%@",[result objectForKey:kYWALatitude]]];
         [infoArr addObject:[NSString stringWithFormat:@"Longtitude :%@",[result objectForKey:kYWALongtitude]]];
         [infoArr addObject:[NSString stringWithFormat:@"Region :%@",[result objectForKey:kYWARegion]]];
         [infoArr addObject:[NSString stringWithFormat:@"TemperatureInF :%@",[result objectForKey:kYWATemperatureInF]]];
         [infoArr addObject:[NSString stringWithFormat:@"TemperatureInC :%@",[result objectForKey:kYWATemperatureInC]]];
         [self.weatherTbl reloadData];
      }failure:^(id response, NSError* error)
     {
         [self.showAct setHidden:YES];
         [[[UIAlertView alloc]initWithTitle:error.description message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
         // Yikes, something went wrong
     }
     ];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:BACK_LOGO style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 46;
    }else{
        return 157;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
         return infoArr.count;
    }
    return infoNext10daysWeather.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.section==0) {
          WeatherInfo * cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherInfo" forIndexPath:indexPath];
          cell.txtTitle.text = [[infoArr[indexPath.row] componentsSeparatedByString:@":"]objectAtIndex:0];
          cell.txtDetail.text = [[infoArr[indexPath.row] componentsSeparatedByString:@":"]objectAtIndex:1];
           return cell;
      }else{
         WeatherDaysInfo * cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherDaysInfo" forIndexPath:indexPath];
         cell.txtDay.text = [infoNext10daysWeather valueForKey:@"day"][indexPath.row];
         cell.txtDate.text = [infoNext10daysWeather valueForKey:@"date"][indexPath.row];
         cell.txtLow.text = [infoNext10daysWeather valueForKey:@"low"][indexPath.row];
         cell.txtHigh.text = [infoNext10daysWeather valueForKey:@"high"][indexPath.row];
         cell.txtCondition.text = [infoNext10daysWeather valueForKey:@"text"][indexPath.row];
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Ten Days Weather";
    }
    return @"";
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cellContentView = [cell contentView];
    CGFloat rotationAngleDegrees = -30;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(0, cell.contentView.frame.size.height*4);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, -50.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50.0);
    cellContentView.layer.transform = transform;
    cellContentView.layer.opacity = 0.8;
    [UIView animateWithDuration:1.5 delay:00 usingSpringWithDamping:1.5 initialSpringVelocity:0.8 options:0 animations:^{
        cellContentView.layer.transform = CATransform3DIdentity;
        cellContentView.layer.opacity = 1;
    } completion:^(BOOL finished) {}];
}
-(void) backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
