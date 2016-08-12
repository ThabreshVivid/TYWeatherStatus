//
//  ViewController.m
//  TYTodayStatus
//
//  Created by Thabresh on 8/11/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "ViewController.h"
#import "TYWeather.h"
#import "YWeatherAPI.h"
#import "CountryViewController.h"
#import <MapKit/MapKit.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"
@interface ViewController ()<CountryListViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLPlacemark *placemark;
}
@property(nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.currentLoc setEnabled:NO];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
   
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    if (!locationCalled) {
        locationCalled = YES;
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        [[YWeatherAPI sharedManager] temperatureForCoordinate:LocationAtual
                                                      success:^(NSDictionary* result)
         {
            [self.currentLoc setEnabled:YES];
             kYWACitys = [result objectForKey:kYWACity];
         }failure:^(id response, NSError* error)
         {
             NSLog(@"%@",response);
             [[[UIAlertView alloc]initWithTitle:error.description message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
             // Yikes, something went wrong
         }];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CountryViewController *controller = (CountryViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"CountryViewController"];
    controller.delegate=self;
    [textField resignFirstResponder];
    if (textField.tag==1 ) {
        if (self.txtCountry.text.length == 0) {
           [[[UIAlertView alloc]initWithTitle:@"Please select country" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }else{
            controller.arrCities = tempCities;
            controller.isCountry = NO;
            [self.navigationController pushViewController:controller animated:YES];
        }        
    }else{
        controller.isCountry = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didSelectCountry:(NSDictionary *)country andStatus:(BOOL)Status
{
    if (Status) {
        self.txtCity.text = nil;
        self.txtCountry.text = [country valueForKey:@"name"];
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countriesToCities" ofType:@"json"]];
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        if (localError != nil) {
            [[[UIAlertView alloc]initWithTitle:[localError localizedDescription] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
        NSArray *countriesList = (NSArray *)parsedObject;
        
        NSArray *sortedStrings =
        [[countriesList valueForKey:self.txtCountry.text] sortedArrayUsingSelector:@selector(compare:)];
        
        tempCities = sortedStrings;
    }else{
        self.txtCity.text = [NSString stringWithFormat:@"%@",country];
    }
}
- (IBAction)clickToGetWeather:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TYWeather *controller = (TYWeather*)[mainStoryboard instantiateViewControllerWithIdentifier:@"TYWeather"];
    if ([sender tag]==1) {
        controller.locationName = kYWACitys;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        controller.locationName = self.txtCity.text;
        if ([self CheckValidation]) {
             [self.navigationController pushViewController:controller animated:YES];
        }        
    }
}
-(BOOL)CheckValidation
{
    if (self.txtCity.text.length==0 || self.txtCountry.text.length==0) {
        [[[UIAlertView alloc]initWithTitle:@"Please choose required fields" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        return FALSE;
    }return TRUE;
}
@end
