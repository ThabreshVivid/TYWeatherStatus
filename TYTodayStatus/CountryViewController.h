//
//  CountryViewController.h
//  TYTodayStatus
//
//  Created by Thabresh on 8/11/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CountryListViewDelegate <NSObject>
- (void)didSelectCountry:(NSDictionary *)country andStatus:(BOOL)Status;
@end
@interface CountryViewController : UITableViewController
@property (nonatomic, assign) id<CountryListViewDelegate>delegate;
@property BOOL isCountry;
@property NSArray *arrCities;
- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate;
@end
