//
//  ViewController.h
//  TYTodayStatus
//
//  Created by Thabresh on 8/11/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    NSArray *tempCities;
    BOOL locationCalled;
    NSString* kYWACitys;
}
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UIButton *currentLoc;


@end

