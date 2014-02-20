//
//  ViewController.m
//  PebbleAppStoreHearts
//
//  Created by Patrick Balestra on 22/01/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"AppID"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"52cc32f86e5f706530000178" forKey:@"AppID"];
    }
	
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.heartsData = [HeartsData new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AppID"]){
        [self.heartsData downloadData];
    } else {
        [self.heartsData downloadData];
    }
    
    self.countLabel.alpha = 0.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"finishedDownloading" object:nil];
    
    self.scrollView.contentSize = CGSizeMake(320, 1136);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.appIDTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppID"];
    
    self.pushNotificationsSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"pushNotifications"];
    
    [self.timeBetweenRefreshButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"timeBetweenRefresh"] forState:UIControlStateNormal];
        
}

- (void)refreshUI {
    [UIView animateWithDuration:0.25 animations:^{
        self.countLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.countLabel.text = [NSString stringWithFormat:@"%@", self.heartsData.hearts];
            self.countLabel.alpha = 1.0;
        }];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:self.heartsData.hearts forKey:@"heartsNumber"];
}

- (IBAction)scrollToSettings:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(0, 568, 320, 1168) animated:YES];
}

- (IBAction)save:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.appIDTextField.text forKey:@"AppID"];
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 568) animated:YES];
    [self.appIDTextField resignFirstResponder];
    [self.heartsData downloadData];
    [self refreshUI];
}

- (IBAction)openURL:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dev-portal.getpebble.com/developer"]];
}

- (IBAction)switchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"pushNotifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)timeButton:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"0.5h"]) {
        [sender setTitle:@"1.0h" forState:UIControlStateNormal];
    } else if ([sender.titleLabel.text isEqualToString:@"1.0h"]) {
        [sender setTitle:@"12h" forState:UIControlStateNormal];
    } else if ([sender.currentTitle isEqualToString:@"12h"]) {
        [sender setTitle:@"24h" forState:UIControlStateNormal];
    } else if ([sender.currentTitle isEqualToString:@"24h"]) {
        [sender setTitle:@"0.5h" forState:UIControlStateNormal];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:sender.currentTitle forKey:@"timeBetweenRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end