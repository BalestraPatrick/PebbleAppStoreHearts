//
//  ViewController.h
//  PebbleAppStoreHearts
//
//  Created by Patrick Balestra on 22/01/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartsData.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *appIDTextField;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *timeBetweenRefreshButton;

@property (strong, nonatomic) HeartsData *heartsData;

- (IBAction)scrollToSettings:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)openURL:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)timeButton:(UIButton *)sender;

@end
