//
//  AppDelegate.m
//  PebbleAppStoreHearts
//
//  Created by Patrick Balestra on 22/01/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    BOOL pushNotifications = [[NSUserDefaults standardUserDefaults] boolForKey:@"pushNotifications"];
    
    NSString *timeBetweenRefresh = [[NSUserDefaults standardUserDefaults] stringForKey:@"timeBetweenRefresh"];
    
    if (pushNotifications) {
        if ([timeBetweenRefresh isEqualToString:@"0.5h"]) {
            [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:60*30];
        } else if ([timeBetweenRefresh isEqualToString:@"1.0h"]) {
            [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:60*60];
        } else if ([timeBetweenRefresh isEqualToString:@"12h"]) {
            [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:60*60*12];
        } else if ([timeBetweenRefresh isEqualToString:@"24h"]) {
            [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:60*60*24];
        }
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    __block NSString *newHeartsNumber;
    __block NSString *oldHeartsNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"heartsNumber"];
    
    NSString *appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppID"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pblweb.com/api/v1/hearts/%@.json", appID]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary  *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        newHeartsNumber = [NSString stringWithFormat:@"%@", dictionary[@"hearts"]];
        
        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
            NSLog(@"Failed");
        }
        
        if ([newHeartsNumber isEqualToString:oldHeartsNumber]) {
            completionHandler(UIBackgroundFetchResultNoData);
            NSLog(@"No Data");
        } else if (![newHeartsNumber isEqualToString:oldHeartsNumber]) {
            completionHandler(UIBackgroundFetchResultNewData);
            NSLog(@"New Data");
        }
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *localNotification = [UILocalNotification new];
        localNotification.fireDate = [NSDate date];
        localNotification.alertBody = [NSString stringWithFormat:@"New hearts number: %@ (+%d)", newHeartsNumber, (int)[newHeartsNumber integerValue] - (int)[oldHeartsNumber integerValue]];
        localNotification.applicationIconBadgeNumber = [newHeartsNumber integerValue];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [[NSUserDefaults standardUserDefaults] setObject:newHeartsNumber forKey:@"heartsNumber"];
        
    }];
    
    [dataTask resume];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
