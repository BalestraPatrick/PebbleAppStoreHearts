//
//  HeartsData.m
//  PebbleAppStoreHearts
//
//  Created by Patrick Balestra on 10/02/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "HeartsData.h"

@implementation HeartsData

- (void)downloadData {
    NSString *appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppID"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pblweb.com/api/v1/hearts/%@.json", appID]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary  *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.AppID = appID;
        self.hearts = dictionary[@"hearts"];
        self.lastUpdated = dictionary[@"lastUpdated"];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.hearts forKey:@"heartsNumber"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloading" object:nil];
        });
        
    }];
    
    [dataTask resume];
}

@end