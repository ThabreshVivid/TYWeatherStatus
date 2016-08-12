//
//  TYWeather.h
//  TYTodayStatus
//
//  Created by Thabresh on 8/12/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWeather : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property NSString *locationName;
@property (weak, nonatomic) IBOutlet UITableView *weatherTbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *showAct;

@end
