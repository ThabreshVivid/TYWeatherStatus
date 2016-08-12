//
//  WeatherDaysInfo.h
//  TYTodayStatus
//
//  Created by Thabresh on 8/12/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDaysInfo : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *txtDay;
@property (weak, nonatomic) IBOutlet UILabel *txtCondition;
@property (weak, nonatomic) IBOutlet UILabel *txtLow;
@property (weak, nonatomic) IBOutlet UILabel *txtHigh;
@end
